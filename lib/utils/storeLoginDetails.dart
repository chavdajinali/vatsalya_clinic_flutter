import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/models/patients_model.dart';
import 'package:vatsalya_clinic/models/refrence_model.dart';
import 'package:vatsalya_clinic/models/user_model.dart';

Future<void> storeLoginDetails(UserModel userDetails) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_details', jsonEncode(userDetails.toJson()));
}

Future<UserModel> getLoginDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return UserModel.fromJson(
      jsonDecode(prefs.getString('user_details') ?? "{}"));
}

Future<List<String>> getNamesFromFirestore() async {
  List<String> names = [];

  // Get a reference to the Firestore collection
  final CollectionReference referenceTbl =
      FirebaseFirestore.instance.collection('refernce_tbl');

  // Query the collection for all documents
  QuerySnapshot querySnapshot = await referenceTbl.get();

  // Iterate through the documents and extract the 'name' field
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    names.add(
        doc.get('name') as String); // Assuming 'name' is the field for names
  }

  return names;
}

Future<List<AppointmentModel>> getAppoinmentFromFirestore() async {
  List<AppointmentModel> appointmentList = [];

  // Get a reference to the Firestore collection
  final CollectionReference appointmentTbl =
      FirebaseFirestore.instance.collection('appointment_tbl');

  // Query the collection for all documents
  QuerySnapshot querySnapshot = await appointmentTbl.get();
  final currentDate = DateTime.now();

  // Iterate through the documents and extract the 'appointmentDate' field
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    AppointmentModel data =
    AppointmentModel.fromJson(doc.data() as Map<String, dynamic>);

    // Check if the appointmentDate matches the current date
    if (data.appointmentDate != null) {
      // Convert the appointmentDate (Timestamp) to DateTime
      DateTime appointmentDate = data.appointmentDate;

      // Compare year, month, and day
      if (appointmentDate.year == currentDate.year &&
          appointmentDate.month == currentDate.month &&
          appointmentDate.day == currentDate.day) {
        appointmentList.add(data);
      }
    }
  }

  return appointmentList;
}

Future<List<PatientsModel>> getNamesOfPatientsFromFirestore() async {
  List<PatientsModel> PatientsModelList = [];

  // Get a reference to the Firestore collection
  final CollectionReference patientsTbl =
      FirebaseFirestore.instance.collection('patients_tbl');

  // Query the collection for all documents
  QuerySnapshot querySnapshot = await patientsTbl.get();

  // Iterate through the documents and extract the 'name' field
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    var patient = PatientsModel.fromJson(doc.data() as Map<String, dynamic>);
    patient.id = doc.id;
    PatientsModelList.add(patient); // Assuming 'name' is the field for names
  }

  return PatientsModelList;
}

Future<void> removeSpecificData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key); // Removes the data associated with the specified key
  print("Data removed for key: $key");
}
