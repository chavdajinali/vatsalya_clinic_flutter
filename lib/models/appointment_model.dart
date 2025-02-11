import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/models/report_model.dart';

class AppointmentModel {
  late String id;
  late String patientName;
  late String patientId;
  late Timestamp timestamp; // Use DateTime for consistency
  late String dateTime; // Use DateTime for consistency
  late String? appointmentReferenceBy;
  late String? appointmentChiefComplain;
  late bool isPayment; // Field for payment status
  late String paymentAmount; // Field for payment amount
  late String? paymentType; // Field for payment type
  late List<ReportModel> reports; // List of reports

  AppointmentModel({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.timestamp,
    required this.appointmentReferenceBy,
    required this.appointmentChiefComplain,
    required this.isPayment,
    required this.paymentAmount,
    required this.paymentType,
    required this.reports,
    required this.dateTime,
  });

  // Factory method to create an instance from Firestore JSON
  factory AppointmentModel.fromJson(Map<String, dynamic> json,[String? id]) {
    return AppointmentModel(
      id: id ?? json['id'] ?? "",
      patientName: json['patient_name'] ?? "",
      patientId: json['patient_id'] ?? "",
      dateTime: json['date_time'] ?? "",
      timestamp: ((json['timestamp'] as Timestamp?) ?? Timestamp.fromDate(DateTime.now())),// Convert Timestamp to DateTime
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
      'patient_name': patientName,
      'patient_id': patientId,
      'timestamp': timestamp,
      'date_time': dateTime,
      'reference_by': appointmentReferenceBy,
      'chief_complain': appointmentChiefComplain,
      'is_payment': isPayment,
      'payment_amount': paymentAmount,
      'payment_type': paymentType,
      'reports': reports.map((e) => e.toJson()).toList(),
      // Convert reports list
    };
  }

  // Create a copy of the object with modified values
  AppointmentModel copyWith({
    String? id,
    String? patientName,
    Timestamp? timestamp,
    String? appointmentReferenceBy,
    String? appointmentChiefComplain,
    bool? isPayment,
    String? paymentAmount,
    String? paymentType,
    String? dateTime,
    List<ReportModel>? reports,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      timestamp: timestamp ?? this.timestamp,
      dateTime: dateTime ?? this.dateTime,
      appointmentReferenceBy:
          appointmentReferenceBy ?? this.appointmentReferenceBy,
      appointmentChiefComplain:
          appointmentChiefComplain ?? this.appointmentChiefComplain,
      isPayment: isPayment ?? this.isPayment,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      paymentType: paymentType ?? this.paymentType,
      reports: reports ?? this.reports,
      patientId: '',
    );
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate(); // Convert Firestore Timestamp to DateTime
    } else if (timestamp is String) {
      return DateTime.parse(timestamp); // Convert ISO string to DateTime
    } else {
      throw TypeError(); // Handle unexpected types
    }
  }

}

