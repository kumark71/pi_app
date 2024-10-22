import 'dart:developer';
import 'package:get/get.dart';
import 'package:process_run/shell.dart'; // You can use this package for executing system commands

class SettingsController extends GetxController {
  var networks = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    log('SettingsController onInit');
    getAvailableNetworks();
  }

  // Fetch available Wi-Fi networks
  Future<void> getAvailableNetworks() async {
    try {
      var shell = Shell(verbose: true); // Set verbose when creating Shell
      var result = await shell.run(
        'nmcli dev wifi', // Command to get Wi-Fi networks
      );

      // Process the result and print stdout
      for (var processResult in result) {
        log('STDOUT: ${processResult.stdout}');
        log('STDERR: ${processResult.stderr}');

        // Parse and update network list
        networks.assignAll(parseNetworks(processResult.stdout));
      }
    } catch (e) {
      log('Error running nmcli command: $e');
    }
  }

  // Dummy parser, customize based on command output
  List<String> parseNetworks(String output) {
    // This is an example, customize according to your command's output
    List<String> lines = output.split('\n');
    return lines
        .map((line) => line.split(' ')[0])
        .toList(); // Assuming the first part is the network name
  }

  // Connect to a Wi-Fi network
  Future<void> connectToWifi(String ssid, String password) async {
    try {
      var shell = Shell(verbose: true); // Set verbose here too if needed

      var result = await shell.run(
        'nmcli dev wifi connect $ssid password $password',
      );

      // Process results and output success/failure
      if (result.isNotEmpty) {
        log('STDOUT: ${result.first.stdout}');
        log('STDERR: ${result.first.stderr}');
      }
    } catch (e) {
      log('Error connecting to Wi-Fi: $e');
    }
  }
}
