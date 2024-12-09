import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:vatsalya_clinic/utils/CustomPicker.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/textfield_builder.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String? selectedPaymentType = 'Online'; // Default value
  List<String> paymentType = ['Online', 'Offline'];
  TextEditingController _amountController = TextEditingController();
  bool _isPaymentDialogVisible =
      false; // Boolean to track if the dialog should be visible
  final _formKey = GlobalKey<FormState>(); // GlobalKey for form validation

  // Function to toggle the visibility of the container
  void _togglePaymentDialog() {
    setState(() {
      _isPaymentDialogVisible = !_isPaymentDialogVisible; // Toggle visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
              ),
            ],
          ),
          child: Form(
            // Wrap the content in a Form widget
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Payment Type Dropdown
                DropdownSearch<String>(
                  decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                    labelText: 'Select Payment Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                  )),
                  items: (f, cs) => paymentType,
                  selectedItem: selectedPaymentType,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentType = value;
                    });
                  },
                  // decoration:InputDecoration(
                  //   labelText: 'Select Payment Type',
                  //   border: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   fillColor: Colors.grey[200],
                  //   filled: true,
                  // ) ,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a payment type';
                    }
                    return null;
                  },
                  popupProps: const PopupProps.menu(
                    fit: FlexFit.loose,
                    constraints: BoxConstraints(),
                  ),
                ),
                const SizedBox(height: 16),

                // Amount TextField with same style as dropdown
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          12), // Match the dropdown border radius
                    ),
                    fillColor: Colors.grey[200],
                    // Same background color as dropdown
                    filled: true, // Ensure it's filled with the color
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Save Button
                Center(
                  child: GradientButton(
                    text: 'Save',
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        String amount = _amountController.text;
                        if (amount.isNotEmpty) {
                          // Handle save action
                          print('Payment Type: $selectedPaymentType');
                          print('Amount: $amount');
                          // Optionally, hide the form after saving
                          _togglePaymentDialog();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a valid amount')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
