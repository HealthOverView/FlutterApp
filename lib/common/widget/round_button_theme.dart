import 'package:gosari_app/common/common.dart';
import 'package:flutter/material.dart';

enum RoundButtonTheme {
  grey(AppColors.grey, Colors.white, AppColors.grey, backgroundColorProvider: greyColorProvider),
  whiteWithgreyBorder(Colors.white, AppColors.grey, AppColors.grey,
      backgroundColorProvider: greyColorProvider),
  blink(AppColors.grey, Colors.white, Colors.black, backgroundColorProvider: greyColorProvider);

  const RoundButtonTheme(
    this.bgColor,
    this.textColor,
    this.borderColor, {
    this.backgroundColorProvider,
  }) : shadowColor = Colors.transparent;

  ///RoundButtonTheme 안에서 Custome Theme 분기가 필요하다면 이렇게 함수로 사용
  final Color Function(BuildContext context)? backgroundColorProvider;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  final Color shadowColor;
}

Color greyColorProvider(BuildContext context) => context.appColors.greyButtonBackground;

Color Function(BuildContext context) defaultColorProvider(Color color) => greyColorProvider;
