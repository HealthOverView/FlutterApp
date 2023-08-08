// import 'package:flutter/material.dart';
// import 'package:gosari_app/common/common.dart';
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // systemOverlayStyle: SystemUiOverlayStyle(
//         //   statusBarColor: Colors.green, // <-- SEE HERE
//         //   statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
//         //   statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
//         // ),
//         elevation: 1,
//         backgroundColor: context.appColors.appBg,
//         centerTitle: true, // Center align the title
//         title: Text('분석하기',
//             style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//                 color: context.appColors.mosttext,
//             )), // Added "Analysis" text
//       ),
//       body: Padding(
//       ),
//     );
//   }
// }

// import 'package:after_layout/after_layout.dart';
// import 'package:gosari_app/common/cli_common.dart';
import 'package:flutter/services.dart';
import 'package:gosari_app/screen/main/tab/tab_item.dart';
import 'package:gosari_app/screen/main/tab/tab_navigator.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../common/common.dart';
import 'w_menu_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabItem _currentTab = TabItem.home;

  //option+command+L
  final tabs = [
    TabItem.home,
    TabItem.dialog,
  ];
  final List<GlobalKey<NavigatorState>> navigatorKeys = [];

  int get _currentIndex => tabs.indexOf(_currentTab);

  GlobalKey<NavigatorState> get _currentTabNavigationKey =>
      navigatorKeys[_currentIndex];

  bool get extendBody => true;

  static double get bottomNavigationBarBorderRadius => 30.0;

  // @override
  // FutureOr<void> afterFirstLayout(BuildContext context) {
  //   delay(() {
  //     FlutterNativeSplash.remove();
  //   }, 1500.ms);
  // }

  @override
  void initState() {
    super.initState();
    initNavigatorKeys();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPressed,
      child: Scaffold(
        extendBody: extendBody,
        //bottomNavigationBar 아래 영역 까지 그림
        //drawer: const MenuDrawer(),
        appBar: AppBar(
          // systemOverlayStyle: SystemUiOverlayStyle(
          //   statusBarColor: Colors.green, // <-- SEE HERE
          //   statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
          //   statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
          // ),
          elevation: 1,
          backgroundColor: context.appColors.appBg,
          centerTitle: true, // Center align the title
          title: Text('GoSaRi',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: context.appColors.mosttext,
              )), // Added "Analysis" text
        ),
        body: Padding(
          padding: EdgeInsets.only(
              bottom: extendBody ? 60 - bottomNavigationBarBorderRadius : 0),
          child: SafeArea(
            bottom: !extendBody,
            child: pages,
          ),
        ),
        // bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  IndexedStack get pages => IndexedStack(
      index: _currentIndex,
      children: tabs
          .mapIndexed((tab, index) => Offstage(
        offstage: _currentTab != tab,
        child: TabNavigator(
          navigatorKey: navigatorKeys[index],
          tabItem: tab,
        ),
      ))
          .toList());

  Future<bool> _handleBackPressed() async {
    final isFirstRouteInCurrentTab =
    (await _currentTabNavigationKey.currentState?.maybePop() == false);
    if (isFirstRouteInCurrentTab) {
      if (_currentTab != TabItem.home) {
        _changeTab(tabs.indexOf(TabItem.home));
        return false;
      }
    }
    // maybePop 가능하면 나가지 않는다.
    return isFirstRouteInCurrentTab;
  }

  // Widget _buildBottomNavigationBar(BuildContext context) {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       boxShadow: [
  //         BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
  //       ],
  //     ),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(bottomNavigationBarBorderRadius),
  //         topRight: Radius.circular(bottomNavigationBarBorderRadius),
  //       ),
  //       child: BottomNavigationBar(
  //         items: navigationBarItems(context),
  //         currentIndex: _currentIndex,
  //         selectedItemColor: context.appColors.text,
  //         unselectedItemColor: context.appColors.iconButtonInactivate,
  //         onTap: _handleOnTapNavigationBarItem,
  //         showSelectedLabels: true,
  //         showUnselectedLabels: true,
  //         type: BottomNavigationBarType.fixed,
  //       ),
  //     ),
  //   );
  // }

  List<BottomNavigationBarItem> navigationBarItems(BuildContext context) {
    return tabs
        .mapIndexed(
          (tab, index) => tab.toNavigationBarItem(
        context,
        isActivated: _currentIndex == index,
      ),
    )
        .toList();
  }

  void _changeTab(int index) {
    setState(() {
      _currentTab = tabs[index];
    });
  }

  BottomNavigationBarItem bottomItem(bool activate, IconData iconData,
      IconData inActivateIconData, String label) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(label),
          activate ? iconData : inActivateIconData,
          color: activate
              ? context.appColors.iconButton
              : context.appColors.iconButtonInactivate,
        ),
        label: label);
  }

  void _handleOnTapNavigationBarItem(int index) {
    final oldTab = _currentTab;
    final targetTab = tabs[index];
    if (oldTab == targetTab) {
      final navigationKey = _currentTabNavigationKey;
      popAllHistory(navigationKey);
    }
    _changeTab(index);
  }

  void popAllHistory(GlobalKey<NavigatorState> navigationKey) {
    final bool canPop = navigationKey.currentState?.canPop() == true;
    if (canPop) {
      while (navigationKey.currentState?.canPop() == true) {
        navigationKey.currentState!.pop();
      }
    }
  }

  void initNavigatorKeys() {
    for (final _ in tabs) {
      navigatorKeys.add(GlobalKey<NavigatorState>());
    }
  }
}

