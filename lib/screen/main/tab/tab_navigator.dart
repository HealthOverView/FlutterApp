import 'package:gosari_app/screen/main/tab/home/f_home.dart';
import 'package:gosari_app/screen/main/tab/tab_item.dart';
import 'package:flutter/material.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    Key? key,
    required this.tabItem,
    required this.navigatorKey,
  }) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  @override
  Widget build(BuildContext context) {
    // 특정 페이지가 있는 경우에만 네비게이터 반환
    if (tabItem.tabPage != null) {
      return Navigator(
        key: navigatorKey,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => HomeFragment(),
          );
        },
      );
    } else {
      return Container(); // tabPage가 null인 경우 기본값 반환
    }
  }
}