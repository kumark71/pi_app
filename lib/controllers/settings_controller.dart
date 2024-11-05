import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_run/shell.dart'; // You can use this package for executing system commands

class SettingsController extends GetxController {
  var networks = <String>[].obs;
  var isLoading = false.obs; // To track loading state
  var isConnecting = false.obs; // To track Wi-Fi connection state

  @override
  void onInit() {
    super.onInit();
    log('SettingsController onInit');
    fetchNetworks(); // Fetch networks when the controller initializes
  }

  // Fetch available Wi-Fi networks
  Future<void> fetchNetworks() async {
    isLoading(true); // Set loading to true
    try {
      var shell = Shell(verbose: true); // Set verbose when creating Shell
      var result = await shell.run(
        'nmcli dev wifi', // Command to get Wi-Fi networks
      );

      // Process the result and update network list
      for (var processResult in result) {
        networks.assignAll(parseNetworks(processResult.stdout));
      }
    } catch (e) {
      log('Error running nmcli command: $e');
    } finally {
      isLoading(false); // Set loading to false after fetching
    }
  }

  // Improved parser to handle SSID and other columns
  List<String> parseNetworks(String output) {
    List<String> ssids = [];

    // Split the output by newlines to get each network entry
    List<String> lines = output.split('\n');

    for (String line in lines) {
      // Skip the header line and empty lines
      if (line.contains('BSSID') || line.trim().isEmpty) {
        continue;
      }

      // Split the line by spaces, considering multiple spaces as a delimiter
      List<String> columns = line.split(RegExp(r'\s{2,}'));

      // Check if the SSID exists (it should be in the third column)
      if (columns.length > 2 && columns[2].isNotEmpty && columns[2] != '--') {
        ssids.add(columns[2]); // SSID is the third column in nmcli output
      }
    }

    return ssids;
  }

  // Connect to a Wi-Fi network

  Future<void> connectToWifi(String ssid, String password) async {
    isConnecting(true); // Start loading when attempting to connect
    try {
      var shell = Shell(verbose: true);

      // Wrap SSID and password in double quotes to handle spaces and special characters
      var result = await shell.run(
        'nmcli dev wifi connect "$ssid" password "$password"',
      );

      // Check the result for success
      if (result.isNotEmpty && result.first.exitCode == 0) {
        log('STDOUT: ${result.first.stdout}');
        log('Connected successfully to $ssid');
        Get.snackbar(
          'Connection Successful',
          'You are now connected to $ssid',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        log('STDERR: ${result.first.stderr}');
        Get.snackbar(
          'Connection Failed',
          'Unable to connect to $ssid. Please check the password and try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log('Error connecting to Wi-Fi: $e');
      Get.snackbar(
        'Connection Error',
        'An error occurred while connecting to $ssid. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isConnecting(false); // Stop loading after connection attempt
    }
  }
}
