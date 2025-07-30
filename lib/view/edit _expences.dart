import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/expense_model.dart';

class EditExpenseScreen extends StatefulWidget {
  final int expenseKey;
  final ExpenseModel expense;

  EditExpenseScreen({required this.expenseKey, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late Box<ExpenseModel> _expenseBox;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _expenseBox = Hive.box<ExpenseModel>('expenses');
  }

  void _saveChanges() {
    final updatedExpense = ExpenseModel(
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      groupName: widget.expense.groupName,
      date: DateTime.now(),
    );

    _expenseBox.put(widget.expenseKey, updatedExpense);
    Navigator.pop(context); // or Get.back()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Expense Title"),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Amount"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text("Update Expense"),
            )
          ],
        ),
      ),
    );
  }
}
