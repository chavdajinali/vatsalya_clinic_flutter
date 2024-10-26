import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreatePatientsScreen extends StatefulWidget {
  const CreatePatientsScreen({super.key});

  @override
  State<CreatePatientsScreen> createState() => _CreatePatientsScreenState();
}

class _CreatePatientsScreenState extends State<CreatePatientsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? gender;
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    // Set default date as today
    dateController.text = dateFormatter.format(DateTime.now());
  }

  // Custom TextField builder to reuse styled TextFields
  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    bool readOnly = false,
    bool obscureText = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.grey[200], // Gray background color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            buildTextField(
              controller: nameController,
              labelText: 'Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            buildTextField(
              controller: ageController,
              labelText: 'Age',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButtonFormField<String>(
                value: gender,
                items: ['Male', 'Female', 'Other']
                    .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Gender',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                validator: (value) =>
                value == null ? 'Please select a gender' : null,
              ),
            ),
            buildTextField(
              controller: mobileController,
              labelText: 'Mobile Number',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number';
                }
                if (value.length != 10) {
                  return 'Please enter a 10-digit number';
                }
                return null;
              },
            ),
            buildTextField(
              controller: addressController,
              labelText: 'Address',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            buildTextField(
              controller: dateController,
              labelText: 'Created Date',
              readOnly: true,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select a date'
                  : null,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateController.text = dateFormatter.format(pickedDate);
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Form submitted successfully')),
                  );
                  // Handle form submission, such as saving data
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
