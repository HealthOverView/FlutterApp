import 'package:gosari_app/common/common.dart';
import 'package:gosari_app/screen/main/tab/home/f_home.dart';

import 'package:flutter/material.dart';
import 'dialog/d_dialog.dart';

// enum TabItem {
//   home(Icons.home, '홈', HomeFragment()),
//   dialog(Icons.person, '기록', DialogFragment());
//
//   final IconData activeIcon;
//   final IconData inActiveIcon;
//   final String tabName;
//   final Widget firstPage;
//
//   const TabItem(this.activeIcon, this.tabName, this.firstPage, {IconData? inActiveIcon})
//       : inActiveIcon = inActiveIcon ?? activeIcon;
//
//   BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
//     return BottomNavigationBarItem(
//         icon: Icon(
//           key: ValueKey(tabName),
//           isActivated ? activeIcon : inActiveIcon,
//           color:
//               isActivated ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
//         ),
//         label: tabName);
//   }
// }
enum TabItem {
  home(Icons.home, '홈', TabItemType.home),
  dialog(Icons.person, '기록', TabItemType.dialog);

  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;
  //final Widget? tabPage; // 변경된 필드 이름과 타입
  final TabItemType tabPage;

  const TabItem(this.activeIcon, this.tabName, this.tabPage, {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

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
enum TabItemType{
  home,
  dialog
}
