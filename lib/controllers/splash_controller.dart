import 'dart:developer';

import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    log('SpashController onInit');
    redirectToPage();
  }

  redirectToPage() {
    Future.delayed(Duration(seconds: 3), () {
      Get.offNamed('/home');
    });
  }
}
