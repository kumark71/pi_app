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

    return Scaffold(
      backgroundColor: Colors.white, // Adjust the background color if needed
      body: Center(
        child: Image.asset(
          'assets/images/smartqr_splash_image.png',
          width: screenWidth,
          height: screenHeight,
        ),
      ),
    );
  }
}
