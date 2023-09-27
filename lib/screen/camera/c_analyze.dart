import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosari_app/common/common.dart';
import 'package:gosari_app/screen/main/s_main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:gosari_app/common/widget/round_button_theme.dart';
import 'package:gosari_app/common/widget/w_round_button.dart';
import 'package:gosari_app/database/d_databasehelper.dart';
import 'package:gosari_app/screen/main/tab/dialog/d_dialog.dart';
import 'package:gosari_app/screen/main/tab/home/f_home.controller.dart';


class CameraAnalyzeScreen extends StatefulWidget {
  final File? image;

  CameraAnalyzeScreen({Key? key, this.image}) : super(key: key);

  @override
  _CameraAnalyzeScreenState createState() => _CameraAnalyzeScreenState();
}

class _CameraAnalyzeScreenState extends State<CameraAnalyzeScreen> {

  final dbHelper = DatabaseHelper();
  final HomeController _homeController = Get.find();
  bool _uploading = false;
  String _responseMessage = '';
  String _responseBody = '';
  @override
  void initState() {
    super.initState();
    dbHelper.initDatabase();
    _uploadImage(); // Automatically upload and display image
  }
  //메인페이지로 이동하는 메서드
  void _navigateToMainPage() {
    Navigator.of(context).popUntil((route) => route.isFirst); // Pop all routes except the first (home) route
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()), // Navigate to HomeFragment
    );
  }

  //서버에서 가져온 이미지 처리
  Future<void> _uploadImage() async {

    setState(() {
      _uploading = true;
    });

    var uri = Uri.parse('http://192.168.1.192:3061/diagnosis');

    var request = http.MultipartRequest('POST', uri);
    print(widget.image!.path);
    request.files.add(await http.MultipartFile.fromPath('img', widget.image!.path));

    try { //responsBody를 받을때 영어를 한글로 반환
      var response = await request.send().timeout(Duration(seconds: 20));
      print('HTTP Response Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        // Encode the image as base64

        String responseBody = await response.stream.bytesToString();
        print('Response Body: $responseBody');
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        String description = jsonResponse['description'];
        String message = jsonResponse['message'];
        String imageFileName = jsonResponse['file'];

        // Handle the response message or any other necessary logic
        String displayedMessage = '';

        // Determine the appropriate displayed message based on the description
        if (description == 'infertility_period') {
          displayedMessage = '비가임기';
        } else if (description == 'transitional_period') {
          displayedMessage = '과도기';
        } else if (description == 'ovulatory_phase') {
          displayedMessage = '가임기';
        } else if (description == 'foreign_substance') {
          displayedMessage = '이물질';
        } else {
          // If none of the expected descriptions match, display reshooting notification
          displayedMessage = '재촬영';
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('촬영 오류'),
                content: Text('다시 분석을 시도해주세요'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      _navigateToMainPage();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          return;
        }
        setState(() {
          _responseBody = '결과: $displayedMessage';
          dbHelper.insertEvent({
            'dateTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            'result': displayedMessage, // Use your actual message or description her
            'imageFileName' : imageFileName,

          });
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Request Failed'),
              content: Text('The request to the server failed with status code ${response.statusCode}.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    _navigateToMainPage();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        setState(() {
          _responseMessage = 'Error: 서버 요청 에러';
          _responseBody = 'Error: 서버 요청 에러';
        });
      }
    } on TimeoutException {
      // Handle timeout here
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('분석 시간 초과'),
            content: Text('인터넷 연결 상태를 확인해주세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _navigateToMainPage();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      setState(() {
        _responseMessage = 'Error: Request timed out';
        _responseBody = 'Error: Request timed out';
      });
    } catch (error) {
      // Handle the error using an AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _navigateToMainPage();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      print('Error: $error');
      setState(() {
        _responseMessage = 'Error: $error';
        _responseBody = 'Error: $error';
      });
      return;
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasResult = _responseBody.isNotEmpty;
    final bool noErrorDialog = _responseMessage.isEmpty;
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 10),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(top: 8),
                  child: widget.image != null
                      ? ClipOval(
                    child: Image.file(
                      widget.image!,
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
                _responseBody,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'finger_paint', fontSize: 20),
              ),
            ),
            const SizedBox(height: 100),
            // ElevatedButton(
            //   onPressed: _uploading ? null : _uploadImage,
            //   child: _uploading ? CircularProgressIndicator() : Text('Upload and Analyze'),
            // ),
            if (hasResult && noErrorDialog)
              RoundButton(
                text: '결과 확인하기',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DialogFragment()),
                  );
                },
                theme: RoundButtonTheme.grey,
                fontSize: 20,
              ),
            // 다시 촬영하기 버튼 출력
            // if(_responseMessage.isNotEmpty)
            //   RoundButton(
            //     text: '다시 촬영하기',
            //     onTap: () async {
            //       await _homeController.imgFromCameraAndAnalyze(); // Controller의 메서드 호출
            //     },
            //     theme: RoundButtonTheme.grey,
            //     fontSize: 20,
            //   )
          ],
        ),
      ),
    );
  }
}
