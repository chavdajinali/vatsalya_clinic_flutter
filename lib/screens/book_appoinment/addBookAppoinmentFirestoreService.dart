import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';

class Addbookappoinmentfirestoreservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addAppoinment({
    required String patients_name,
    required String appoinment_time,
    required String appoinment_date,
    String? reference_by,
    required String chief_complain,
  }) async {

    AppointmentModel newAppointment = AppointmentModel(
      patientName: patients_name,
      appointmentDate: appoinment_date,
      appointmentTime: appoinment_time,
      appointmentReferenceBy: reference_by,
      appointmentChiefComplain : chief_complain,
      payment : "No",
    );

    try {
      await FirebaseFirestore.instance.collection('appointment_tbl').add(newAppointment.toJson());
      print('Appointment added successfully!');
      return 'Appointment added successfully!';
    } catch (e) {
      print('Error adding appointment: $e');
      return 'Error adding appointment: $e';
    }

  }
}



