import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/models/payment_model.dart';

class PaymentFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addPaymentData({
    required String appointmentId,
    required String paymentType,
    required String paymentAmount,
  }) async {
    try {
      // Update the payment field to 'Yes'
      await _firestore
          .collection('appointment_tbl')
          .doc(appointmentId)
          .update({
        'is_payment': true,
        'payment_type': paymentType,
        'payment_amount': paymentAmount,
      });
    } catch (e) {
      return 'Error updating appointment payment details: $e';
    }
    // Update the 'appointment_tbl' with the payment status
    return 'success';
  }
}