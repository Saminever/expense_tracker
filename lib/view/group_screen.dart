import 'package:expence_tracker_app/model/expense_model.dart';
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
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void addExpense() {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    if (title.isNotEmpty && amount > 0) {
      final newExpense = ExpenseModel(
        groupName: widget.groupName,
        title: title,
        amount: amount,
        date: DateTime.now(),
      );
      _expenseBox.add(newExpense);
      titleController.clear();
      amountController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenses = _expenseBox.values
        .where((e) => e.groupName == widget.groupName)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.groupName)),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final e = expenses[index];
          return ListTile(
            title: Text(e.title),
            subtitle: Text("${e.amount} PKR"),
            trailing: Text(e.date.toLocal().toString().split(' ')[0]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Add Expense"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "Title"),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Amount"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  addExpense();
                  Get.back();
                },
                child: const Text("Add"),
              )
            ],
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
