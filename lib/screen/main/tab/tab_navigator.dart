// import 'package:gosari_app/screen/main/tab/tab_item.dart';
// import 'package:flutter/material.dart';
//
// class TabNavigator extends StatelessWidget {
//   const TabNavigator({
//     super.key,
//     required this.tabItem,
//     required this.navigatorKey,
//   });
//
//   final GlobalKey<NavigatorState> navigatorKey;
//   final TabItem tabItem;
//
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//         key: navigatorKey,
//         onGenerateRoute: (routeSettings) {
//           return MaterialPageRoute(
//             builder: (context) => tabItem.tabPage,
//           );
//         });
//   }
// }
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
    if (tabItem.tabPage != null) { // tabPage가 null이 아닐 때만 사용
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