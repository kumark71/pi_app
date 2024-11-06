import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pi_control_app/controllers/result_controller.dart';
import 'package:pi_control_app/routes/app_routes.dart'; // Import your routes

class ResultScreen extends StatelessWidget {
  final ResultController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Results")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid

                  childAspectRatio: 4, // Adjust to control item height
                ),
                itemCount: controller.apiResponse.data.length,
                itemBuilder: (context, index) {
                  final patient = controller.apiResponse.data[index];
                  // Determine the card color based on the result
                  final cardColor = patient.result.toLowerCase() == 'positive'
                      ? Colors.green[100]
                      : Colors.red[100];
                  final textColor = patient.result.toLowerCase() == 'positive'
                      ? Colors.green[800]
                      : Colors.red[800];

                  return Card(
                    elevation: 3,
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Patient: ${patient.patientName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Result: ${patient.result}',
                            style: TextStyle(
                              fontSize: 16,
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 150, // Set the width of the button
              height: 45, // Set the height of the button
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 17),
                ),
                onPressed: () {
                  Get.back();
                },
                child: const Text("Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
