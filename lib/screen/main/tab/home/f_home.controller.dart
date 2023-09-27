import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gosari_app/screen/camera/c_analyze.dart';

class HomeController extends GetxController {
  late ImagePicker imagePicker;

  @override
  void onInit() {
    super.onInit();
    // ImagePicker 인스턴스를 초기화
    imagePicker = ImagePicker();
  }

  // 카메라를 통해 분석 화면으로 이동하는 메서드
  Future<void> imgFromCameraAndAnalyze() async {
    // 카메라에서 이미지를 선택
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    File? image = File(pickedFile!.path);
    // 이미지를 분석 화면으로 이동
    navigateToCameraAnalyzeScreen(image);
  }
  // 갤러리에서 이미지를 선택하고 분석 화면으로 이동하는 메서드
  Future<void> imgFromGalleryAndAnalyze() async {
    // 갤러리에서 이미지를 선택
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    File? image = File(pickedFile!.path);
    // 이미지를 분석 화면으로 이동
    navigateToCameraAnalyzeScreen(image);
  }

  // 카메라 분석 화면으로 이동하는 메서드
  void navigateToCameraAnalyzeScreen(File? image) {
    Get.to(() => CameraAnalyzeScreen(image: image));
  }
}