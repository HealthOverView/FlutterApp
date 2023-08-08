// import 'dart:io';
// import 'package:gosari_app/common/common.dart';
// import 'package:gosari_app/common/widget/round_button_theme.dart';
// import 'package:gosari_app/common/widget/w_round_button.dart';
// import 'package:flutter/material.dart';
// import 'package:gosari_app/screen/main/tab/dialog/d_dialog.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../camera/c_analyze.dart';
//
// class HomeFragment extends StatefulWidget {
//   const HomeFragment({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<HomeFragment> createState() => _HomeFragmentState();
// }
//
// class _HomeFragmentState extends State<HomeFragment> {
//   late ImagePicker imagePicker;
//   File? _image;
//   String result = '';
//   //TODO declare ImageLabeler
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     imagePicker = ImagePicker();
//     //TODO initialize labeler
//
//   }
//
//
//   @override
//   void dispose() {
//
//   }
//   _imgFromCamera() async {
//     XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
//     _image = File(pickedFile!.path);
//     _navigateToCameraAnalyzeScreen(_image);
//   }
//
//   _imgFromGallery() async {
//     XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
//     _image = File(pickedFile!.path);
//     _navigateToCameraAnalyzeScreen(_image);
//   }
//
//   _navigateToCameraAnalyzeScreen(File? image) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CameraAnalyzeScreen(image: image),
//       ),
//     );
//   }
//
//   //TODO image labeling code here
//   doImageLabeling() async {
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: context.appColors.appBg,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           InkWell(
//             onTap: () {
//               _imgFromCamera();
//             },
//             child: Container(
//               width: MediaQuery.of(context).size.width*0.5, // 버튼 크기 설정
//               height: MediaQuery.of(context).size.height*0.5,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white, // 버튼 배경색
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2), // 그림자 색상
//                     offset: const Offset(0, 2), // 그림자 위치 조정
//                     blurRadius: 6, // 그림자의 블러 반경
//                     spreadRadius: 0, // 그림자 확장 반경
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(10), // 이미지 여백
//                 child: Image.asset(
//                   'assets/image/splash/splash.png',
//                   width: 50, // 이미지 크기 조절
//                   height: 50,
//                 ),
//               ),
//             ),
//           ),
//           RoundButton(
//             text: '촬영 분석하기',
//             onTap: () {
//               _imgFromCamera();
//             },
//             theme: RoundButtonTheme.grey,
//             fontSize: 20,
//           ),
//           const Height(20),
//           RoundButton(
//             text: '이미지 선택하기',
//             onTap: () {
//               _imgFromGallery();
//             },
//             theme: RoundButtonTheme.grey,
//             fontSize: 20,
//           ),
//           const Height(20),
//           RoundButton(
//             text: '결과 확인하기',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => DialogFragment()),
//               );
//             },
//             theme: RoundButtonTheme.grey,
//             fontSize: 20,
//           ),
//           const EmptyExpanded()
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosari_app/common/common.dart';
import 'package:gosari_app/common/widget/round_button_theme.dart';
import 'package:gosari_app/common/widget/w_round_button.dart';
import '../dialog/d_controller.dart';
import '../dialog/d_dialog.dart';

class HomeFragment extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      backgroundColor: context.appColors.appBg,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                controller.imgFromCamera();
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
                controller.imgFromCamera();
              },
              theme: RoundButtonTheme.grey,
              fontSize: 20,
            ),
            const SizedBox(height: 20),
            RoundButton(
              text: '이미지 선택하기',
              onTap: () {
                controller.imgFromGallery();
              },
              theme: RoundButtonTheme.grey,
              fontSize: 20,
            ),
            const SizedBox(height: 20),
            RoundButton(
              text: '결과 확인하기',
              onTap: () {
                Get.to(() => DialogFragment());
              },
              theme: RoundButtonTheme.grey,
              fontSize: 20,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
