class AppointmentModel {
  late String? patientName;
  late String? appointmentDate;
  late String? appointmentTime;
  late String? appointmentReferenceBy;
  late String? appointmentChiefComplain;
  late String? payment; // Add this field for payment status

  AppointmentModel({
    required this.patientName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentReferenceBy,
    required this.appointmentChiefComplain,
    required this.payment, // Initialize payment field
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        patientName: json['patients_name'] ?? "",
        appointmentDate: json['appoinment_date'] ?? "",
        appointmentTime: json['appoinment_time'] ?? "",
        appointmentReferenceBy: json['reference_by'] ?? "",
        appointmentChiefComplain: json['chief_complain'] ?? "",
        payment: json['payment'] ?? "No", // Default to "No" if not present
      );

  Map<String, dynamic> toJson() => {
    'patients_name': patientName,
    'appoinment_date': appointmentDate,
    'appoinment_time': appointmentTime,
    'reference_by': appointmentReferenceBy,
    'chief_complain': appointmentChiefComplain,
    'payment': payment, // Include payment field
  };

  AppointmentModel copyWith({
    String? patientName,
    String? appointmentDate,
    String? appointmentTime,
    String? appointmentReferenceBy,
    String? appointmentChiefComplain,
    String? payment, // Add payment in copyWith
  }) =>
      AppointmentModel(
        patientName: patientName ?? this.patientName,
        appointmentDate: appointmentDate ?? this.appointmentDate,
        appointmentTime: appointmentTime ?? this.appointmentTime,
        appointmentReferenceBy:
        appointmentReferenceBy ?? this.appointmentReferenceBy,
        appointmentChiefComplain:
        appointmentChiefComplain ?? this.appointmentChiefComplain,
        payment: payment ?? this.payment,
      );
}
