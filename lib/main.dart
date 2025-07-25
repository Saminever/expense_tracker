import 'package:expence_tracker_app/model/expense_model.dart';
import 'package:expence_tracker_app/model/group_model.dart';
import 'package:expence_tracker_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(GroupModelAdapter());
  Hive.registerAdapter(ExpenseModelAdapter());

  await Hive.openBox<GroupModel>('groups');
  await Hive.openBox<ExpenseModel>('expenses');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
