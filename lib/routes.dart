import 'package:expence_tracker_app/view/group_screen.dart';
import 'package:expence_tracker_app/view/group_sumerry.dart';
import 'package:expence_tracker_app/view/home_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String home = '/';
  static const String group = '/group';
  static const String chart = '/chart';

  static final routes = [
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(
        name: group,
        page: () => const GroupScreen(
              groupName: '',
            )),
    GetPage(name: chart, page: () => GroupSummaryScreen()),
  ];
}
