import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  late String? patientID;
  late String? reportName;
  late String? reportImage;
  late String? reportDate;
  late String? reportImageName;


  ReportModel(
      {
        required this.patientID,
        required this.reportName,
        required this.reportImage,
        required this.reportDate,
        required this.reportImageName});

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
      patientID: json['patientID'] ?? "",
      reportName: json['reportName'] ?? "",
      reportImage:  json['reportImage'] ?? "",
      reportDate: json['reportDate'] ?? "",
      reportImageName:json['report_image_name'] ?? "");

  Map<String, dynamic> toJson() =>
      {'patientID': patientID, 'reportName': reportName, 'reportImage': reportImage,'reportDate': reportDate,'report_image_name':reportImageName};

  ReportModel copyWith(
      {String? patientID, String? reportName, String? reportImage, String? reportDate,String? reportImageName}) =>
      ReportModel(
          patientID: patientID ?? this.patientID,
          reportName: reportName ?? this.reportName,
          reportImage: reportImage ?? this.reportImage,
          reportDate: reportDate ?? this.reportDate,
          reportImageName: reportImageName ?? this.reportImageName);
}