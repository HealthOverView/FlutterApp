import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosari_app/common/common.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert';
import 'dart:io';

import '../../common/widget/round_button_theme.dart';
import '../../common/widget/w_round_button.dart';
import '../main/tab/dialog/d_controller.dart';
import '../main/tab/dialog/d_dialog.dart';

class CameraAnalyzeScreen extends StatefulWidget {
  final File? image;

  CameraAnalyzeScreen({Key? key, this.image}) : super(key: key);

  @override
  _CameraAnalyzeScreenState createState() => _CameraAnalyzeScreenState();
}

class _CameraAnalyzeScreenState extends State<CameraAnalyzeScreen> {
  final HomeController _homeController = Get.find();
  bool _uploading = false;
  String _responseMessage = '';
  String _responseBody = '';
  @override
  void initState() {
    super.initState();
    _uploadImage(); // Automatically upload and display image
  }

  Future<void> _uploadImage() async {
    setState(() {
      _uploading = true;
    });

    var uri = Uri.parse('http://192.168.1.192:3060/diagnosis');

    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('img', widget.image!.path));

    try {
      var response = await request.send();
      print('HTTP Response Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('Response Body: $responseBody');
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        String description = jsonResponse['description'];
        String message = jsonResponse['message'];
        // Handle the response message or any other necessary logic

        setState(() {
          //_responseBody = responseBody;
          _responseBody = 'Description: $description';
          //_responseMessage = message;
        });
      } else {
        print('Error: Request failed with status ${response.statusCode}');
        // Handle the error response
        setState(() {
          _responseMessage = 'Error: Request failed';
          _responseBody = 'Error: Request failed';
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        _responseMessage = 'Error: $error';
        _responseBody = 'Error: $error';
      });
      // Handle the error
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

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

          ],
        ),
      ),
    );
  }
}
