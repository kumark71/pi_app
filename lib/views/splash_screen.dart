import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pi_control_app/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.find();
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Fullscreen splash image
          Positioned.fill(
            child: Image.asset(
              'assets/images/smartqr_splash_image_new.png',
              fit: BoxFit.cover, // Make image cover the entire screen
            ),
          ),
          // Centered progress bar
          Positioned(
            bottom: 130, // Position the progress bar near the bottom
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Rounded corners
              child: Obx(() => LinearProgressIndicator(
                    value: controller.progress.value, // Update progress value
                    minHeight:
                        13, // Set the height for the rounded progress bar
                    backgroundColor: const Color.fromARGB(
                        255, 24, 24, 24), // Set background color
                    color: Colors.green, // Set progress color
                  )),
            ),
          ),
          // Loading text positioned at the bottom right with green percentage
          Positioned(
            bottom: 90, // Adjust as needed
            right: MediaQuery.of(context).size.width * 0.1, // Right alignment
            child: Obx(() => Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Loading ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '${(controller.progress.value * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.green, // Green color for percentage
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
