import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';

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

  // Function to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to select a time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }


  Future<void> _loadReferenceOptions() async {
    List<String> nameList = await getNamesFromFirestore();
    setState(() {
      referenceOptions = nameList;
    });
    if (kDebugMode) {
      print(nameList);
    }
    // final model = await getRefrenceByList();
    // setState(() {
    //   referenceOptions = model?.options ?? [];
    // });
  }


  @override
  void initState() {
    super.initState();
    _loadReferenceOptions(); // Load reference options when the screen is initialized
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
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
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
              child:
              GradientButton(
                  padding: EdgeInsets.all(12.0),
                  text: 'Book Appointment', onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => BookAppoinmentScreen()));
                // BlocProvider(
                //     create: (BuildContext context) => CreatePatientsBloc(),
                //     child: const CreatePatientsScreen()),
              }),
            ),
          ],
        ),
      ),
    );
  }
}
