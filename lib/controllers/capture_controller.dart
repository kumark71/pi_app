import 'dart:convert';
import 'dart:io';

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

  // Function to trigger the image capture using libcamera-still
  Future<void> captureImage() async {
    try {
      // Specify the path where the image will be saved
      String imagePath = '/home/pi/captured_image.jpg';

      // Run the libcamera-still command to capture the image
      ProcessResult result = await Process.run(
        'libcamera-still',
        ['-o', imagePath], // Arguments for libcamera-still
      );

      if (result.exitCode == 0) {
        // Image captured successfully
        capturedImagePath.value = imagePath;
        Get.snackbar('Success', 'Image captured successfully');
        // Optionally, you can call uploadImageToServer() here to send it to the server
      } else {
        // Error during the capture process
        Get.snackbar('Error', 'Failed to capture image: ${result.stderr}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to execute capture: $e');
    }
  }

  // Function to send the captured image to a remote server
  Future<void> uploadImageToServer() async {
    if (capturedImagePath.value.isNotEmpty) {
      try {
        var uri = Uri.parse(
            'http://your_server_ip/upload'); // Replace with your server's IP
        var request = http.MultipartRequest('POST', uri);

        // Attach the captured image
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          capturedImagePath.value,
        ));

        // Send the request to the server
        var response = await request.send();

        if (response.statusCode == 200) {
          Get.snackbar('Success', 'Image uploaded successfully');

          // Delete the image from the Raspberry Pi after successful upload
          File imageFile = File(capturedImagePath.value);
          if (await imageFile.exists()) {
            await imageFile.delete(); // Deletes the file
            capturedImagePath.value = ''; // Clear the captured image path
            Get.snackbar('Success', 'Image deleted from device after upload');
          }
        } else {
          Get.snackbar('Error', 'Failed to upload image');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to upload image: $e');
      }
    } else {
      Get.snackbar('Error', 'No image captured to upload');
    }
  }
}
