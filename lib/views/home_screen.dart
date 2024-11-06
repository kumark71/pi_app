import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pi_control_app/routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.find();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home_bg.png'),
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              // Show a loading spinner while checking Wi-Fi connection
              if (controller.isCheckingWifi.value) {
                return const Center(
                  child: CircularProgressIndicator(), // Show loading spinner
                );
              }

              // Once the Wi-Fi check is done, show the Wi-Fi connection status as simple text
              return Center(
                child: Text(
                  controller.connectedWifi.value == 'Wi-Fi not connected'
                      ? 'Wi-Fi not connected'
                      : 'Connected: ${controller.connectedWifi.value}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        controller.connectedWifi.value == 'Wi-Fi not connected'
                            ? const Color(0xFFFF0000)
                            : Colors.white, // Green text if connected
                  ),
                  textAlign: TextAlign.center, // Center the text
                ),
              );
            }),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.settings),
              child: const Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Settings",
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(Icons.settings, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                // Check if Wi-Fi is connected before proceeding
                await controller.fetchConnectedWifi().then((_) {
                  if (controller.connectedWifi.value == 'Wi-Fi not connected') {
                    Get.snackbar(
                      'Error',
                      'Wi-Fi not connected! Please connect to a Wi-Fi network.',
                      backgroundColor:
                          Colors.white, // Set background color to white
                      colorText:
                          Colors.black, // Set text color to black for contrast
                      margin: const EdgeInsets.all(
                          10), // Add some margin around the snackbar (optional)
                    );
                  } else {
                    Get.toNamed(AppRoutes.patientDetails);
                  }
                });
              },
              child: const Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Capture",
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(Icons.camera_alt, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
