import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pi_control_app/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.find();
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double svgSize = screenWidth * 0.5; // 50% of the screen width

    return Scaffold(
      backgroundColor: Colors.white, // Adjust the background color if needed
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(
              screenWidth * 0.1), // 10% padding based on screen width
          child: SvgPicture.asset(
            'assets/images/smartqr_logo.svg',
            width: svgSize, // Responsive width
            height: svgSize, // Responsive height
          ),
        ),
      ),
    );
  }
}
