import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';
import '../controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  final SettingsController controller = Get.find();

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wi-Fi Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Available Networks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: controller.networks.length,
                itemBuilder: (context, index) {
                  final network = controller.networks[index];
                  return ListTile(
                    title: Text(network),
                    trailing: IconButton(
                      icon: const Icon(Icons.wifi),
                      onPressed: () => _showWifiConnectDialog(context, network),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWifiConnectDialog(BuildContext context, String network) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Connect to $network"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter Password:"),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Call function to connect to Wi-Fi with password
                controller.connectToWifi(network, passwordController.text);
                Navigator.pop(context);
              },
              child: const Text("Connect"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
