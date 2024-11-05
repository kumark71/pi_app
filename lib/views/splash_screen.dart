import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pi_control_app/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.find();
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Display the splash image filling the entire screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/smartqr_splash_image_new.png',
              fit: BoxFit.cover, // Adjust as needed (cover, contain, etc.)
            ),
          ),
          // Centered progress bar
          Positioned(
            bottom: 150, // Position the progress bar at the center bottom
            left: screenWidth * 0.1, // Center-align by adjusting left and width
            right: screenWidth * 0.1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Rounded corners
              child: Obx(() => LinearProgressIndicator(
                    value: controller.progress.value, // Update progress value
                    minHeight:
                        13, // Set the height for the rounded progress bar
                    backgroundColor: Colors.black, // Set background color
                    color: Colors.green, // Set progress color
                  )),
            ),
          ),
          // Loading text positioned at the bottom right
          // Loading text positioned at the bottom right with green percentage
          Positioned(
            bottom: 120, // Adjust as needed
            right: screenWidth * 0.1, // Right alignment
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
