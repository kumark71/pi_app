import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CaptureController extends GetxController {
  //  Get.offAndToNamed(AppRoutes.capture, arguments: {
  //     'name': nameController.text,
  //     'age': ageController.text,
  //     'slotnumber': selectedSlotNumber.value.toString(),
  //   });
  // Variables to hold patient details
  late String name;
  late String age;
  late String slotNumber;

  var capturedImagePath = ''.obs; // Holds the path of the captured image
  var isLoading = false.obs; // Observable boolean for loader state

  @override
  void onInit() {
    super.onInit();
    // Retrieve the arguments from the previous screen
    final arguments = Get.arguments ?? {};
    name = arguments['name'] ?? 'N/A';
    age = arguments['age'] ?? 'N/A';
    slotNumber = arguments['slotnumber'] ?? 'N/A';
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
        Get.snackbar('Success', 'Image captured successfully');
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

  // Function to convert the image to Base64
  Future<String> convertImageToBase64(String imagePath) async {
    try {
      // Read the image as bytes
      final bytes = await File(imagePath).readAsBytes();
      // Convert the bytes to a Base64 string
      String base64Image = base64Encode(bytes);
      print(
          "Base64 Encoded Image: $base64Image"); // Print the Base64-encoded string
      return base64Image;
    } catch (e) {
      print("Error converting image to Base64: $e");
      return '';
    }
  }

  // Function to send the captured image to a remote server as Base64
  Future<void> uploadImageToServer() async {
    if (capturedImagePath.value.isNotEmpty) {
      try {
        // Convert the image to Base64
        String base64Image =
            await convertImageToBase64(capturedImagePath.value);

        if (base64Image.isNotEmpty) {
          var uri = Uri.parse(
              'http://your_server_ip/upload'); // Replace with your server's IP
          var request = http.MultipartRequest('POST', uri);

          // Attach the Base64-encoded image as part of the request
          request.fields['image'] = base64Image; // Send it in the request body

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
