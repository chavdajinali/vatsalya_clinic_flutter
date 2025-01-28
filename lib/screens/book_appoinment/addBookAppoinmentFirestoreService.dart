import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';

class AddBookAppointmentFirestoreService {
  Future<String?> addAppointment({
    required String patients_name,
    required String appoinment_time,
    required Timestamp appoinment_date, // Still receive Timestamp here
    String? reference_by,
    required String chief_complain,
  }) async {
    try {
      var refId =
      FirebaseFirestore.instance.collection('appointment_tbl').doc();

      // Convert Timestamp to DateTime
      DateTime appointmentDateAsDateTime = appoinment_date.toDate();

      AppointmentModel newAppointment = AppointmentModel(
        id: refId.id,
        patientName: patients_name,
        appointmentDate: appointmentDateAsDateTime, // Pass as DateTime
        appointmentTime: appoinment_time,
        appointmentReferenceBy: reference_by,
        appointmentChiefComplain: chief_complain,
        isPayment: false,
        paymentAmount: "",
        paymentType: "",
        reports: [],
      );

      await refId.set(newAppointment.toJson());
      print('Appointment added successfully!');
      return 'Appointment added successfully!';
    } catch (e) {
      print('Error adding appointment: $e');
      return 'Error adding appointment: $e';
    }
  }
}