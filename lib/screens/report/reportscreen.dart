import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/utils/CustomPicker.dart';
import 'package:vatsalya_clinic/utils/app_loading_indicator.dart';
import 'package:vatsalya_clinic/utils/app_utils.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/textfield_builder.dart';
import '../../main.dart';
import 'reportfirestoreservice.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ReportScreen extends StatefulWidget {
  final AppointmentModel appointment;

  const ReportScreen(this.appointment, {super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final List<String> reportNames = [
    'PTA',
    'Impedance',
    'ETF Test',
    'OAE Test',
    'BERA Test',
    'ASSR Test',
    'Speech Assessment',
    'Special Test',
    'Bill'
  ];
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
  String? base64String;
  var isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile =
          await _picker.pickImage(source: source, imageQuality: 20);
      if (pickedFile != null) {
        var bytes = await pickedFile.readAsBytes();
        setState(() {
          // Update the image file with the compressed file
          imageFile = pickedFile;

          // Update the base64 string
          base64String = base64Encode(bytes);

          if (kDebugMode) {
            print('Base64 String: $base64String');
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image: $e");
      }
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
        if (kDebugMode) {
          print("No patient found with this name as the document ID.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching patient data: $e");
      }
    }
  }

  Future<String?> uploadImageToFirebaseStorage(
      Map<String, dynamic> report, String patientId) async {
    try {
      var timestamp = DateFormat("ddMMyyyyHHmmss").format(DateTime.now());
      final storageRef = FirebaseStorage.instance.ref().child(
          'reports/$patientId/${report["name"]}/${timestamp}_${report["image_name"]}');

      TaskSnapshot snapshot;

      if (kIsWeb) {
        // For web, use `putData` with the file bytes
        // final bytes = await imageFile.readAsBytes();
        snapshot = await storageRef.putData(base64Decode(report["base64"]));
      } else {
        // For mobile, use `putFile` with a `File` object
        snapshot = await storageRef.putFile(File(report["image"]));
      }
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print("Error uploading image to Firebase Storage: $e");
      }
      return null;
    }
  }

  Future<void> saveReport() async {
    if (selectedReport != null && imageFile != null) {
      var fileLength = (await imageFile!.length()) / 1024;

      setState(() {
        reports.add({
          'name': selectedReport,
          'image': imageFile!.path, // Save the Firebase Storage URL
          'base64': base64String, // Save the Firebase Storage URL
          'image_name': imageFile!.name,
          'length': "${fileLength.toStringAsFixed(2)} kb",
        });

        // Show Snackbar before clearing the values
        showSnackBar("Report saved: $selectedReport", context);

        // Clear the selected report and image
        selectedReport = null;
        imageFile = null;
        base64String = "";
      });

      setState(() {
        isLoading = false;
      });
    } else {
      showSnackBar("Please select a report and pick an image.", context);
    }
  }

  void removeAddedReportFromList(int index) {
    setState(() {
      reports.removeAt(index); // Remove the report at the given index
    });

    // Show SnackBar for confirmation
    showSnackBar("Report removed!", context);
  }

  Future<void> submitReportData() async {
    if (reports.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      var successCount = 0;
      for (int i = 0; i < reports.length; i++) {
        // Upload image to Firebase Storage and get the URL
        String? downloadUrl = await uploadImageToFirebaseStorage(
          reports[i],
          widget.appointment.patientName.toString(),
        );

        if (downloadUrl == null) {
          continue;
        }

        var result = await Reportfirestoreservice().addReport(
          patients_id: widget.appointment.patientName.toString(),
          report_name: reports[i]['name'],
          report_image: downloadUrl,
          // Use the download URL
          report_date: widget.appointment.dateTime,
          report_image_name: '${reports[i]['image_name']}',
        );

        if (result == "success") {
          successCount++;
        }
      }

      setState(() {
        isLoading = false;
      });

      if (successCount == reports.length) {
        showSnackBar("Reports saved successfully!", context);
        Navigator.pop(context);
      } else {
        showSnackBar("Failed to save some reports. Please try again.", context);
      }
    } else {
      showSnackBar("Please select Reports.", context);
    }
  }

  Widget _buildResponsiveContent(double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        buildTextField(
            controller: nameController,
            labelText: 'Name',
            readOnly: true,
            obscureText: false),
        const SizedBox(height: 16),
        buildTextField(
            controller: ageController,
            labelText: 'Age',
            readOnly: true,
            obscureText: false),
        const SizedBox(height: 16),
        buildTextField(
            controller: mobileController,
            labelText: 'Mobile',
            readOnly: true,
            obscureText: false),
        const SizedBox(height: 16),
        buildTextField(
            controller: addressController,
            labelText: 'Address',
            readOnly: true,
            obscureText: false),
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                obscureText: false,
              ),
            ),
            const SizedBox(width: 16),
            if (imageFile == null)
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.photo_library, size: isDesktop ? 16 : 12),
                  label: Text('Gallery',
                      style: TextStyle(fontSize: isDesktop ? 16 : 12)),
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        isDesktop ? const Size(120, 50) : const Size(60, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 4,
                  ),
                ),
              )
            else
              Expanded(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                            ? (base64String != null
                                ? Image.memory(
                                    base64Decode(base64String!),
                                    width: isDesktop ? 120 : 80,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image,
                                    size: 50, color: Colors.grey))
                            : (imageFile != null
                                ? Image.file(
                                    File(imageFile!.path),
                                    width: isDesktop ? 120 : 80,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image,
                                    size: 50, color: Colors.grey)),
                      ),
                    ),
                    SizedBox(width: isDesktop ? 8 : 2),
                    Expanded(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                imageFile = null; // Clear the picked image
                              });
                            },
                            icon: const Icon(Icons.cancel_outlined))),
                  ],
                ),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.save, size: isDesktop ? 16 : 12),
                label: Text('SAVE',
                    style: TextStyle(fontSize: isDesktop ? 16 : 12)),
                onPressed: saveReport,
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      isDesktop ? const Size(120, 50) : const Size(60, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (reports.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Selected reports:"),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  trailing: IconButton(
                      onPressed: () => removeAddedReportFromList(index),
                      icon: const Icon(Icons.close)),
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.memory(
                              base64Decode(report["base64"]),
                              width: 120,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(report["image"]),
                              width: 120,
                              height: 50,
                              fit: BoxFit.cover,
                            )),
                  title: Text(report['name']),
                  subtitle: Text(report['length']),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        isLoading
            ? const AppLoadingIndicator()
            : Center(
                child: GradientButton(
                  padding: const EdgeInsets.all(12.0),
                  text: 'Submit Reports',
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
        title: Text('Add reports for patient',
            style: TextStyle(fontSize: isDesktop ? 20 : 16)),
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
