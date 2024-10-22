import 'package:get/get.dart';
import 'package:pi_control_app/controllers/patient_controller.dart';

class PatientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientDetailsController>(() => PatientDetailsController());
  }
}
