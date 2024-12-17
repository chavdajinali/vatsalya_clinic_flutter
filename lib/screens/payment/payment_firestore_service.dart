import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/models/payment_model.dart';

class PaymentFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addPaymentData({
    required String patients_id,
    required String payment_type,
    required String payment_amount,
    required String appoinmentDate
  }) async {

    PaymentModel newPayment = PaymentModel(
      patient_id: patients_id,
      payment_type: payment_type,
      payment_amount: payment_amount,
        appoinmentDate: appoinmentDate
    );

    try {
      await FirebaseFirestore.instance.collection('payment_tbl').add(newPayment.toJson());
      print('Payment added successfully!');
      // Update the 'appointment_tbl' with the payment status
      await _updateAppointmentPaymentStatus(patients_id, appoinmentDate);

      return 'Payment added successfully!';
    } catch (e) {
      print('Error adding Payment: $e');
      return 'Error adding Payment: $e';
    }

  }

  Future<void> _updateAppointmentPaymentStatus(String patients_id, String appoinmentDate) async {
    try {
      // Find the appointment that matches the patient ID and appointment date
      QuerySnapshot appointmentSnapshot = await _firestore
          .collection('appointments_tbl')
          .where('appoinment_date', isEqualTo: appoinmentDate)
          .where('patients_name', isEqualTo: patients_id)
          .get();

      if (appointmentSnapshot.docs.isNotEmpty) {
        var appointmentDoc = appointmentSnapshot.docs.first;

        // Update the payment field to 'Yes'
        await _firestore.collection('appointments_tbl').doc(appointmentDoc.id).update({
          'payment': 'Yes',
        });

        print('Appointment payment status updated successfully!');
      } else {
        print('No matching appointment found for the patient on the given date.');
      }
    } catch (e) {
      print('Error updating appointment payment status: $e');
    }
  }


}



