import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vatsalya_clinic/models/report_model.dart';

class Reportfirestoreservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addReport(
      {required String patients_id,
      required String report_name,
      required String report_image,
      required Timestamp report_date,
      required String report_image_name}) async {
    if (patients_id.isEmpty ||
        report_name.isEmpty ||
        report_image.isEmpty ||
        report_image_name.isEmpty) {
      return 'Error: All fields must be provided.';
    }

    ReportModel newReport = ReportModel(
      patientID: patients_id,
      reportName: report_name,
      reportImage: report_image,
      reportDate: report_date,
      reportImageName: report_image_name,
    );

    try {

      await FirebaseFirestore.instance
          .collection('report_tbl')
          .add(newReport.toJson());
      print('report added successfully!');
      return 'success';
    } catch (e) {
      print('Error adding report: $e');
      return 'Error adding report: $e';
    }
  }
}
