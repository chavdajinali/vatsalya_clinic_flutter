import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vatsalya_clinic/models/patients_model.dart';
import 'package:vatsalya_clinic/screens/book_appoinment/addBookAppoinmentFirestoreService.dart';
import 'package:vatsalya_clinic/utils/ResponsiveBuilder.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';

import '../../main.dart';

class BookAppoinmentScreen extends StatefulWidget {
  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppoinmentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _chiefComplaintController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedReference;
  List<String> referenceOptions = [];
  List<PatientsModel> patientsList = [];
  List<String> patientsNameOptions = [];
  String? selectedPatientName;
  String? selecteedPatientsID;
  final dropDownKey = GlobalKey<DropdownSearchState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Restrict to current date or later
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay currentTime = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (picked != null) {
      // Compare selected time with current time
      if (picked.hour < currentTime.hour ||
          (picked.hour == currentTime.hour && picked.minute < currentTime.minute)) {
        // If the selected time is before the current time, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You cannot select a time before the current time')),
        );
      } else {
        setState(() {
          selectedTime = picked;
        });
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
    setState(() {
      for (int i = 0; i < patientsList.length; i++) {
        patientsNameOptions.add(patientsList[i].name);
      }
    });
  }

  Future<void> _loadBookAppoinment() async {
    // Find the selected patient's ID
    for (int i = 0; i < patientsList.length; i++) {
      if (selectedPatientName == patientsList[i].name) {
        selecteedPatientsID = patientsList[i].id;
        break; // Exit the loop once the match is found
      }
    }

    // Check if all required fields are selected
    if (selectedPatientName != null && selectedDate != null && selectedTime != null) {
      String? result = await Addbookappoinmentfirestoreservice().addAppoinment(
        patients_name: selecteedPatientsID.toString(),
        reference_by: selectedReference.toString(),
        appoinment_time: selectedTime!.format(context),
        appoinment_date: '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
        chief_complain: _chiefComplaintController.text,
      );

      // Show SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ?? "Something went wrong!"),
          duration: const Duration(seconds: 2),
        ),
      );

      // Clear fields if the booking was successful
      if (result == "Appointment added successfully!") {
        setState(() {
          _chiefComplaintController.clear();
          selectedPatientName = null;
          selecteedPatientsID = null;
          selectedDate = null;
          selectedTime = null;
          selectedReference = null;
          dropDownKey.currentState?.changeSelectedItem(null); // Clear DropdownSearch
        });
        Navigator.pop(context);
      }
    } else {
      // Show a warning if not all fields are selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select all required fields"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadReferenceNames();
    _loadPatientsOptions();
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
          appBar: AppBar(
            title: const Text('Book Appointment'/*, style: TextStyle(fontSize: fontSize)*/),
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name TextField with Search Icon
                  DropdownSearch<String>(
                    key: dropDownKey,
                    items: (filter, infiniteScrollProps) => patientsNameOptions,
                    onChanged: (value) {
                      setState(() {
                        selectedPatientName = value;
                      });
                    },
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: 'Select patient Name',
                        labelStyle: TextStyle(fontSize: inputFontSize),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                    onTap: () => _selectDate(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Select Date',
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
                              selectedDate != null
                                  ? '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}'
                                  : 'Choose Date',
                              style: const TextStyle(/*fontSize: inputFontSize,*/ color: Colors.black87),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
            
                  // Time Picker
                  InkWell(
                    onTap: () => _selectTime(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Select Time',
                         // labelStyle: TextStyle(fontSize: inputFontSize),
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
                              selectedTime != null
                                  ? selectedTime!.format(context)
                                  : 'Choose Time',
                              style: const TextStyle(/*fontSize: inputFontSize,*/ color: Colors.black87),
                            ),
                            const Icon(Icons.access_time),
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
                          child: Text(option, style: TextStyle (fontSize: inputFontSize)),
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
                        _loadBookAppoinment();
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
  double getFontSize(SizingInformation sizingInfo, double desktopSize, double tabletSize, double mobileSize) {
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