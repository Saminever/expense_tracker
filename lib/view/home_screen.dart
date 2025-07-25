import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/group_controller.dart';
// import '../models/group_model.dart';
// import 'group_screen.dart';

class HomeScreen extends StatelessWidget {
  // final GroupController controller = Get.put(GroupController());

  @override
  Widget build(BuildContext context) {
    final _groupController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: Text('Groups')),
      // body: Obx(() => ListView.builder(
      //       itemCount: controller.groups.length,
      //       itemBuilder: (_, index) {
      //         final group = controller.groups[index];
      //         return ListTile(
      //           title: Text(group.groupName),
      //           subtitle: Text(group.createdAt.toString()),
      //           onTap: () {
      //             Get.to(() => GroupScreen(group: group));
      //           },
      //         );
      //       },
      //     )),
      // floatingActionButton: FloatingActionButton(
      // onPressed: () {
      //   Get.defaultDialog(
      //     title: "New Group",
      //     content: Column(
      //       children: [
      //         TextField(
      //           controller: _groupController,
      //           decoration: InputDecoration(labelText: "Group Name"),
      //         ),
      //         ElevatedButton(
      //           onPressed: () {
      //             // final newGroup = GroupModel(
      //             //   groupName: _groupController.text.trim(),
      //             //   createdAt: selectedDate,
      //             // );
      //             // controller.addGroup(newGroup);
      //             // Get.back();
      //           },
      //           child: Text("Create"),
      //         )
      //       ],
      //     ),
      //   );
      // },
      //     child: Icon(Icons.add),
      //   ),
    );
  }
}
