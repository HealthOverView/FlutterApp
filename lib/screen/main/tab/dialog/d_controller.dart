import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../camera/c_analyze.dart';

class HomeController extends GetxController {
  late ImagePicker imagePicker;
  File? _image;

  @override
  void onInit() {
    super.onInit();
    imagePicker = ImagePicker();
  }

  // void imgFromCamera() async {
  //   XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
  //   _image = File(pickedFile!.path);
  //   navigateToCameraAnalyzeScreen(_image);
  // }
  //
  // void imgFromGallery() async {
  //   XFile? pickedFile =
  //   await imagePicker.pickImage(source: ImageSource.gallery);
  //   _image = File(pickedFile!.path);
  //   navigateToCameraAnalyzeScreen(_image);
  // }
  Future<void> imgFromCameraAndAnalyze() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    File? image = File(pickedFile!.path);
    navigateToCameraAnalyzeScreen(image);
  }

  Future<void> imgFromGalleryAndAnalyze() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    File? image = File(pickedFile!.path);
    navigateToCameraAnalyzeScreen(image);
  }


  void navigateToCameraAnalyzeScreen(File? image) {
    Get.to(() => CameraAnalyzeScreen(image: image));
  }
}