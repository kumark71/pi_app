class PatientResult {
  final String patientName;
  final String patientAge;
  final String result;

  PatientResult({
    required this.patientName,
    required this.patientAge,
    required this.result,
  });

  // Factory method to create an instance from JSON
  factory PatientResult.fromJson(Map<String, dynamic> json) {
    return PatientResult(
      patientName: json['patient_name'] as String,
      patientAge: json['patient_age'] as String,
      result: json['result'] as String,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'patient_name': patientName,
      'patient_age': patientAge,
      'result': result,
    };
  }
}

class ApiResponse {
  final String status;
  final String statusCode;
  final List<PatientResult> data;
  final String message;

  ApiResponse({
    required this.status,
    required this.statusCode,
    required this.data,
    required this.message,
  });

  // Factory method to create an instance from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<PatientResult> patients =
        dataList.map((item) => PatientResult.fromJson(item)).toList();

    return ApiResponse(
      status: json['status'] as String,
      statusCode: json['status_code'] as String,
      data: patients,
      message: json['message'] as String,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_code': statusCode,
      'data': data.map((patient) => patient.toJson()).toList(),
      'message': message,
    };
  }
}
