import 'package:cloud_firestore/cloud_firestore.dart';

class AddPatientsFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addPatient({
    required String name,
    required String age,
    required String gender,
    required String mobile,
    required String createdDate,
    required String address,
  }) async {
    try {
      await _firestore.collection('patients_tbl').add({
        'name': name,
        'age': age,
        'gender': gender,
        'mobile': mobile,
        'created_date': createdDate, // Store date as ISO string
        'address': address,
      });
      print("Patient added successfully!");
      return null;
    } catch (e) {
      print("Error adding patient: $e");
      return "Error adding patient: $e";
    }
  }
}
