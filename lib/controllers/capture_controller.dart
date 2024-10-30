import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pi_control_app/models/patient_model.dart';
import 'dart:developer';

import 'package:pi_control_app/models/patient_result.dart';
import 'package:pi_control_app/routes/app_routes.dart';
import 'package:pi_control_app/views/result_screen.dart';

class CaptureController extends GetxController {
  var capturedImagePath = ''.obs;
  var isLoading = false.obs; // Observable boolean for loader state

  List<PatientModel> patients = <PatientModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Retrieve the arguments from the previous screen
    final arguments = Get.arguments ?? {};
    patients = arguments['patients'] ?? <PatientModel>[].obs;
  }

  // Function to trigger the image capture using libcamera-still
  Future<void> captureImage() async {
    isLoading.value = true; // Show loader
    try {
      // Specify the path where the image will be saved
      String imagePath = '/home/dev/captured_image.jpg';

      // Run the libcamera-still command to capture the image
      ProcessResult result = await Process.run(
        'libcamera-still',
        ['-o', imagePath], // Arguments for libcamera-still
      );

      if (result.exitCode == 0) {
        // Image captured successfully
        capturedImagePath.value = imagePath;
        await uploadImageToServer(); // Upload the image to the server
      } else {
        print("Error: ${result.stderr}"); // Error during the capture process
        Get.snackbar('Error', 'Failed to capture image: ${result.stderr}');
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Failed to execute capture: $e');
    } finally {
      isLoading.value = false; // Hide loader
    }
  }

  // Function to send the captured image to a remote server
  // Function to convert the image to Base64
  Future<String> convertImageToBase64(String imagePath) async {
    try {
      // Read the image as bytes
      final bytes = await File(imagePath).readAsBytes();
      // Convert the bytes to a Base64 string
      String base64Image = base64Encode(bytes);

      return base64Image;
    } catch (e) {
      return '';
    }
  }

  Future<void> uploadImageToServer() async {
    if (capturedImagePath.value.isNotEmpty) {
      try {
        // Convert the image to Base64
        String base64Image =
            await convertImageToBase64(capturedImagePath.value);

        if (base64Image.isNotEmpty) {
          var uri = Uri.parse(
              'https://dev.hemoqr-devtest-backend-app.smartqr.co.in/app/ingene-result/');

          // Convert the patients list to JSON
          List<Map<String, dynamic>> patientsData = patients
              .map((patient) =>
                  {'name': patient.name, 'age': patient.age.toString()})
              .toList();

          // Create the JSON payload
          Map<String, dynamic> body = {
            'patients_data': patientsData,
            'image_file': base64Image,
          };

          // Send the JSON request
          var response = await http.post(
            uri,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          );

          if (response.statusCode == 200) {
            // Parse response body
            final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

            // Create ApiResponse instance
            ApiResponse apiResponse = ApiResponse.fromJson(jsonResponse);

            if (apiResponse.status == 'success') {
              // Navigate to ResultScreen and pass ApiResponse as an argument
              Get.offAndToNamed(AppRoutes.result, arguments: apiResponse);

              // Optionally delete the image after navigating
              File imageFile = File(capturedImagePath.value);
              if (await imageFile.exists()) {
                await imageFile.delete();
                capturedImagePath.value = '';
              }
            } else {
              Get.snackbar('Error', 'Failed to upload image');
            }
          } else {
            Get.snackbar('Error', 'Failed to upload image');
          }
        } else {
          Get.snackbar('Error', 'Failed to encode image to Base64');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to upload image: $e');
      }
    } else {
      Get.snackbar('Error', 'No image captured to upload');
    }
  }
}
