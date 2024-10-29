import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pi_control_app/routes/app_routes.dart';

class PatientDetailsController extends GetxController {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  // RxInt for selected slot number (as it's a dropdown)
  var selectedSlotNumber = 0.obs;

  void submitForm() {
    // Validate name
    if (GetUtils.isNullOrBlank(nameController.text) == true) {
      Get.snackbar('Error', 'Please enter the patient\'s name');
      return;
    }

    // Validate age
    if (GetUtils.isNullOrBlank(ageController.text) == true ||
        int.tryParse(ageController.text) == null ||
        int.parse(ageController.text) <= 0) {
      Get.snackbar('Error', 'Please enter a valid age');
      return;
    }

    // Validate slot number
    if (selectedSlotNumber.value == 0) {
      Get.snackbar('Error', 'Please select a valid slot number');
      return;
    }

    // If the form is valid, navigate to the next page
    Get.offAndToNamed(AppRoutes.capture, arguments: {
      'name': nameController.text,
      'age': ageController.text,
      'slotnumber': selectedSlotNumber.value.toString(),
    });
  }
}
