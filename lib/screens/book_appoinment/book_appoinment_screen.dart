import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/models/patients_model.dart';
import 'package:vatsalya_clinic/screens/book_appoinment/addBookAppoinmentFirestoreService.dart';
import 'package:vatsalya_clinic/utils/ResponsiveBuilder.dart';
import 'package:vatsalya_clinic/utils/app_utils.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';

import '../../main.dart';

class BookAppoinmentScreen extends StatefulWidget {
  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppoinmentScreen> {
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _chiefComplaintController =
      TextEditingController();
  DateTime? selectedDate;
  String? selectedDateString;
  TimeOfDay? selectedTime;
  String? selectedReference;
  List<String> referenceOptions = [];
  List<PatientsModel> patientsList = [];
  List<String> patientsNameOptions = [];
  PatientsModel? selectedPatient;
  String? selecteedPatientsID;
  final dropDownKey = GlobalKey<DropdownSearchState>();

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Restrict to current date or later
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          selectedDateString =
              DateFormat("dd/MM/yyyy hh:mm a").format(selectedDate!);
        });

        print("Selected DateTime: $selectedDate");
      }
    }
  }

  Future<void> _loadReferenceNames() async {
    List<String> names = await getNamesFromFirestore();
    setState(() {
      referenceOptions = names; // Update your state with the fetched names
    });
  }

  Future<void> _loadPatientsOptions() async {
    patientsList = await getNamesOfPatientsFromFirestore();
    setState(() {});
  }

  Future<void> bookAppointment() async {
    // Check if all required fields are selected
    if (selectedPatient != null && selectedDate != null) {
      String? result = await AddBookAppointmentFirestoreService()
          .addAppointment(AppointmentModel(
              id: "",
              patientName: selectedPatient!.name,
              patientId: selectedPatient!.id,
              timestamp: Timestamp.fromDate(selectedDate!),
              dateTime: selectedDateString!,
              appointmentReferenceBy: selectedReference,
              appointmentChiefComplain: _chiefComplaintController.text,
              isPayment: false,
              paymentAmount: "0",
              paymentType: "",
              reports: []));

      // Clear fields if the booking was successful
      if (result == "success") {
        Navigator.pop(context);
      }
      showSnackBar(result, context);
    } else {
      showSnackBar("Please select all required fields.", context);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadReferenceNames();
    _loadPatientsOptions();
  }

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        // Adaptive font sizes
        double fontSize = getFontSize(sizingInfo, 16, 14, 12);
        double buttonFontSize = getFontSize(sizingInfo, 18, 16, 14);
        double inputFontSize = getFontSize(sizingInfo, 14, 12, 10);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
                'Book Appointment' /*, style: TextStyle(fontSize: fontSize)*/),
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name TextField with Search Icon
                  DropdownSearch<PatientsModel>(
                    key: dropDownKey,
                    items: (filter, infiniteScrollProps) => patientsList,
                    onChanged: (value) {
                      setState(() {
                        selectedPatient = value;
                      });
                    },
                    compareFn: (item1, item2) => item1.id == item2.id,
                    itemAsString: (patient) => patient.name,
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: selectedPatient == null
                            ? "Select Patient name"
                            : 'Patient Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                    popupProps: const PopupProps.menu(
                      fit: FlexFit.loose,
                      constraints: BoxConstraints(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date Picker
                  InkWell(
                    onTap: () => _selectDateTime(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText:
                              selectedDateString == null ? null : 'Date & Time',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDateString ?? "Select Date & Time",
                              style: const TextStyle(
                                  /*fontSize: inputFontSize,*/
                                  color: Colors.black87),
                            ),
                            const Icon(
                              Icons.date_range,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reference By Dropdown
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: referenceOptions.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                            value: selectedReference,
                            items: referenceOptions.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option,
                                    style: TextStyle(fontSize: inputFontSize)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedReference = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Reference By',
                              //labelStyle: TextStyle(fontSize: inputFontSize),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Chief Complaint TextField
                  TextFormField(
                    controller: _chiefComplaintController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Chief Complaint',
                      //labelStyle: TextStyle(fontSize: inputFontSize),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  Center(
                    child: GradientButton(
                      padding: const EdgeInsets.all(12.0),
                      text: 'Book Appointment',
                      fontsize: buttonFontSize,
                      onPressed: () {
                        bookAppointment();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// A utility function to get adaptive font size based on the device screen type.
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
}
