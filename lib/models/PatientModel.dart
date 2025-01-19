class PatientModel {
  late String id;
  final String name;
  final String age;
  final String gender;
  final String mobile;
  bool isExpanded; // Add this property

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.mobile,
    this.isExpanded = false,
  });
}
