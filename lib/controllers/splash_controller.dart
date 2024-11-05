import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';

class SplashController extends GetxController {
  var progress = 0.0.obs; // Observable to track progress percentage

  @override
  void onInit() {
    super.onInit();
    log('SplashController onInit');
    startProgressTimer();
    redirectToPage();
  }

  // Start a timer to update progress every second
  void startProgressTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (progress.value < 1.0) {
        progress.value += 0.1; // Increase progress by 10% each second
      } else {
        timer.cancel();
      }
    });
  }

  // Redirect to the next page after 10 seconds
  void redirectToPage() {
    Future.delayed(Duration(seconds: 10), () {
      Get.offNamed('/home');
    });
  }
}
