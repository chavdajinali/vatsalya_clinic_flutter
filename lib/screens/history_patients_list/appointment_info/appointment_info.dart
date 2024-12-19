import 'package:flutter/material.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';

class AppointmentInfo extends StatefulWidget {
  final AppointmentModel appointmentData;
  const AppointmentInfo({super.key, required this.appointmentData});

  @override
  State<AppointmentInfo> createState() => _AppointmentInfoState();
}

class _AppointmentInfoState extends State<AppointmentInfo> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Appointment Details"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Appointment Date: ${widget.appointmentData.appointmentDate ?? 'N/A'}"),
          Text("Patients Name: ${widget.appointmentData.patientName ?? 'N/A'}"),
          Text("Chief Complain: ${widget.appointmentData.appointmentChiefComplain ?? 'N/A'}"),
          Text("Appointment Reference: ${widget.appointmentData.appointmentReferenceBy ?? 'N/A'}"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
