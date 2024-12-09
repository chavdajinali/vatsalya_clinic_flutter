import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  late String? patientName;
  late String? appointmentDate;
  late String? appointmentTime;
  late String? appointmentReferenceBy;
  late String? appointmentChiefComplain;


  AppointmentModel(
      {
        required this.patientName,
        required this.appointmentDate,
        required this.appointmentTime,
        required this.appointmentReferenceBy,
        required this.appointmentChiefComplain});

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
      patientName: json['patients_name'] ?? "",
      appointmentDate: json['appoinment_date'] ?? "",
      appointmentTime:  json['appoinment_time'] ?? "",
      appointmentReferenceBy: json['reference_by'] ?? "",
      appointmentChiefComplain:json['chief_complain'] ?? "");

  Map<String, dynamic> toJson() =>
      {'patients_name': patientName, 'appoinment_date': appointmentDate, 'appoinment_time': appointmentTime,'reference_by': appointmentReferenceBy,'chief_complain': appointmentChiefComplain};

  AppointmentModel copyWith(
      {String? patientName, String? appointmentDate, String? appointmentTime, String? appointmentReferenceBy, String? appointmentChiefComplain}) =>
      AppointmentModel(
          patientName: patientName ?? this.patientName,
          appointmentDate: appointmentDate ?? this.appointmentDate,
          appointmentTime: appointmentTime ?? this.appointmentTime,
          appointmentReferenceBy: appointmentReferenceBy ?? this.appointmentReferenceBy,
          appointmentChiefComplain: appointmentChiefComplain ?? this.appointmentChiefComplain);
}