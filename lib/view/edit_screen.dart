//  import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';

// import '../model/group_model.dart';
// import 'group_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final _groupBox = Hive.box<GroupModel>('groups');
//   final groupNameController = TextEditingController();

//   void addGroup() {
//     final name = groupNameController.text.trim();
//     if (name.isNotEmpty) {
//       _groupBox.add(GroupModel(name: name));
//       groupNameController.clear();
//       setState(() {});
//     }
//   }

//   void editGroup(GroupModel group, int index) {
//     groupNameController.text = group.name;

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Edit Group"),
//         content: TextField(
//           controller: groupNameController,
//           decoration: const InputDecoration(hintText: "Group Name"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               final updatedName = groupNameController.text.trim();
//               if (updatedName.isNotEmpty) {
//                 final updatedGroup = GroupModel(name: updatedName);
//                 _groupBox.putAt(index, updatedGroup);
//                 groupNameController.clear();
//                 setState(() {});
//               }
//               Get.back();
//             },
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }

//   void deleteGroup(int index) {
//     _groupBox.deleteAt(index);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final groups = _groupBox.values.toList();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Groups")),
//       body: ListView.builder(
//         itemCount: groups.length,
//         itemBuilder: (context, index) {
//           final group = groups[index];
//           return ListTile(
//             title: Text(group.name),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue),
//                   onPressed: () => editGroup(group, index),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => deleteGroup(index),
//                 ),
//               ],
//             ),
//             onTap: () {
//               Get.to(() => GroupScreen(groupName: group.name));
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: const Text("Add Group"),
//             content: TextField(
//               controller: groupNameController,
//               decoration: const InputDecoration(hintText: "Group Name"),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   addGroup();
//                   Get.back();
//                 },
//                 child: const Text("Add"),
//               ),
//             ],
//           ),
//         ),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
