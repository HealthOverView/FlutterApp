import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'common/data/preference/app_preferences.dart';
import 'package:gosari_app/database/d_databasehelper.dart';

void main() async {
  //db 정의
  final dbHelper = DatabaseHelper();
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.initDatabase();

  // EasyLocalization을 초기화
  await EasyLocalization.ensureInitialized();
  // AppPreferences를 초기화
  await AppPreferences.init();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ko')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      useOnlyLangCode: true,
      child: const App()));
}
