import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:vatsalya_clinic/screens/payment/payment_firestore_service.dart';
import 'package:vatsalya_clinic/utils/CustomPicker.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/textfield_builder.dart';

class PaymentDialog extends StatefulWidget {
  final patientsId;
  final appoinmentDate;
  const PaymentDialog({super.key, this.patientsId, this.appoinmentDate});

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

  Future<void> _AddPaymentData() async {

    // Check if all required fields are selected
    if (widget.patientsId.toString() != null &&
        widget.appoinmentDate.toString() != null &&
        selectedPaymentType != null) {
      String? result = await PaymentFirestoreService().addPaymentData(
        patients_id: widget.patientsId.toString(),
        payment_amount: _amountController.text,
        payment_type: selectedPaymentType.toString(),
        appoinmentDate: widget.appoinmentDate.toString(),
      );

      // Show SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ?? "Something went wrong!"),
          duration: Duration(seconds: 2),
        ),
      );

      // Clear fields if the booking was successful
      if (result == "Payment added successfully!") {
        setState(() {
          // _togglePaymentDialog();
          Navigator.of(context).pop(); // Close the dialog
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
                          _AddPaymentData();
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
