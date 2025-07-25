import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import '../model/expense_model.dart';
import 'package:collection/collection.dart';

class GroupSummaryScreen extends StatefulWidget {
  const GroupSummaryScreen({super.key});

  @override
  State<GroupSummaryScreen> createState() => _GroupSummaryScreenState();
}

class _GroupSummaryScreenState extends State<GroupSummaryScreen> {
  late Box<ExpenseModel> _expenseBox;
  int touchedIndex = -1;

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

  @override
  Widget build(BuildContext context) {
    final data = getGroupTotals();
    final total = data.values.fold(0.0, (sum, item) => sum + item);

    if (total == 0) {
      return const Scaffold(
        body: Center(child: Text("No expenses added yet.")),
      );
    }

    final sections = data.entries.mapIndexed((index, entry) {
      final color = Colors.primaries[index % Colors.primaries.length];
      final value = entry.value;
      return PieChartSectionData(
        color: color,
        value: value,
        showTitle: false,
        radius: touchedIndex == index ? 70 : 60,
      );
    }).toList();

    final legendItems = data.entries.mapIndexed((index, entry) {
      final color = Colors.primaries[index % Colors.primaries.length];
      final percent = ((entry.value / total) * 100).toStringAsFixed(1);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 14, height: 14, color: color),
            const SizedBox(width: 8),
            Text('${entry.key}: $percent %'),
          ],
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Extension Costs")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 0,
                        sectionsSpace: 2,
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  response == null ||
                                  response.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex =
                                  response.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: legendItems,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Total Expense: Rs. ${total.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
