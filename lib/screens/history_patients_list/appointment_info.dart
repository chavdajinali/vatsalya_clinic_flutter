import 'package:flutter/material.dart';
import 'package:vatsalya_clinic/components/AppLabelValue.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';

class AppointmentInfo extends StatelessWidget {
  final AppointmentModel appointmentData;

  const AppointmentInfo({super.key, required this.appointmentData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Appointment Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          AppLabelValue(
              label: "Chief Complaint",
              value: appointmentData.appointmentChiefComplain ?? 'N/A'),
          const SizedBox(
            height: 8,
          ),
          AppLabelValue(
              label: "Reference",
              value: appointmentData.appointmentReferenceBy ?? 'N/A'),
          const SizedBox(
            height: 8,
          ),
          AppLabelValue(
              label: "Payment Type",
              value: appointmentData.paymentType ?? "N/A"),
          const SizedBox(
            height: 8,
          ),
          AppLabelValue(
              label: "Payment Amount",
              value: appointmentData.paymentAmount ?? "N/A")
        ],
      ),
    );
  }
}
