import 'package:gosari_app/screen/main/tab/tab_item.dart';
import 'package:gosari_app/screen/main/tab/tab_navigator.dart';
import 'package:flutter/material.dart';
import '../../common/common.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabItem _currentTab = TabItem.home;

  // 탭 목록
  final tabs = [
    TabItem.home,
    TabItem.dialog,
  ];

  //탭 네비게이터의 GlobalKey 리스트
  final List<GlobalKey<NavigatorState>> navigatorKeys = [];
  // 현재 선택된 탭의 인덱스
  int get _currentIndex => tabs.indexOf(_currentTab);
  // 현재 선택된 탭의 네비게이터 키
  GlobalKey<NavigatorState> get _currentTabNavigationKey =>
      navigatorKeys[_currentIndex];
  // 확장된 바디 여부
  bool get extendBody => true;
  // 바텀 네비게이션 바의 경계 반경
  static double get bottomNavigationBarBorderRadius => 30.0;

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

  // IndexedStack을 사용하여 현재 선택된 탭의 페이지를 표시
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

  // 뒤로 가기 버튼 처리
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
  // 바텀 네비게이션 바 아이템 목록 생성
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
  // 탭 변경
  void _changeTab(int index) {
    setState(() {
      _currentTab = tabs[index];
    });
  }
  // 바텀 네비게이션 바 아이템 생성
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
  // 네비게이터 히스토리 모두 팝
  void popAllHistory(GlobalKey<NavigatorState> navigationKey) {
    final bool canPop = navigationKey.currentState?.canPop() == true;
    if (canPop) {
      while (navigationKey.currentState?.canPop() == true) {
        navigationKey.currentState!.pop();
      }
    }
  }
  // 탭 네비게이터의 GlobalKey 초기화
  void initNavigatorKeys() {
    for (final _ in tabs) {
      navigatorKeys.add(GlobalKey<NavigatorState>());
    }
  }
}

