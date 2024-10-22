import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pi_control_app/routes/app_routes.dart';

class PatientDetailsController extends GetxController {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final mobileController = TextEditingController(); // Add this
  var selectedGender = ''.obs;

  void submitForm() {
    // Add validation for mobile number as well, if required
    if (GetUtils.isNullOrBlank(nameController.text) == true) {
      Get.snackbar('Error', 'Please enter the patient\'s name');
      return;
    }
    if (GetUtils.isNullOrBlank(ageController.text) == true ||
        int.tryParse(ageController.text) == null ||
        int.parse(ageController.text) <= 0) {
      Get.snackbar('Error', 'Please enter a valid age');
      return;
    }
    if (GetUtils.isNullOrBlank(mobileController.text) == true ||
        !GetUtils.isPhoneNumber(mobileController.text)) {
      Get.snackbar('Error', 'Please enter a valid mobile number');
      return;
    }
    if (selectedGender.value.isEmpty) {
      Get.snackbar('Error', 'Please select a gender');
      return;
    }

    // If the form is valid, navigate to the next page
    Get.offAndToNamed(AppRoutes.capture, arguments: {
      'name': nameController.text,
      'age': ageController.text,
      'mobile': mobileController.text,
      'gender': selectedGender.value,
    });
  }
}
