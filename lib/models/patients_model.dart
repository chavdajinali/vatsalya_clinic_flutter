import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';

class PatientsModel {
  late String id;
  late String name;
  late String mobile;
  late String gender;
  late Timestamp createdDate;
  late String age;
  late String address;
  late bool isExpanded;
  late List<AppointmentModel> appointments;
  late double totalPayment;

  PatientsModel(
      {required this.id,
      required this.name,
      required this.mobile,
      required this.gender,
      required this.createdDate,
      required this.age,
      required this.isExpanded,
      required this.appointments,
      required this.address,
      required this.totalPayment});

  factory PatientsModel.fromJson(Map<String, dynamic> json) => PatientsModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      mobile: json['mobile'] ?? "",
      gender: json['gender'] ?? "",
      createdDate: json['createdDate'] ?? "",
      age: json['age'] ?? "",
      address: json['address'] ?? "",
      appointments: [],
      isExpanded: false,
      totalPayment: 0.0);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobile': mobile,
        'gender': gender,
        'createdDate': createdDate,
        'age': age,
        'address': address,
        // 'total_payment': totalPayment,
      };

  PatientsModel copyWith(
          {String? id,
          String? name,
          String? mobile,
          String? gender,
          Timestamp? createdDate,
          String? age,
          List<AppointmentModel>? appointments,
          String? address,
          bool? isExpanded,
          double? totalPayment}) =>
      PatientsModel(
          id: id ?? this.id,
          name: name ?? this.name,
          mobile: mobile ?? this.mobile,
          gender: gender ?? this.gender,
          createdDate: createdDate ?? this.createdDate,
          age: age ?? this.age,
          isExpanded: isExpanded ?? this.isExpanded,
          appointments: appointments ?? this.appointments,
          address: address ?? this.address,
          totalPayment: totalPayment ?? this.totalPayment);
}
