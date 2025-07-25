import 'package:expence_tracker_app/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';

class GroupSummaryScreen extends StatefulWidget {
  const GroupSummaryScreen({super.key});

  @override
  State<GroupSummaryScreen> createState() => _GroupSummaryScreenState();
}

class _GroupSummaryScreenState extends State<GroupSummaryScreen> {
  late Box<ExpenseModel> _expenseBox;

  @override
  void initState() {
    super.initState();
    _expenseBox = Hive.box<ExpenseModel>('expenses');
  }

  Map<String, double> getGroupTotals() {
    Map<String, double> totals = {};
    for (var expense in _expenseBox.values) {
      totals.update(
        expense.groupName,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return totals;
  }

  String getTopSpendingGroup() {
    final data = getGroupTotals();
    if (data.isEmpty) return "No data available";
    final top = data.entries.reduce((a, b) => a.value > b.value ? a : b);
    return "${top.key} (Rs. ${top.value.toStringAsFixed(2)})";
  }

  Widget buildGroupExpenseChart() {
    final data = getGroupTotals();
    final total = data.values.fold(0.0, (sum, item) => sum + item);

    if (total == 0) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("No expenses added yet."),
        ),
      );
    }

    final sections = data.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      final color = Colors.primaries[
          data.keys.toList().indexOf(entry.key) % Colors.primaries.length];
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: "${entry.key} (${percentage.toStringAsFixed(1)}%)",
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Expense Distribution",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topGroup = getTopSpendingGroup();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Summary"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildGroupExpenseChart(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Top Spending Group: $topGroup",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
