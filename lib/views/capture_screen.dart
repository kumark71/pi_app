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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.grey[100],
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const Divider(thickness: 1.0),
                    const SizedBox(height: 10),
                    // Display each patient in a ListView without delete option
                    Obx(() {
                      if (controller.patients.isEmpty) {
                        return const Center(
                          child: Text(
                            "No patients available",
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.patients.length,
                        itemBuilder: (context, index) {
                          final patient = controller.patients[index];
                          return ListTile(
                            title: Text(
                              "Name: ${patient.name}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              "Age: ${patient.age}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Capture Photo Button
            ElevatedButton.icon(
              onPressed: () {
                controller.captureImage();
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture Photo"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
