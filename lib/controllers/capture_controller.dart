import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CaptureController extends GetxController {
  // Variables to hold patient details
  late String name;
  late String age;
  late String mobile;
  late String gender;
  var capturedImagePath = ''.obs; // Holds the path of the captured image

  @override
  void onInit() {
    super.onInit();
    // Retrieve the arguments from the previous screen
    final arguments = Get.arguments ?? {};
    name = arguments['name'] ?? 'N/A';
    age = arguments['age'] ?? 'N/A';
    mobile = arguments['mobile'] ?? 'N/A';
    gender = arguments['gender'] ?? 'N/A';
  }

  // Function to trigger the capture
  Future<void> captureImage() async {
    try {
      // Replace 'your_pi_ip' with your Raspberry Pi's IP address
      var url = Uri.parse('http://your_pi_ip:5000/capture');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        capturedImagePath.value = jsonResponse['image_path'];
        Get.snackbar('Success', 'Image captured successfully');
      } else {
        Get.snackbar('Error', 'Failed to capture image');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to Raspberry Pi');
    }
  }
}
