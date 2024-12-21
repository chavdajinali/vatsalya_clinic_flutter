import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:vatsalya_clinic/screens/payment/payment_firestore_service.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';

class PaymentDialog extends StatefulWidget {
  final String appointmentId;

  const PaymentDialog({super.key, required this.appointmentId});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String? selectedPaymentType = 'Online'; // Default value
  List<String> paymentType = ['Online', 'Offline'];
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // GlobalKey for form validation

  Future<void> _addPaymentData() async {
    // Check if all required fields are selected
    if (_amountController.text.trim().isNotEmpty ||
        selectedPaymentType != null) {
      String? result = await PaymentFirestoreService().addPaymentData(
        paymentAmount: _amountController.text.trim(),
        paymentType: selectedPaymentType.toString(),
        appointmentId: widget.appointmentId,
      );

      // Clear fields if the booking was successful
      if (result == "success") {
        setState(() {
          // _togglePaymentDialog();
          Navigator.of(context).pop(); // Close the dialog
        });
      } else {
        // Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result ?? "Something went wrong!"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Show a warning if not all fields are selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select the payment type."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  labelText: 'Payment Type',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the payment type.';
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
                    return 'Please enter an amount.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid amount.';
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
                        _addPaymentData();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
