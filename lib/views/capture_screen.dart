import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pi_control_app/controllers/capture_controller.dart';

class CaptureScreen extends StatelessWidget {
  final CaptureController controller = Get.find();

  CaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Capture Screen"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Card to display Patient Details with Title inside
                  Card(
                    color: Colors.grey[100], // Subtle light background color
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title inside the card
                          const Center(
                            child: Text(
                              "Patient Details",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const Divider(
                              thickness: 1.0), // A divider to separate the title
                          const SizedBox(height: 10),

                          // Patient Information
                          Text(
                            "Name: ${controller.name}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            "Age: ${controller.age}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            "Mobile: ${controller.mobile}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            "Gender: ${controller.gender}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Show the loader if isLoading is true
                  if (controller.isLoading.value)
                    const CircularProgressIndicator(),

                  const SizedBox(height: 30),

                  // Capture Photo Button
                  ElevatedButton.icon(
                    onPressed: controller.isLoading.value
                        ? null // Disable the button while loading
                        : () {
                            controller.captureImage();
                          },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Capture Photo"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
