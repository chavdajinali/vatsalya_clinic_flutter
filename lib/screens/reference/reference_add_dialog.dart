import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/screens/reference/reference_bloc.dart';
import 'package:vatsalya_clinic/screens/reference/reference_event.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';

class ReferenceAddDialog extends StatefulWidget {
  const ReferenceAddDialog({super.key});

  @override
  State<ReferenceAddDialog> createState() => _ReferenceAddDialogState();
}

class _ReferenceAddDialogState extends State<ReferenceAddDialog> {
  final TextEditingController _referencenameController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _addReferenceData() async {
    if (_referencenameController.text.trim().isNotEmpty) {
      Navigator.pop(context, _referencenameController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Enter Reference Name."),
        duration: Duration(seconds: 2),
      ));
      }
  }

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _referencenameController,
                    decoration: InputDecoration(
                        labelText: 'Enter Reference Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        fillColor: Colors.grey[200],
                        filled: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter reference name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                      child: GradientButton(
                          text: 'Save',
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              String referenceName =
                                  _referencenameController.text;
                              if (referenceName.isNotEmpty) {
                                _addReferenceData();
                              }
                            }
                          }))
                ],
              ),
            )),
      ),
    );
  }
}
