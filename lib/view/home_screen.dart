import 'package:expence_tracker_app/model/group_model.dart';
import 'package:expence_tracker_app/view/group_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
 

class HomeScreen extends StatelessWidget {
  final groupBox = Hive.box<GroupModel>('groups');
  final TextEditingController groupController = TextEditingController();

  HomeScreen({super.key});

  void addGroup() {
    final name = groupController.text.trim();
    if (name.isNotEmpty) {
      groupBox.add(GroupModel(name: name));
      groupController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: ValueListenableBuilder(
        valueListenable: groupBox.listenable(),
        builder: (context, Box<GroupModel> box, _) {
          final groups = box.values.toList();
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return ListTile(
                title: Text(group.name),
                onTap: () => Get.to(() => GroupScreen(groupName: group.name)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Add Group"),
            content: TextField(
              controller: groupController,
              decoration: const InputDecoration(hintText: "Enter group name"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  addGroup();
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
