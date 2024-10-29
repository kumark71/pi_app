import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pi_control_app/controllers/patient_controller.dart';
import 'package:pi_control_app/utils/CustomVirtualKeyboard.dart';

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({Key? key}) : super(key: key);

  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final PatientDetailsController controller = Get.find();
  bool isKeyboardVisible = false; // Controls visibility of the virtual keyboard
  TextEditingController? activeController; // The currently active text field
  String currentInput = ""; // The current text input from the virtual keyboard

  // Focus nodes for each field
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode ageFocusNode = FocusNode();

  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = []; // Store all focus nodes

  @override
  void initState() {
    super.initState();
    controllers.add(controller.nameController);
    controllers.add(controller.ageController);

    focusNodes.addAll([nameFocusNode, ageFocusNode]);
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    ageFocusNode.dispose();

    super.dispose();
  }

  // Handle key presses from the virtual keyboard
  void _handleKeyPress(String key) {
    setState(() {
      if (key == 'Backspace') {
        if (currentInput.isNotEmpty) {
          currentInput = currentInput.substring(0, currentInput.length - 1);
        }
      } else if (key == 'Space') {
        currentInput += ' ';
      } else if (key == 'Enter') {
        int currentIndex = controllers.indexOf(activeController!);
        if (currentIndex < controllers.length - 1) {
          _onFieldTap(
              controllers[currentIndex + 1], focusNodes[currentIndex + 1]);
        } else {
          setState(() {
            isKeyboardVisible = false;
          });
        }
      } else {
        currentInput += key;
      }

      activeController?.text = currentInput;
    });
  }

  void _onFieldTap(TextEditingController controller, FocusNode focusNode) {
    setState(() {
      activeController = controller;
      currentInput = controller.text;
      isKeyboardVisible = true;
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  void _hideKeyboard() {
    setState(() {
      isKeyboardVisible = false;
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _hideKeyboard,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double keyboardHeight =
                isKeyboardVisible ? constraints.maxHeight * 0.5 : 0;

            return Column(
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                      ),
                      child: Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Patient Details",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              controller: controller.nameController,
                              focusNode: nameFocusNode,
                              decoration: const InputDecoration(
                                labelText: "Patient Name",
                                border: OutlineInputBorder(),
                              ),
                              onTap: () {
                                _onFieldTap(
                                    controller.nameController, nameFocusNode);
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-zA-Z\s]+$')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: controller.ageController,
                              focusNode: ageFocusNode,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Age",
                                border: OutlineInputBorder(),
                              ),
                              onTap: () {
                                _onFieldTap(
                                    controller.ageController, ageFocusNode);
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid age';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Obx(() => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: controller.patients.length < 8
                                          ? () {
                                              controller.submitForm();
                                              setState(() {
                                                isKeyboardVisible = false;
                                              });
                                            }
                                          : null,
                                      child: const Text("Submit"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.navigateToCapture();
                                      },
                                      child: const Text("Next"),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Display the list of patients
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: controller.patients.length,
                      itemBuilder: (context, index) {
                        final patient = controller.patients[index];
                        return ListTile(
                          title: Text(patient.name),
                          subtitle: Text('Age: ${patient.age}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Show a confirmation dialog before deleting
                              Get.defaultDialog(
                                title: 'Delete Patient',
                                middleText:
                                    'Are you sure you want to delete ${patient.name}?',
                                confirm: ElevatedButton(
                                  onPressed: () {
                                    controller.patients.removeAt(index);
                                    Get.back(); // Close the dialog
                                  },
                                  child: const Text('Yes'),
                                ),
                                cancel: ElevatedButton(
                                  onPressed: () {
                                    Get.back(); // Close the dialog without deleting
                                  },
                                  child: const Text('No'),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: keyboardHeight,
                  child: isKeyboardVisible
                      ? ResponsiveVirtualKeyboard(onKeyPress: _handleKeyPress)
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
