import 'package:get/get.dart';
import 'package:pi_control_app/controllers/capture_controller.dart';

class CaptureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CaptureController>(() => CaptureController());
  }
}
