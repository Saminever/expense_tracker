import 'package:hive/hive.dart';

part 'group_model.g.dart';

@HiveType(typeId: 0)
class GroupModel extends HiveObject {
  @HiveField(0)
  final String name;

  GroupModel({required this.name
  
  });

  get groupName => null;
}
