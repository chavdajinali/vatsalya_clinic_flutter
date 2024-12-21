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
  bool isLoading = true; // Flag to track loading state

  Future<void> _loadAppoinmentDetails() async {
    setState(() {
      isLoading = true; // Show loader while fetching data
    });

    try {
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

          // Update appointment with patient details
          appointment = appointment.copyWith(
            patientName: patientName,
          );
        }

        updatedList.add(appointment);
      }

      setState(() {
        appoinmentList = updatedList;
        isLoading = false; // Stop showing loader once data is loaded
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching data: $error");
      }
      setState(() {
        isLoading = false; // Stop loader even if there is an error
      });
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
            margin: const EdgeInsets.all(16),surfaceTintColor: Colors.white,color: Colors.white,
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
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookAppoinmentScreen(),
                            ),
                          );
                          _loadAppoinmentDetails(); // Reload data after returning
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: isLoading
                      ? const Center(
                    child: CircularProgressIndicator(), // Show loader
                  )
                      : Padding(
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
                      separatorBuilder: (context, index) =>
                      const Divider(
                          height: 1, color: Colors.transparent),
                      itemBuilder: (context, index) {
                        var appointment = appoinmentList[index];
                        var fetchedData = fetchedList[index];

                        Color paymentButtonColor =
                        appointment.isPayment
                            ? Colors.green
                            : Colors.red;
                        String paymentButtonText =
                        appointment.isPayment
                            ? "Paid"
                            : "Payment";

                        return Card(
                          color: Colors.white,
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
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          const Text(
                                            'Name: ',
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                          ),
                                          Text(
                                            '${appointment.patientName}',
                                            overflow: TextOverflow
                                                .ellipsis,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Date: ${appointment.appointmentDate} ${appointment.appointmentTime}',
                                        style: const TextStyle(
                                            color:
                                            Colors.black54),
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
                                                ReportScreen(
                                                    fetchedData),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors
                                                .grey.shade200,
                                            borderRadius:
                                            const BorderRadius
                                                .all(
                                                Radius.circular(
                                                    10.0))),
                                        child: const Padding(
                                          padding:
                                          EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 10.0),
                                          child: Text(
                                              'Add Reports',
                                              style: TextStyle(
                                                  color: Colors
                                                      .blue)),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (!appointment
                                            .isPayment) {
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext
                                            context) {
                                              return PaymentDialog(
                                                appointmentId:
                                                appointment.id,
                                              );
                                            },
                                          );
                                          await _loadAppoinmentDetails();
                                        } else {
                                          ScaffoldMessenger.of(
                                              context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Payment already made for this appointment.'),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                            paymentButtonColor,
                                            borderRadius:
                                            const BorderRadius
                                                .all(
                                                Radius.circular(
                                                    10.0))),
                                        child: Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 16.0,
                                              vertical: 10.0),
                                          child: Text(
                                              paymentButtonText,
                                              style:
                                              const TextStyle(
                                                  color: Colors
                                                      .white)),
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

