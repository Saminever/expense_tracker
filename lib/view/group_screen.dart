import 'dart:ui';
import 'package:expence_tracker_app/model/expense_model.dart';
import 'package:expence_tracker_app/model/group_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class GroupScreen extends StatefulWidget {
  final String groupName;
  const GroupScreen({super.key, required this.groupName});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final _expenseBox = Hive.box<ExpenseModel>('expenses');
  final _groupBox = Hive.box<GroupModel>('groups');

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final searchController = TextEditingController();

  late String currentGroupName;
  bool isSearching = false;
  List<ExpenseModel> filteredExpenses = [];

  @override
  void initState() {
    super.initState();
    currentGroupName = widget.groupName;
    searchController.addListener(_filterExpenses);
    _loadExpenses();
  }

  void _loadExpenses() {
    filteredExpenses = _expenseBox.values
        .where((e) => e.groupName == currentGroupName)
        .toList();
    setState(() {});
  }

  void _filterExpenses() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredExpenses = _expenseBox.values
          .where((e) =>
              e.groupName == currentGroupName &&
              e.title.toLowerCase().contains(query))
          .toList();
    });
  }

  void showExpenseSheet({ExpenseModel? expense, int? index}) {
    if (expense != null) {
      titleController.text = expense.title;
      amountController.text = expense.amount.toString();
    } else {
      titleController.clear();
      amountController.clear();
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.85,
          minChildSize: 0.3,
          builder: (_, controller) => Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: controller,
              children: [
                Text(
                  expense != null ? 'Edit Expense' : 'Add New Expense',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Amount (PKR)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final amount =
                        double.tryParse(amountController.text.trim()) ?? 0;
                    if (title.isNotEmpty && amount > 0) {
                      final newExpense = ExpenseModel(
                        groupName: currentGroupName,
                        title: title,
                        amount: amount,
                        date: DateTime.now(),
                      );

                      if (expense != null && index != null) {
                        _expenseBox.putAt(index, newExpense);
                      } else {
                        _expenseBox.add(newExpense);
                      }

                      _loadExpenses();
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(expense != null ? 'Save Changes' : 'Add Expense'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void editGroupName() {
    final controller = TextEditingController(text: currentGroupName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Rename Group"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "New Group Name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                final index = _groupBox.values
                    .toList()
                    .indexWhere((g) => g.name == currentGroupName);

                if (index != -1) {
                  _groupBox.putAt(index, GroupModel(name: newName));

                  for (int i = 0; i < _expenseBox.length; i++) {
                    final expense = _expenseBox.getAt(i);
                    if (expense != null &&
                        expense.groupName == currentGroupName) {
                      _expenseBox.putAt(
                        i,
                        ExpenseModel(
                          groupName: newName,
                          title: expense.title,
                          amount: expense.amount,
                          date: expense.date,
                        ),
                      );
                    }
                  }

                  setState(() {
                    currentGroupName = newName;
                  });
                }
              }
              Get.back();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void deleteExpense(int index) {
    _expenseBox.deleteAt(index);
    _loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final total = filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search expenses...",
                  border: InputBorder.none,
                ),
              )
            : Text(currentGroupName),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  _loadExpenses();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showExpenseSheet(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') editGroupName();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text("Rename Group"),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.teal.shade100,
            padding: const EdgeInsets.all(20),
            child: Text(
              "Total: ${total.toStringAsFixed(2)} PKR",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredExpenses.length,
              itemBuilder: (_, index) {
                final e = filteredExpenses[index];
                final actualIndex = _expenseBox.values.toList().indexOf(e);

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  elevation: 2,
                  child: ListTile(
                    title: Text(e.title),
                    subtitle: Text(
                      "${e.amount.toStringAsFixed(2)} PKR • ${e.date.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(fontSize: 13),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              showExpenseSheet(expense: e, index: actualIndex),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteExpense(actualIndex),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
