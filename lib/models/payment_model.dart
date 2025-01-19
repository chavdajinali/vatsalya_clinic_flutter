import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  late String? patient_id;
  late String? appoinmentDate;
  late String? payment_type;
  late String? payment_amount;


  PaymentModel(
      {
        required this.patient_id,
        required this.payment_type,
        required this.appoinmentDate,
        required this.payment_amount});

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
      patient_id: json['patient_id'] ?? "",
      payment_amount: json['payment_amount'] ?? "",
      payment_type:  json['payment_type'] ?? "",
      appoinmentDate: json['appoinmentDate'] ?? "");

  Map<String, dynamic> toJson() =>
      {'patient_id': patient_id, 'payment_amount': payment_amount, 'payment_type': payment_type,'appoinmentDate': appoinmentDate};

  PaymentModel copyWith(
      {String? patient_id, String? payment_amount, String? payment_type, String? appoinmentDate}) =>
      PaymentModel(
          patient_id: patient_id ?? this.patient_id,
          payment_amount: payment_amount ?? this.payment_amount,
          payment_type: payment_type ?? this.payment_type,
          appoinmentDate: appoinmentDate ?? this.appoinmentDate);
}