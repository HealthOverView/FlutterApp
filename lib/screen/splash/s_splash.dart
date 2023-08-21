import 'package:after_layout/after_layout.dart';
import 'package:gosari_app/common/cli_common.dart';

import 'package:gosari_app/common/common.dart';
import 'package:gosari_app/screen/main/s_main.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin{
  final String appVersion = '0.04';

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    delay((){
      Nav.clearAllAndPush(const MainScreen());
    },1500.ms);
  }
  @override
  void initState() {
      //Nav.clearAllAndPush(const MainScreen());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.appColors.appBg,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.2,),
            Image.asset(
              'assets/image/splash/splash.png',
              width: 192,
              height: 192,
            ),
            Text('GoSaRi',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: context.appColors.mosttext,
              )
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.4,),
            Text('version: $appVersion',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: context.appColors.mosttext,
                )
            ),
          ],
        ),
      ),
    );
  }
}
