// ✅ HomeScreen.dart
import 'package:expence_tracker_app/model/group_model.dart';
import 'package:expence_tracker_app/model/expense_model.dart';
import 'package:expence_tracker_app/view/group_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final groupBox = Hive.box<GroupModel>('groups');
  final expenseBox = Hive.box<ExpenseModel>('expenses');
  final TextEditingController groupController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<GroupModel> filteredGroups = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    filteredGroups = groupBox.values.toList();
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredGroups = groupBox.values
          .where((group) => group.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void addGroup() {
    final name = groupController.text.trim();
    if (name.isNotEmpty) {
      groupBox.add(GroupModel(name: name));
      groupController.clear();
      _onSearchChanged();
    }
  }

  void deleteGroup(int indexInBox, String groupName) async {
    // Delete all expenses in this group
    final expensesToDelete =
        expenseBox.values.where((e) => e.groupName == groupName).toList();
    for (var e in expensesToDelete) {
      await e.delete();
    }

    // Delete the group
    groupBox.deleteAt(indexInBox);
    _onSearchChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text("Expense Tracker",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: _buildSearchBar(context),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.pie_chart),
              title: const Text('View Chart'),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/chart');
              },
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: groupBox.listenable(),
        builder: (context, Box<GroupModel> box, _) {
          filteredGroups = searchController.text.isEmpty
              ? box.values.toList()
              : filteredGroups;

          if (filteredGroups.isEmpty) {
            return const Center(
              child: Text(
                "No matching groups found!",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filteredGroups.length,
            itemBuilder: (context, index) {
              final group = filteredGroups[index];
              final boxIndex =
                  box.values.toList().indexOf(group); // required for delete

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(
                    group.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteGroup(boxIndex, group.name),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.teal),
                    ],
                  ),
                  onTap: () => Get.to(() => GroupScreen(groupName: group.name)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("Create New Group"),
            content: TextField(
              controller: groupController,
              decoration: const InputDecoration(
                hintText: "Enter group name",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  addGroup();
                  Get.back();
                },
                child: const Text("Add"),
              ),
            ],
          ),
        ),
        label: const Text("Add Group"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? []
            : [
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: TextField(
        controller: searchController,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          hintText: "Search groups...",
          hintStyle: TextStyle(color: Theme.of(context).hintColor),
          prefixIcon:
              Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _onSearchChanged();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
