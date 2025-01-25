import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/screens/book_appoinment/book_appoinment_screen.dart';
import 'package:vatsalya_clinic/screens/report/reportscreen.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';
import 'package:vatsalya_clinic/utils/ResponsiveBuilder.dart';
import '../../../main.dart';
import '../../payment/payment_dialog.dart';

class TodaysAppointmentPage extends StatefulWidget {
  const TodaysAppointmentPage({super.key});

  @override
  State<TodaysAppointmentPage> createState() => _TodaysAppointmentPageState();
}

class _TodaysAppointmentPageState extends State<TodaysAppointmentPage> {
  List<AppointmentModel> appointmentList = [];
  List<AppointmentModel> fetchedList = [];
  bool isLoading = true; // Track loading state

  Future<void> _loadAppointmentDetails() async {
    setState(() {
      isLoading = true;
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
        appointmentList = updatedList;
        isLoading = false;
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching data: $error");
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAppointmentDetails();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Adaptive font sizes
        double titleFontSize = getFontSize(sizingInformation, 24, 18, 16);
        double buttonFontSize = getFontSize(sizingInformation, 16, 14, 12);
        double cardFontSize = getFontSize(sizingInformation, 16, 14, 12);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today\'s Appointments',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          GradientButton(
                            text: 'Book New Appointment',
                            fontsize: buttonFontSize,
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookAppoinmentScreen(),
                                ),
                              );
                              _loadAppointmentDetails(); // Reload data after returning
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : appointmentList.isEmpty
                          ? const Center(
                        child: Text(
                          'No Data Found.',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildListView(appointmentList, cardFontSize),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListView(List<AppointmentModel> appointments, double fontSize) {
    return ListView.separated(
      itemCount: appointments.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.transparent),
      itemBuilder: (context, index) {
        return _buildAppointmentCard(appointments[index], fontSize);
      },
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment, double fontSize) {
    Color paymentButtonColor = appointment.isPayment ? Colors.green : Colors.red;
    String paymentButtonText = appointment.isPayment ? "Paid" : "Payment";

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${appointment.patientName}', style: TextStyle(fontSize: isDesktop ? fontSize : 14,fontWeight: FontWeight.bold)),
                      SizedBox(height: isDesktop ? 8 : 10),
                      Text(
                        'Date: ${appointment.appointmentDate} ${appointment.appointmentTime}',
                        style: TextStyle(color: Colors.black54, fontSize: fontSize),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    _buildAddReportsButton(appointment, fontSize),
                    const SizedBox(height: 8),
                    _buildPaymentButton(appointment, paymentButtonColor, paymentButtonText, fontSize),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddReportsButton(AppointmentModel appointment, double fontSize) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[200], // Set the background color
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Add padding for better touch target
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportScreen(appointment),
          ),
        );
      },
      child: Text(
        'Add Reports',
        style: TextStyle(
          color: Colors.blue, // Text color
          fontSize: fontSize, // Responsive font size
        ),
      ),
    );
  }

  Widget _buildPaymentButton(AppointmentModel appointment, Color color, String text, double fontSize) {
    return TextButton(
      onPressed: () async {
        if (!appointment.isPayment) {
          await showDialog(
            context: context,
            builder: (context) => PaymentDialog(appointmentId: appointment.id),
          );
          await _loadAppointmentDetails();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment already made for this appointment.')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: fontSize)),
      ),
    );
  }

  double getFontSize(SizingInformation sizingInformation, double desktopSize, double tabletSize, double mobileSize) {
    switch (sizingInformation.deviceScreenType) {
      case DeviceScreenType.Desktop:
        return desktopSize;
      case DeviceScreenType.Tablet:
        return tabletSize;
      default:
        return mobileSize;
    }
  }
}