import 'package:get/get.dart';
import 'package:pi_control_app/bindings/capture_binding.dart';
import 'package:pi_control_app/bindings/splash_binding.dart';
import 'package:pi_control_app/views/splash_screen.dart';

//** Views */
import '../views/home_screen.dart';
import '../views/settings_screen.dart';
import '../views/capture_screen.dart';
import '../views/patient_details_screen.dart';
import '../views/result_screen.dart';

//** Bindings */
import '../bindings/home_binding.dart';
import '../bindings/patient_binding.dart';
import '../bindings/settings_binding.dart';
import '../bindings/result_binding.dart';

class AppRoutes {
  static const home = '/home';
  static const settings = '/settings';
  static const patientDetails = '/patientDetails';
  static const capture = '/capture';
  static const result = '/result';
  static const splash = '/';

  static final routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: settings,
      page: () => SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: patientDetails,
      page: () => PatientDetailsScreen(),
      binding: PatientBinding(),
    ),
    GetPage(
      name: capture,
      page: () => CaptureScreen(),
      binding: CaptureBinding(),
    ),
    GetPage(
      name: result,
      page: () => ResultScreen(),
      binding: ResultBinding(),
    ),
  ];
}
