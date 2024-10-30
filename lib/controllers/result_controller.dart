import 'dart:developer';
import 'package:get/get.dart';
import 'package:pi_control_app/models/patient_result.dart';

class ResultController extends GetxController {
  late final ApiResponse apiResponse;

  @override
  void onInit() {
    super.onInit();
    // Retrieve ApiResponse from Get.arguments
    apiResponse = Get.arguments as ApiResponse;
  }
}
