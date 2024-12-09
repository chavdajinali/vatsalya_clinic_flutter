import 'package:cloud_firestore/cloud_firestore.dart';

class AddPatientsFirestoreService {

  Future<String?> addPatient({
    required String name,
    required String age,
    required String gender,
    required String mobile,
    required String createdDate,
    required String address,
  }) async {
    var result =
        await FirebaseFirestore.instance.collection('patients_tbl').add({
      'name': name,
      'age': age,
      'gender': gender,
      'mobile': mobile,
      'created_date': createdDate,
      'address': address,
    });
    return result.id.toString();
  }
}
