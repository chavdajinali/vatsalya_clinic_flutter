import 'package:cloud_firestore/cloud_firestore.dart';

class Addbookappoinmentfirestoreservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addAppoinment({
    required String patients_name,
    required String appoinment_time,
    required String appoinment_date,
    String? reference_by,
    required String chief_complain,
  }) async {
    try {
      await _firestore.collection('appointment_tbl').add({
        'patients_name': patients_name,
        'appoinment_time': appoinment_time,
        'appoinment_date': appoinment_date,
        'reference_by': reference_by,
        'chief_complain': chief_complain, // Store date as ISO string
      });
      print("Appoinment Book successfully!");
      return null;
    } catch (e) {
      print("Error Book Appoinment: $e");
      return "Error Book Appoinment: $e";
    }
  }
}
