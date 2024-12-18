class AppointmentModel {
  late String id;
  late String? patientName;
  late String? appointmentDate;
  late String? appointmentTime;
  late String? appointmentReferenceBy;
  late String? appointmentChiefComplain;
  late bool isPayment; // Add this field for payment status
  late String? paymentAmount; // Add this field for payment status
  late String? paymentType; // Add this field for payment status

  AppointmentModel({
    required this.id,
    required this.patientName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentReferenceBy,
    required this.appointmentChiefComplain,
    required this.isPayment, // Initialize payment field
    required this.paymentAmount, // Initialize payment field
    required this.paymentType, // Initialize payment field
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        id: json['id'] ?? "",
        patientName: json['patients_name'] ?? "",
        appointmentDate: json['appoinment_date'] ?? "",
        appointmentTime: json['appoinment_time'] ?? "",
        appointmentReferenceBy: json['reference_by'] ?? "",
        appointmentChiefComplain: json['chief_complain'] ?? "",
        isPayment: json['is_payment'] ?? false, // Default to "No" if not present
        paymentAmount: json['payment_amount'] ?? "", // Default to "No" if not present
        paymentType: json['payment_type'] ?? "", // Default to "No" if not present
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'patients_name': patientName,
    'appoinment_date': appointmentDate,
    'appoinment_time': appointmentTime,
    'reference_by': appointmentReferenceBy,
    'chief_complain': appointmentChiefComplain,
    'is_payment': isPayment, // Include payment field
    'payment_type': paymentType, // Include payment field
    'payment_amount': paymentAmount, // Include payment field
  };

  AppointmentModel copyWith({
    String? id,
    String? patientName,
    String? appointmentDate,
    String? appointmentTime,
    String? appointmentReferenceBy,
    String? appointmentChiefComplain,
    String? paymentType,
    String? paymentAmount,
    bool? isPayment, // Add payment in copyWith
  }) =>
      AppointmentModel(
        id: id ?? this.id,
        patientName: patientName ?? this.patientName,
        appointmentDate: appointmentDate ?? this.appointmentDate,
        appointmentTime: appointmentTime ?? this.appointmentTime,
        appointmentReferenceBy:
        appointmentReferenceBy ?? this.appointmentReferenceBy,
        appointmentChiefComplain:
        appointmentChiefComplain ?? this.appointmentChiefComplain,
        isPayment: isPayment ?? this.isPayment,
        paymentType: paymentType ?? this.paymentType,
        paymentAmount: paymentAmount ?? this.paymentAmount,
      );
}
