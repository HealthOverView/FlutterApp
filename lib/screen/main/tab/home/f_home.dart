import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosari_app/common/common.dart';
import 'package:gosari_app/common/widget/round_button_theme.dart';
import 'package:gosari_app/common/widget/w_round_button.dart';
import '../../../../common/theme/custom_theme.dart';
import '../../../../common/theme/theme_util.dart';
import '../../../dialog/d_calendar.dart';
import '../dialog/d_controller.dart';
import '../dialog/d_dialog.dart';

class HomeFragment extends GetView<HomeController> {
  final String appVersion = '0.04';

  @override
  Widget build(BuildContext context) {


    Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: context.appColors.appBg,
        centerTitle: true,
        title: Text(
          'GoSaRi',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: context.appColors.mosttext,
          ),
        ),
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.black,), // 아이콘 변경 가능
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
      ),
      body: Container(
        color: context.appColors.appBg,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  controller.imgFromCameraAndAnalyze();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/image/splash/splash.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ),
              RoundButton(
                text: '촬영 분석하기',
                onTap: () {
                  controller.imgFromCameraAndAnalyze();
                },
                theme: RoundButtonTheme.grey,
                fontSize: 20,
              ),
              const SizedBox(height: 20),
              RoundButton(
                text: '이미지 선택하기',
                onTap: () {
                  controller.imgFromGalleryAndAnalyze();
                },
                theme: RoundButtonTheme.grey,
                fontSize: 20,
              ),
              const SizedBox(height: 20),
              RoundButton(
                text: '결과 확인하기',
                onTap: () {
                  //Get.to(() => DialogFragment());
                  Navigator.push(
                    context,
                    //MaterialPageRoute(builder: (context) => EventCalendarScreen()),
                    MaterialPageRoute(builder: (context) => DialogFragment()),
                  );
                },
                theme: RoundButtonTheme.grey,
                fontSize: 20,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
              Text('version: $appVersion',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: context.appColors.mosttext,
                  )
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
