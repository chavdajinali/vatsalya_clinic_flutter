import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/models/report_model.dart';

class AppointmentModel {
  late String id;
  late String? patientName;
  late DateTime appointmentDate; // Use DateTime for consistency
  late String? appointmentTime;
  late String? appointmentReferenceBy;
  late String? appointmentChiefComplain;
  late bool isPayment; // Field for payment status
  late String paymentAmount; // Field for payment amount
  late String? paymentType; // Field for payment type
  late List<ReportModel> reports; // List of reports

  AppointmentModel({
    required this.id,
    required this.patientName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentReferenceBy,
    required this.appointmentChiefComplain,
    required this.isPayment,
    required this.paymentAmount,
    required this.paymentType,
    required this.reports,
  });

  // Factory method to create an instance from Firestore JSON
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? "",
      patientName: json['patients_name'] ?? "",
      appointmentDate: (json['appoinment_date'] as Timestamp?)?.toDate() ??
          DateTime.now(), // Convert Timestamp to DateTime
      appointmentTime: json['appoinment_time'] ?? "",
      appointmentReferenceBy: json['reference_by'] ?? "",
      appointmentChiefComplain: json['chief_complain'] ?? "",
      isPayment: json['is_payment'] ?? false,
      paymentAmount: json['payment_amount'] ?? "0",
      paymentType: json['payment_type'] ?? "Cash",
      reports: (json['reports'] as List<dynamic>? ?? [])
          .map((e) => ReportModel.fromJson(e as Map<String, dynamic>))
          .toList(), // Convert reports list
    );
  }

  // Convert the instance to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patients_name': patientName,
      'appoinment_date': Timestamp.fromDate(appointmentDate), // Convert to Timestamp
      'appoinment_time': appointmentTime,
      'reference_by': appointmentReferenceBy,
      'chief_complain': appointmentChiefComplain,
      'is_payment': isPayment,
      'payment_amount': paymentAmount,
      'payment_type': paymentType,
      'reports': reports.map((e) => e.toJson()).toList(), // Convert reports list
    };
  }

  // Create a copy of the object with modified values
  AppointmentModel copyWith({
    String? id,
    String? patientName,
    DateTime? appointmentDate,
    String? appointmentTime,
    String? appointmentReferenceBy,
    String? appointmentChiefComplain,
    bool? isPayment,
    String? paymentAmount,
    String? paymentType,
    List<ReportModel>? reports,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      appointmentReferenceBy: appointmentReferenceBy ?? this.appointmentReferenceBy,
      appointmentChiefComplain: appointmentChiefComplain ?? this.appointmentChiefComplain,
      isPayment: isPayment ?? this.isPayment,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      paymentType: paymentType ?? this.paymentType,
      reports: reports ?? this.reports,
    );
  }
}