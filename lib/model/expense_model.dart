import 'package:hive/hive.dart';

part 'expense_model.g.dart';
 @HiveType(typeId: 1)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  String groupName;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date;

  // @HiveField(4)
  // bool isGiven; // true = diya, false = liya

  ExpenseModel({
    required this.groupName,
    required this.title,
    required this.amount,
    required this.date,
    // required this.isGiven,
  });
}
