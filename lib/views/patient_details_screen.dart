import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for input formatters
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
  final FocusNode mobileFocusNode = FocusNode();

  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = []; // Store all focus nodes

  @override
  void initState() {
    super.initState();
    controllers.add(controller.nameController);
    controllers.add(controller.ageController);
    controllers.add(controller.mobileController);

    focusNodes.addAll([nameFocusNode, ageFocusNode, mobileFocusNode]);
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    ageFocusNode.dispose();
    mobileFocusNode.dispose();
    super.dispose();
  }

  // Handle key presses from the virtual keyboard
  void _handleKeyPress(String key) {
    setState(() {
      if (key == 'Backspace') {
        // Handle backspace key
        if (currentInput.isNotEmpty) {
          currentInput = currentInput.substring(0, currentInput.length - 1);
        }
      } else if (key == 'Space') {
        // Handle space key
        currentInput += ' ';
      } else if (key == 'Enter') {
        // Move to the next field on Enter key
        int currentIndex = controllers.indexOf(activeController!);
        if (currentIndex < controllers.length - 1) {
          _onFieldTap(
              controllers[currentIndex + 1], focusNodes[currentIndex + 1]);
        } else {
          // Hide keyboard if it's the last field
          setState(() {
            isKeyboardVisible = false;
          });
        }
      } else {
        // Handle alphanumeric keys
        currentInput += key;
      }

      // Update the text in the active text field
      activeController?.text = currentInput;
    });
  }

  // Function to show the virtual keyboard and set the active text field
  void _onFieldTap(TextEditingController controller, FocusNode focusNode) {
    setState(() {
      activeController = controller;
      currentInput = controller.text; // Sync the current input
      isKeyboardVisible = true; // Show the virtual keyboard
      FocusScope.of(context)
          .requestFocus(focusNode); // Request focus for the field
    });
  }

  // Function to hide the keyboard when tapping outside the form
  void _hideKeyboard() {
    setState(() {
      isKeyboardVisible = false;
      FocusScope.of(context).unfocus(); // Remove focus from all fields
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _hideKeyboard, // Hide keyboard when tapping outside
        child: LayoutBuilder(
          builder: (context, constraints) {
            double keyboardHeight = isKeyboardVisible
                ? constraints.maxHeight * 0.5
                : 0; // Keyboard takes up 40% of the screen

            return Column(
              children: [
                // The form part, wrapped with Expanded and Flexible
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

                            // Patient Name Field (Only accept alphabetic characters and spaces)
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
                                // Allow only alphabetic characters and spaces
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

                            // Age Field (Only accept numeric input)
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
                                // Accept only numbers
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

                            // Mobile Number Field
                            TextFormField(
                              controller: controller.mobileController,
                              focusNode: mobileFocusNode,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: "Mobile Number",
                                border: OutlineInputBorder(),
                              ),
                              onTap: () {
                                _onFieldTap(controller.mobileController,
                                    mobileFocusNode);
                              },
                            ),
                            const SizedBox(height: 16),

                            // Gender Dropdown
                            Obx(
                              () => DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: "Gender",
                                  border: OutlineInputBorder(),
                                ),
                                value: controller.selectedGender.value.isEmpty
                                    ? null
                                    : controller.selectedGender.value,
                                items: const [
                                  DropdownMenuItem(
                                      value: "Male", child: Text("Male")),
                                  DropdownMenuItem(
                                      value: "Female", child: Text("Female")),
                                  DropdownMenuItem(
                                      value: "Other", child: Text("Other")),
                                ],
                                onChanged: (value) {
                                  controller.selectedGender.value = value!;
                                  setState(() {
                                    isKeyboardVisible =
                                        false; // Hide keyboard when selecting gender
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Submit Button
                            ElevatedButton(
                              onPressed: () {
                                controller.submitForm();
                                setState(() {
                                  isKeyboardVisible =
                                      false; // Hide keyboard when submitting
                                });
                              },
                              child: const Text("Submit"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Virtual Keyboard
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
