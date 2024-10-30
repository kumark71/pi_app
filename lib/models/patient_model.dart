class PatientModel {
  final String name;
  final String age;

  PatientModel({required this.name, required this.age});
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }
}
