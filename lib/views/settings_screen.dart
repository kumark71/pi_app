import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart'; // Import the virtual keyboard package
import '../controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  final SettingsController controller = Get.find();

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isShiftEnabled = false; // Variable to track if Shift is pressed
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wi-Fi Settings"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
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
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.networks.isEmpty) {
                  return const Center(
                    child: Text('No networks available'),
                  );
                }

                return RefreshIndicator(
  onRefresh: () async {
    await controller.fetchNetworks();
  },
  child: ListView.builder(
    itemCount: controller.networks.length,
    itemBuilder: (context, index) {
      final network = controller.networks[index];
      return ListTile(
        title: Text(network),
        trailing: const Icon(Icons.wifi), // Display the icon but remove the button functionality
        onTap: () {
          // Make the whole ListTile clickable
          _showWifiConnectDialog(context, network);
        },
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
    bool isKeyboardVisible = false;
    bool isShiftEnabled = false; // Shift state tracking

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Connect to $network"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Enter Password:"),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                    onTap: () {
                      setState(() {
                        isKeyboardVisible = true;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    if (controller.isConnecting.value) {
                      return const CircularProgressIndicator();
                    } else {
                      return Container();
                    }
                  }),
                  const SizedBox(height: 10),

                  // Display the virtual keyboard when needed
                  if (isKeyboardVisible)
                    Container(
                      color: Colors.grey[200],
                      child: VirtualKeyboard(
                        height: 300,
                        textColor: Colors.black,
                        fontSize: 20,
                        defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
                        type: VirtualKeyboardType.Alphanumeric,
                        postKeyPress: (key) {
                          // Handle key presses and update the password controller
                          if (key.keyType == VirtualKeyboardKeyType.String) {
                            // If Shift is enabled, use uppercase, otherwise use lowercase
                            passwordController.text += isShiftEnabled
                                ? key.capsText ?? ''
                                : key.text ?? '';
                          } else if (key.keyType ==
                              VirtualKeyboardKeyType.Action) {
                            switch (key.action) {
                              case VirtualKeyboardKeyAction.Backspace:
                                if (passwordController.text.isNotEmpty) {
                                  passwordController.text =
                                      passwordController.text.substring(0,
                                          passwordController.text.length - 1);
                                }
                                break;
                              case VirtualKeyboardKeyAction.Return:
                                setState(() {
                                  isKeyboardVisible = false;
                                });
                                break;
                              case VirtualKeyboardKeyAction.Space:
                                passwordController.text += ' ';
                                break;
                              case VirtualKeyboardKeyAction.Shift:
                                // Toggle Shift state when Shift key is pressed
                                setState(() {
                                  isShiftEnabled = !isShiftEnabled;
                                });
                                break;
                              default:
                            }
                          }
                        },
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
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
      },
    );
  }
}
