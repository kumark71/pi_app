import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart'; // Import the virtual keyboard package
import 'package:pi_control_app/controllers/patient_controller.dart';

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
  bool isShiftEnabled = false; // Track if Shift is enabled
  int keyboardVersion =
      0; // To forcefully rebuild the keyboard on each field switch

  // Keep track of which field is currently active
  int currentIndex = 0;

  // Focus nodes for each field
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode ageFocusNode = FocusNode();

  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = []; // Store all focus nodes

  // List of slot numbers (1-10)
  final List<int> slotNumbers = List.generate(10, (index) => index + 1);

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
  void _handleKeyPress(VirtualKeyboardKey key) {
    setState(() {
      if (key.keyType == VirtualKeyboardKeyType.String) {
        // Handle alphanumeric keys, considering Shift state
        currentInput += isShiftEnabled ? key.capsText ?? '' : key.text ?? '';
      } else if (key.keyType == VirtualKeyboardKeyType.Action) {
        // Handle actions like Backspace, Space, and Shift
        switch (key.action) {
          case VirtualKeyboardKeyAction.Backspace:
            if (currentInput.isNotEmpty) {
              currentInput = currentInput.substring(0, currentInput.length - 1);
            }
            break;
          case VirtualKeyboardKeyAction.Return:
            // Move to the next field on Enter key
            _moveToNextField();
            break;
          case VirtualKeyboardKeyAction.Space:
            currentInput += ' ';
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

      // Update the text in the active text field
      activeController?.text = currentInput;
    });
  }

  // Function to show the virtual keyboard and set the active text field
  void _onFieldTap(
      TextEditingController controller, FocusNode focusNode, int index) {
    setState(() {
      activeController = controller;
      currentInput = controller.text; // Sync the current input
      isShiftEnabled = false; // Reset Shift state when switching fields
      isKeyboardVisible = true; // Show the virtual keyboard
      currentIndex = index; // Update the active field index
      FocusScope.of(context)
          .requestFocus(focusNode); // Request focus for the field

      // Force rebuild the keyboard by incrementing the version
      keyboardVersion++;
    });
  }

  // Function to move to the next field
  void _moveToNextField() {
    if (currentIndex < focusNodes.length - 1) {
      // Move to the next field
      setState(() {
        currentIndex++; // Increment the current index
        FocusScope.of(context)
            .requestFocus(focusNodes[currentIndex]); // Move to the next focus
        activeController = controllers[currentIndex];
        currentInput = activeController!.text;
        keyboardVersion++; // Force rebuild of the keyboard
      });
    } else {
      // If the current field is the last one, hide the keyboard
      _hideKeyboard();
    }
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
            double keyboardHeight =
                isKeyboardVisible ? constraints.maxHeight * 0.7 : 0;

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
                                _onFieldTap(controller.nameController,
                                    nameFocusNode, 0);
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
                                    controller.ageController, ageFocusNode, 1);
                              },
                              inputFormatters: [
                                // Accept only numbers
                                FilteringTextInputFormatter.digitsOnly,
                                // Limit input length to 2 characters
                                LengthLimitingTextInputFormatter(2),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid age';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Submit Button
                            Obx(() => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 150, // Set the width of the button
                                      height:
                                          45, // Set the height of the button
                                      child: ElevatedButton(
                                        onPressed:
                                            controller.patients.length < 8
                                                ? () {
                                                    controller.submitForm();
                                                    setState(() {
                                                      isKeyboardVisible = false;
                                                    });
                                                  }
                                                : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          textStyle:
                                              const TextStyle(fontSize: 17),
                                        ),
                                        child: const Text("Submit"),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150, // Set the width of the button
                                      height:
                                          45, // Set the height of the button
                                      child: ElevatedButton(
                                        onPressed: () {
                                          controller.navigateToCapture();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          textStyle:
                                              const TextStyle(fontSize: 17),
                                        ),
                                        child: const Text("Next"),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Display the list of patients only when the keyboard is not visible
                // Display the list of patients only when the keyboard is not visible
                if (!isKeyboardVisible)
                  const SizedBox(
                    height: 16,
                  ),
                if (!isKeyboardVisible)
                  Obx(() => controller.patients.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: controller.patients.length,
                            itemBuilder: (context, index) {
                              final patient = controller.patients[index];
                              return ListTile(
                                leading: Text(
                                  "Slot: ${index + 1}", // Display slot number
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                title: Text(patient.name),
                                subtitle: Text('Age: ${patient.age}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
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
                          ),
                        )
                      : Container()),

                // Virtual Keyboard
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: keyboardHeight,
                  child: isKeyboardVisible
                      ? Container(
                          color: Colors.grey[300], // Gray background color
                          child: VirtualKeyboard(
                            key: ValueKey(
                                keyboardVersion), // Force rebuild by changing key
                            height: 300,
                            textColor: Colors.black,
                            fontSize: 20,
                            defaultLayouts: [
                              VirtualKeyboardDefaultLayouts.English
                            ],
                            type: VirtualKeyboardType.Alphanumeric,
                            postKeyPress: _handleKeyPress,
                          ),
                        )
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
