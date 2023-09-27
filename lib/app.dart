import 'package:get/get.dart';
import 'package:gosari_app/common/common.dart';
import 'package:gosari_app/common/theme/custom_theme_app.dart';
import 'package:gosari_app/screen/splash/s_splash.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static bool isForeground = true;

  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> with Nav, WidgetsBindingObserver {
  @override
  GlobalKey<NavigatorState> get navigatorKey => App.navigatorKey;

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //메인커스텀테마 생성
    return CustomThemeApp(
      child: Builder(builder: (context) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: App.navigatorKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'GoSaRi',
          theme: context.themeType.themeData,
          //home: const MainScreen(),
          home: const SplashScreen(),
        );
      }),
    );
  }
}
