import 'package:gosari_app/common/common.dart';
import 'package:flutter/material.dart';

enum TabItem {

  // 각 탭 아이템을 정의하는 열거형
  home(Icons.home, '홈', TabItemType.home),
  dialog(Icons.person, '기록', TabItemType.dialog);

  // 활성화된 아이콘, 비활성화된 아이콘, 탭 이름, 연결된 페이지 유형 정의
  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;
  final TabItemType tabPage;

  // TabItem 생성자
  const TabItem(this.activeIcon, this.tabName, this.tabPage, {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;
  // 바텀 네비게이션 바에서 변환하는 메서드
  BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(tabName),
          isActivated ? activeIcon : inActiveIcon,
          color:
          isActivated ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
        ),
        label: tabName);
  }
}
// 페이지 유형 정의
enum TabItemType{
  //홈화면
  home,
  //내 기록 화면
  dialog
}
