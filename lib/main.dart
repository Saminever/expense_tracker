import 'package:expence_tracker_app/model/expense_model.dart';
import 'package:expence_tracker_app/model/group_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'routes.dart'; // yahan routes file ko import karo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GroupModelAdapter());
  Hive.registerAdapter(ExpenseModelAdapter());
  await Hive.openBox<GroupModel>('groups');
  await Hive.openBox<ExpenseModel>('expenses');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
    );
  }
}
