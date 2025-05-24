import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/screens/book_appoinment/book_appoinment_screen.dart';
import 'package:vatsalya_clinic/screens/graph/audio_gram_chart_screen.dart';
import 'package:vatsalya_clinic/screens/report/reportscreen.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/ResponsiveBuilder.dart';
import '../../payment/payment_dialog.dart';

class TodaysAppointmentPage extends StatefulWidget {
  const TodaysAppointmentPage({super.key});

  @override
  State<TodaysAppointmentPage> createState() => _TodaysAppointmentPageState();
}

class _TodaysAppointmentPageState extends State<TodaysAppointmentPage> {
  List<AppointmentModel> appointmentList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointmentDetails();
  }

  String getSeprateDateTime(String dateTimeString, bool isDateOrNot) {
    // Parse the full date-time
    DateFormat format = DateFormat("dd/MM/yyyy hh:mm a");
    DateTime parsedDateTime = format.parse(dateTimeString);
    String separatedDate = DateFormat("dd/MM/yyyy").format(parsedDateTime);
    String separatedTime12hr = DateFormat("hh:mm a").format(parsedDateTime);

    if (isDateOrNot) {
      return separatedDate;
    } else {
      return separatedTime12hr;
    }
  }

  Future<void> _loadAppointmentDetails() async {
    setState(() => isLoading = true);

    try {
      final today = DateTime.now().copyWith(
          hour: 00, minute: 00, second: 00, millisecond: 0, microsecond: 0);

      // Fetch today's appointments
      final querySnapshot = await FirebaseFirestore.instance
          .collection('appointment_tbl')
          .where('timestamp', isGreaterThanOrEqualTo: today)
          .where('timestamp',
              isLessThanOrEqualTo: today.add(const Duration(days: 1)))
          .get();

      List<AppointmentModel> tempList = querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data(), doc.id))
          .toList();

      // Fetch patient names
      for (var appointment in tempList) {
        appointment = await _getPatientName(appointment);
      }

      setState(() {
        appointmentList = tempList;
        isLoading = false;
      });
    } catch (error) {
      if (kDebugMode) print("Error fetching data: $error");
      setState(() => isLoading = false);
    }
  }

  Future<AppointmentModel> _getPatientName(AppointmentModel appointment) async {
    final patientSnapshot = await FirebaseFirestore.instance
        .collection('patients_tbl')
        .doc(appointment.patientId)
        .get();

    if (patientSnapshot.exists) {
      return appointment.copyWith(patientName: patientSnapshot['name']);
    }
    return appointment;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
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
                    _buildHeader(titleFontSize, buttonFontSize),
                    const Divider(height: 1),
                    Expanded(child: _buildBody(cardFontSize)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double getFontSize(SizingInformation sizingInfo, double desktopSize,
      double tabletSize, double mobileSize) {
    switch (sizingInfo.deviceScreenType) {
      case DeviceScreenType.Desktop:
        return desktopSize;
      case DeviceScreenType.Tablet:
        return tabletSize;
      case DeviceScreenType.Mobile:
      default:
        return mobileSize;
    }
  }

  Widget _buildHeader(double titleFontSize, double buttonFontSize) {
    return Padding(
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
            text: 'Book Appointment',
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
    );
  }

  Widget _buildBody(double cardFontSize) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (appointmentList.isEmpty) {
      return const Center(
        child: Text(
          'No Data Found.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: appointmentList.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, color: Colors.transparent),
        itemBuilder: (context, index) =>
            _buildAppointmentCard(appointmentList[index], cardFontSize),
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment, double fontSize) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${appointment.patientName}',
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold)),
                      // const SizedBox(height: 8),
                      Text(
                        'Date: ${getSeprateDateTime(appointment.dateTime, true)}',
                        style: TextStyle(
                            color: Colors.black54, fontSize: fontSize),
                      ),
                      Text(
                        'Time: ${getSeprateDateTime(appointment.dateTime, false)}',
                        style: TextStyle(
                            color: Colors.black54, fontSize: fontSize),
                      ),
                    ],
                  ),
                ),
                /*     Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAddReportsButton(appointment, fontSize),
                    // const SizedBox(height: 8),
                    _buildPaymentButton(appointment, fontSize)
                  ],
                ),*/
                Divider(
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportScreen(appointment),
                            ),
                          );
                        },
                        child: Container(
                            color: Colors.blue.shade50,
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Add Report",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      color: Colors.red,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          if (!appointment.isPayment) {
                            await showDialog(
                              context: context,
                              builder: (context) =>
                                  PaymentDialog(appointmentId: appointment.id),
                            );
                            await _loadAppointmentDetails();
                          } /*else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Payment already made.')),
                            );
                          }*/
                        },
                        child: appointment.isPayment
                            ? Container(
                                padding: EdgeInsets.all(8),
                                color: Colors.green.shade50,
                                child: Text(
                                  "Paid",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500),
                                ))
                            : Container(
                                padding: EdgeInsets.all(8),
                                color: Colors.red.shade50,
                                child: Text(
                                  "Payment",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500),
                                )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildAddReportsButton(AppointmentModel appointment, double fontSize) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
        style: TextStyle(color: Colors.blue, fontSize: fontSize),
      ),
    );
  }

  Widget _buildPaymentButton(AppointmentModel appointment, double fontSize) {
    bool isPaid = appointment.isPayment;
    Color buttonColor = isPaid ? Colors.green : Colors.red;
    String buttonText = isPaid ? "Paid" : "Payment";

    return TextButton(
      onPressed: () async {
        if (!isPaid) {
          await showDialog(
            context: context,
            builder: (context) => PaymentDialog(appointmentId: appointment.id),
          );
          await _loadAppointmentDetails();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment already made.')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(10)),
        child: Text(buttonText,
            style: TextStyle(color: Colors.white, fontSize: fontSize)),
      ),
    );
  }
}
