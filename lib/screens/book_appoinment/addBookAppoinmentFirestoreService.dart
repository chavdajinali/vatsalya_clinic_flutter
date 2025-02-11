import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';

class AddBookAppointmentFirestoreService {
  Future<String> addAppointment(AppointmentModel appointment) async {
    try {
      var refId =
          FirebaseFirestore.instance.collection('appointment_tbl').doc();
      appointment.id = refId.id;
      await refId.set(appointment.toJson());
      return 'success';
    } catch (e) {
      print('Error adding appointment: $e');
      return 'Error adding appointment: $e';
    }
  }
}
