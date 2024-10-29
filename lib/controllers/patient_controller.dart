import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pi_control_app/models/patient_model.dart';
import 'package:pi_control_app/routes/app_routes.dart';

class PatientDetailsController extends GetxController {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  List<PatientModel> patients = <PatientModel>[].obs;

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
    if (patients.length < 8) {
      patients.add(PatientModel(
        name: nameController.text,
        age: ageController.text,
      ));
    }

    log("patients added: ${patients.last.name}");
    log("patients length: ${patients.length}");
  }

  void navigateToCapture() {
    if (patients.isEmpty) {
      Get.snackbar('Error', 'Please add at least one patient');
      return;
    }
    Get.offAndToNamed(AppRoutes.capture, arguments: {
      'patients': patients,
    });
  }
}
