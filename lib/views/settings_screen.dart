import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  final SettingsController controller = Get.find();

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wi-Fi Settings"),
        actions: [
          // Add a refresh button in the AppBar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Call the fetchNetworks method to refresh the network list
              controller.fetchNetworks();
            },
          ),
        ],
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
            // Using Obx to reactively show loading indicator or network list
            Expanded(
              child: Obx(() {
                // Show loading indicator while fetching networks
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(), // Loading spinner
                  );
                }

                // Check if networks list is empty
                if (controller.networks.isEmpty) {
                  return const Center(
                    child: Text('No networks available'),
                  );
                }

                // Wrap ListView in RefreshIndicator for pull-to-refresh functionality
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller
                        .fetchNetworks(); // Refresh the network list
                  },
                  child: ListView.builder(
                    itemCount: controller.networks.length,
                    itemBuilder: (context, index) {
                      final network = controller.networks[index];
                      return ListTile(
                        title: Text(network),
                        trailing: IconButton(
                          icon: const Icon(Icons.wifi),
                          onPressed: () =>
                              _showWifiConnectDialog(context, network),
                        ),
                      );
                    },
                  ),
                );
              }),
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
              const SizedBox(height: 20),
              Obx(() {
                // Display a CircularProgressIndicator if Wi-Fi connection is in progress
                if (controller.isConnecting.value) {
                  return const CircularProgressIndicator(); // Show a loading indicator while connecting
                } else {
                  return Container(); // Empty container when not connecting
                }
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Call function to connect to Wi-Fi with password
                controller.connectToWifi(network, passwordController.text);
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
