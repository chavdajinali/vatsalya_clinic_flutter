import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/screens/book_appoinment/book_appoinment_screen.dart';
import 'package:vatsalya_clinic/screens/report/reportScreen.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';
import '../../payment/payment_dialog.dart';

class TodaysAppointmentPage extends StatefulWidget {
  const TodaysAppointmentPage({super.key});

  @override
  State<TodaysAppointmentPage> createState() => _TodaysAppointmentPageState();
}

class _TodaysAppointmentPageState extends State<TodaysAppointmentPage> {
  List<AppointmentModel> appoinmentList = [];
  List<AppointmentModel> fetchedList = [];
  List<String> patients_id = [];

  Future<void> _loadAppoinmentDetails() async {
    fetchedList = await getAppoinmentFromFirestore();

    List<AppointmentModel> updatedList = [];

    for (var appointment in fetchedList) {
      // Fetch patient details from 'patients_tbl'
      DocumentSnapshot patientSnapshot = await FirebaseFirestore.instance
          .collection('patients_tbl')
          .doc(appointment.patientName)
          .get();

      if (patientSnapshot.exists) {
        var patientName = patientSnapshot['name'];

        // Fetch payment status for this appointment (assuming it's in Firestore)
        appointment = appointment.copyWith(
          patientName: patientName,
        );
      }

      updatedList.add(appointment);
    }

    setState(() {
      appoinmentList = updatedList;
    });

    if (kDebugMode) {
      print(appoinmentList);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAppoinmentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Today\'s Appointments',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      GradientButton(
                        text: 'Book New Appointment',
                        onPressed: () async {
                          // Navigate to the new screen and wait for it to return
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookAppoinmentScreen(),
                            ),
                          );

                          // Reload the appointments after coming back
                          _loadAppoinmentDetails();
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: appoinmentList.isEmpty
                        ? const Center(
                            child: Text('No Data Found.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                )),
                          )
                        : ListView.separated(
                            itemCount: appoinmentList.length,
                            separatorBuilder: (context, index) => const Divider(
                                height: 1, color: Colors.transparent),
                            itemBuilder: (context, index) {
                              var appointment = appoinmentList[index];
                              var fetchedData = fetchedList[index];

                              // Determine the button color based on the payment status
                              Color paymentButtonColor = appointment.isPayment
                                  ? Colors.green
                                  : Colors.red;
                              String paymentButtonText =
                                  appointment.isPayment ? "Paid" : "Payment";

                              return Card(
                                color: Colors.grey[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Name: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${appointment.patientName}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Date: ${appointment.appointmentDate} ${appointment.appointmentTime}',
                                              style: const TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReportScreen(fetchedData),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 10.0),
                                                child: Text('Add Details',
                                                    style: TextStyle(
                                                        color: Colors.blue)),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {

                                             await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return PaymentDialog(appointmentId: appointment.id,); // Display the dialog
                                                },
                                              );

                                             // Reload the appointments after the dialog is closed
                                             await _loadAppoinmentDetails();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: paymentButtonColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 10.0),
                                                child: Text(paymentButtonText,
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
