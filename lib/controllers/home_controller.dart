import 'dart:developer';
import 'package:get/get.dart';
import 'package:process_run/shell.dart';

class HomeController extends GetxController {
  var connectedWifi = ''.obs; // Observable to store the connected Wi-Fi network
  var isCheckingWifi = true.obs; // Observable to track if we are checking Wi-Fi

  @override
  void onInit() {
    super.onInit();
    log('Home Screen onInit');
  }

  @override
  void onReady() {
    super.onReady();
    fetchConnectedWifi(); // Check Wi-Fi when the page becomes visible
  }

  // Fetch the connected Wi-Fi network
  Future<void> fetchConnectedWifi() async {
    isCheckingWifi(true); // Set loading state to true while checking
    try {
      var shell = Shell();

      // Run the command to fetch the connected Wi-Fi
      var result = await shell.run(
        'nmcli -t -f active,ssid dev wifi', // Command to get active Wi-Fi connection
      );

      // Check if there is any output indicating a connected Wi-Fi
      bool wifiConnected = false;
      for (var processResult in result) {
        var lines = processResult.stdout.split('\n');
        for (var line in lines) {
          // If 'yes' is in the first column, it means a Wi-Fi connection is active
          if (line.startsWith('yes')) {
            var ssid = line.split(':')[1]; // Get the SSID from the output
            connectedWifi.value = ssid;
            wifiConnected = true;
            break;
          }
        }
      }

      // If no Wi-Fi is connected, set the value to "Wi-Fi not connected"
      if (!wifiConnected) {
        connectedWifi.value = 'Wi-Fi not connected';
      }
    } catch (e) {
      log('Error fetching Wi-Fi connection: $e');
      connectedWifi.value = 'Error fetching Wi-Fi connection';
    } finally {
      isCheckingWifi(false); // Set loading state to false when done
    }
  }
}
