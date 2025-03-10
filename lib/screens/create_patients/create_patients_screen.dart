import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vatsalya_clinic/screens/create_patients/create_patients_bloc.dart';
import 'package:vatsalya_clinic/screens/create_patients/create_patients_event.dart';
import 'package:vatsalya_clinic/screens/create_patients/create_patients_state.dart';
import 'package:vatsalya_clinic/utils/CustomPicker.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/textfield_builder.dart';

class CreatePatientsScreen extends StatefulWidget {
  const CreatePatientsScreen({super.key});

  @override
  State<CreatePatientsScreen> createState() => _CreatePatientsScreenState();
}

class _CreatePatientsScreenState extends State<CreatePatientsScreen> {
  final _createPatientsFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? gender;
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

  final List<String> genderList = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    // Set default date as today
    dateController.text = dateFormatter.format(DateTime.now());
  }

  void resetForm() {
    setState(() {
      nameController.clear();
      ageController.clear();
      gender = null;
      mobileController.clear();
      addressController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _createPatientsFormKey,
        child: ListView(
          children: [
            buildTextField(
              controller: nameController,
              labelText: 'Name',
              onValidate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              obscureText: false,
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: ageController,
              labelText: 'Age',
              onValidate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              obscureText: false,
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: TextEditingController(text: gender),
              labelText: 'Gender',
              onTap: () async {
                final selectedGender = await showModalBottomSheet<String>(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: genderList
                          .map((g) => ListTile(
                        title: Text(g),
                        onTap: () => Navigator.of(context).pop(g),
                      ))
                          .toList(),
                    );
                  },
                );
                if (selectedGender != null) {
                  setState(() {
                    gender = selectedGender;
                  });
                }
              },
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Gender',
                suffixIcon: const Icon(Icons.arrow_drop_down),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              onValidate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a gender';
                }
                return null;
              },
              obscureText: false,
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: mobileController,
              labelText: 'Mobile Number',
              onValidate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number';
                }
                if (value.length != 10) {
                  return 'Please enter a 10-digit number';
                }
                return null;
              },
              obscureText: false,
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: addressController,
              labelText: 'Address',
              onValidate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
              obscureText: false,
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: dateController,
              labelText: 'Created Date',
              readOnly: true,
              onValidate: (value) => value == null || value.isEmpty
                  ? 'Please select a date'
                  : null,
              obscureText: false,
            ),
            const SizedBox(height: 30),
            BlocListener<CreatePatientsBloc, CreatePatientsState>(
              listener: (ctx, state) {
                if (state is CreatePatientsSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Patient added successfully!")),
                  );
                  resetForm();

                  // Optionally clear form fields here
                } else if (state is CreatePatientsFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              child: BlocBuilder<CreatePatientsBloc, CreatePatientsState>(
                builder: (context, state) {
                  return GradientButton(
                    padding: const EdgeInsets.all(12.0),
                    text: 'Add Patient',
                    onPressed: () {
                      if (_createPatientsFormKey.currentState!.validate()) {
                        BlocProvider.of<CreatePatientsBloc>(context).add(
                            CreatePatientsRequested(
                                name: nameController.text,
                                age: ageController.text,
                                gender: gender.toString(),
                                mobile: mobileController.text,
                                address: addressController.text,
                                createdDate: dateController.text));
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
