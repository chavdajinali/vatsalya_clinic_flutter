import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vatsalya_clinic/models/patients_model.dart';
import 'package:vatsalya_clinic/screens/book_appoinment/addBookAppoinmentFirestoreService.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';

class BookAppoinmentScreen extends StatefulWidget {
  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppoinmentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _chiefComplaintController =
      TextEditingController();
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
      firstDate: DateTime.now(),  // Restrict to current date or later
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
          SnackBar(content: Text('You cannot select a time before the current time')),
        );
      } else {
        setState(() {
          selectedTime = picked;
        });
      }
    }
  }

  void _showToast(BuildContext context, String? result) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(result ?? ""),
      ),
    );
  }

  Future<void> _loadReferenceAndPatientsOptions() async {
    List<String> nameList = await getNamesFromFirestore();
    setState(() {
      referenceOptions = nameList;
    });
    if (kDebugMode) {
      print(nameList);
    }
    patientsList = await getNamesOfPatientsFromFirestore();
    setState(() {
      for (int i = 0; i <= patientsList.length; i++) {
        patientsNameOptions.add(patientsList[i].name);
      }
    });
    if (kDebugMode) {
      print(patientsList);
    }
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
    if (selectedPatientName != null &&
        selectedDate != null &&
        selectedTime != null) {
      String? result = await Addbookappoinmentfirestoreservice().addAppoinment(
        patients_name: selecteedPatientsID.toString(),
        reference_by: selectedReference.toString(),
        appoinment_time: selectedTime!.format(context),
        appoinment_date:
        '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
        chief_complain: _chiefComplaintController.text,
      );

      // Show SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ?? "Something went wrong!"),
          duration: Duration(seconds: 2),
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
    _loadReferenceAndPatientsOptions();
    // Load reference options when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
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
                  labelText: 'Select patient Name ',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
              popupProps: const PopupProps.menu(
                  fit: FlexFit.loose, constraints: BoxConstraints()),
            ),
            const SizedBox(height: 16),

            // Date Picker
            InkWell(
              onTap: () => _selectDate(context),
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
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time Picker
            InkWell(
              onTap: () => _selectTime(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Select Time',
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
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    Icon(Icons.access_time),
                  ],
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
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedReference = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Reference By',
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
                  padding: EdgeInsets.all(12.0),
                  text: 'Book Appointment',
                  onPressed: () {
                    _loadBookAppoinment();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

extension on ScaffoldState {
  void showSnackBar(SnackBar snackBar) {}
}
