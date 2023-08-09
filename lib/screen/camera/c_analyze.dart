// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:image_picker/image_picker.dart';
//
// class CameraAnalyzeScreen extends StatefulWidget {
//   final File? image;
//
//   CameraAnalyzeScreen({Key? key, this.image}) : super(key: key);
//   @override
//   _CameraAnalyzeScreenState createState() => _CameraAnalyzeScreenState();
// }
//
// class _CameraAnalyzeScreenState extends State<CameraAnalyzeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle, // 원형 배경을 위한 설정
//             color: Colors.transparent, // 배경 색상
//           ),
//           child: Column(
//             children: [
//               SizedBox(
//                 width: 100,
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 100),
//                 child: Center(
//                   child: Container(
//                     margin: EdgeInsets.only(top: 8),
//                     child: widget.image != null
//                         ? ClipOval( // 이미지를 원 형태로 자르기 위한 ClipOval 위젯
//                       child: Image.file(
//                         widget.image!,
//                         width: MediaQuery.of(context).size.width * 0.7,
//                         height: MediaQuery.of(context).size.height * 0.33,
//                         fit: BoxFit.fill,
//                       ),
//                     )
//                         : Icon(
//                           Icons.camera_alt,
//                           color: Colors.grey[200],
//                         ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 margin: EdgeInsets.only(top: 20),
//                 child: Text(
//                   //'$result',
//                   'result',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontFamily: 'finger_paint', fontSize: 20),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:gosari_app/common/common.dart';

class CameraAnalyzeScreen extends StatelessWidget {
  final File? image;

  CameraAnalyzeScreen({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 아이콘 사용
          onPressed: () {
            Navigator.of(context).pop(); // 현재 화면에서 뒤로가기
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            SizedBox(width: 100),
            Container(
              margin: EdgeInsets.only(top: 100),
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  child: image != null
                      ? ClipOval(
                    child: Image.file(
                      image!,
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.33,
                      fit: BoxFit.fill,
                    ),
                  )
                      : Icon(
                    Icons.camera_alt,
                    color: Colors.grey[200],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                'result',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'finger_paint', fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
