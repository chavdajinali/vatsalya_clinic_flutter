import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/utils/CustomPicker.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/textfield_builder.dart';
import 'reportfirestoreservice.dart';

class ReportScreen extends StatefulWidget {
  final AppointmentModel appointment;
  ReportScreen(this.appointment);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final List<String> reportNames = ['PTA', 'Impedance', 'ETF Test','OAE Test','BERA Test','ASSR Test','Speech Assessment','Special Test','Bill'];
  String? selectedReport;
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Variable to hold patient data from Firestore
  Map<String, dynamic>? patientData;
  // List to store the reports and images
  List<Map<String, dynamic>> reports = [];


  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          imageFile = pickedFile;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Fetch patient data from Firestore
  Future<void> fetchPatientData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('patients_tbl')
          .doc(widget.appointment.patientName)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          patientData = docSnapshot.data();
        });

        nameController.text = patientData?['name'] ?? '';
        ageController.text = patientData?['age'] ?? '';
        mobileController.text = patientData?['mobile'] ?? '';
        addressController.text = patientData?['address'] ?? '';
      } else {
        print("No patient found with this name as the document ID.");
      }
    } catch (e) {
      print("Error fetching patient data: $e");
    }
  }

  // Function to handle Save button click
  void saveReport() {
    if (selectedReport != null && imageFile != null) {
      // Save the report name and image to the list
      setState(() {
        reports.add({
          'reportname': selectedReport,
          'reportimage': imageFile!.path,
          'reportimage_name' : imageFile!.name
        });
      });

      // Clear the selected report and image after saving
      setState(() {
        selectedReport = null;
        imageFile = null;
      });
      // Show SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Report saved: $selectedReport"),
          duration: const Duration(seconds: 2),
        ),
      );
      print("Report saved: $selectedReport");
    } else {
      // Show SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a report and pick an image."),
          duration: Duration(seconds: 2),
        ),
      );
      print("Please select a report and pick an image");
    }
  }

  // Sort the reports list by report name
  List<Map<String, dynamic>> sortedReports() {
    List<Map<String, dynamic>> sorted = List.from(reports);
    sorted.sort((a, b) => a['reportname'].compareTo(b['reportname']));
    return sorted;
  }

  void removeAddedReportFromList(int index) {
    setState(() {
      reports.removeAt(index); // Remove the report at the given index
    });

    // Show SnackBar for confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Report removed"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> submitReportData() async {
    if (sortedReports().isNotEmpty) {
      if (sortedReports().length == 1) {
        print('Patient ID: ${widget.appointment.patientName.toString()}');
        print('Report Name: ${sortedReports()[0]['reportname']}');
        print('Report Image Path: ${sortedReports()[0]['reportimage']}');
        print('Report Date: ${widget.appointment.appointmentDate.toString()}');
        print('Report Image Name: ${sortedReports()[0]['reportimage_name']}');

        String? result = await Reportfirestoreservice().addReport(
          patients_id: widget.appointment.patientName.toString(),
          report_name: sortedReports()[0]['reportname'],
          report_image: sortedReports()[0]['reportimage'],
          report_date: widget.appointment.appointmentDate.toString(),
          report_image_name: '${widget.appointment.patientName.toString()}:${sortedReports()[0]['reportimage_name']}',

    );
      }else if (sortedReports().length > 1){
          for (int i=0;i<sortedReports().length;i++) {
            String? result = await Reportfirestoreservice().addReport(
              patients_id: widget.appointment.patientName.toString(),
              report_name: sortedReports()[i]['reportname'],
              report_image: sortedReports()[i]['reportimage'],
              report_date: widget.appointment.appointmentDate.toString(),
              report_image_name: '${widget.appointment.patientName.toString()}:${sortedReports()[i]['reportimage_name']}',
            );
          }
      }
    }else{
      // Show SnackBar for confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Enter Report."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildResponsiveContent(double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        buildTextField(controller: nameController, labelText: 'Name', readOnly: true, obscureText: false),
        const SizedBox(height: 16),
        buildTextField(controller: ageController, labelText: 'Age', readOnly: true, obscureText: false),
        const SizedBox(height: 16),
        buildTextField(controller: mobileController, labelText: 'Mobile', readOnly: true, obscureText: false),
        const SizedBox(height: 16),
        buildTextField(controller: addressController, labelText: 'Address', readOnly: true, obscureText: false),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: buildTextField(
                controller: TextEditingController(text: selectedReport),
                onTap: () => CustomPicker.show(
                  context: context,
                  items: reportNames,
                  title: 'Select Report',
                  onSelected: (value) {
                    setState(() {
                      selectedReport = value;
                    });
                  },
                ),
                readOnly: true,
                labelText: 'Select Report',
                decoration: InputDecoration(
                  labelText: "Select Report",
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                obscureText: false,
              ),
            ),
            const SizedBox(width: 16),
            if (imageFile == null)
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
                onPressed: () => _pickImage(ImageSource.gallery),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 4,
                ),
              )
            else
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery), // Allow user to replace the image
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.network(
                        imageFile!.path, // Web: Network path
                        width: 120,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Image.file(
                        File(imageFile!.path), // Mobile: Local file
                        width: 120,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text(''),
                    onPressed: () {
                      setState(() {
                        imageFile = null; // Clear the picked image
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 4,
                    ),
                  ),
                ],
              ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('SAVE'),
              onPressed: saveReport,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (sortedReports().isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Selected reports data:"),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: sortedReports().length,
            itemBuilder: (context, index) {
              final report = sortedReports()[index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  trailing: IconButton(onPressed: () => removeAddedReportFromList(index), icon: const Icon(Icons.close)),
                  leading: kIsWeb
                      ? Image.network(
                    report['reportimage'], // Web: Network path
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : Image.file(
                    File(report['reportimage']), // Mobile: Local file
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(report['reportname']),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: GradientButton(
            padding: const EdgeInsets.all(12.0),
            text: 'Submit Report',
            onPressed: submitReportData,
          ),
        ),
      ],
    );
  }


  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Patients Details')),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            child: _buildResponsiveContent(width),
          ),
        ),
      ),
    );
  }
}
