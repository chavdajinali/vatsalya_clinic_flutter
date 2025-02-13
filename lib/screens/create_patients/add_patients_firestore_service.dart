import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/models/patients_model.dart';

class AddPatientsFirestoreService {

  Future<String?> addPatient({
    required String id,
    required String name,
    required String age,
    required String gender,
    required String mobile,
    required Timestamp createdDate,
    required String address,
  }) async {

    try {
      var refId = FirebaseFirestore.instance.collection('patients_tbl').doc();

      PatientsModel newPatients = PatientsModel(
          id: refId.id,
          name: name,
          address: address,
          age: age,
          gender: gender,
          mobile: mobile,
          createdDate: createdDate,appointments: [],
          isExpanded: false,
          totalPayment: 0);

      refId.set(newPatients.toJson());
      return 'success';
    }catch(e) {
      return 'failure';
    }
    // var result =
    //     await FirebaseFirestore.instance.collection('patients_tbl').add({
    //   'name': name,
    //   'age': age,
    //   'gender': gender,
    //   'mobile': mobile,
    //   'created_date': createdDate,
    //   'address': address,
    // });
    // return result.id.toString();
  }
}
