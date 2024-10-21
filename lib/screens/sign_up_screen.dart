import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/utils/GradientText.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/textfield_builder.dart';
import 'package:vatsalya_clinic/utils/validation_util.dart';
import '../registration/sign_up_bloc.dart';
import '../registration/sign_up_event.dart';
import '../registration/sign_up_state.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  // Define the controllers for password and confirm password
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _registrationFormKey = GlobalKey();
  ValidationUtils validationUtils = ValidationUtils();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: Padding(
        padding:EdgeInsets.symmetric(horizontal  :width*0.15),
        child: Scaffold(
          appBar: AppBar(title: const GradientText('registration')),
          body: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _registrationFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildEmailField(context),
                    SizedBox(height: 16),
                    _buildPasswordField(context),
                    SizedBox(height: 16),
                    _buildConfirmPasswordField(context),
                    SizedBox(height: 30),
                    _buildSubmitButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return state.isSubmitting
            ? const CircularProgressIndicator()
            : GradientButton(
                text: 'Register',
                onPressed: () {
                  if (_registrationFormKey.currentState != null &&
                      _registrationFormKey.currentState!.validate()) {
                    BlocProvider.of<SignUpBloc>(context)
                        .add(RegisterSubmitted());
                  }
                },
              );
      },
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return buildTextField(
        controller: _emailController,
        labelText: 'Email',
        obscureText: false,
        onValidate: validationUtils.validateEmail);
  }

  Widget _buildPasswordField(BuildContext context) {
    return buildTextField(
        controller: _passwordController,
        labelText: 'Password',
        obscureText: true,
        onValidate: validationUtils.validatePassword);
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return buildTextField(
      controller: _confirmPasswordController,
      labelText: 'Confirm Password',
      obscureText: true,
      onValidate:(cPassword)=> validationUtils.validateConfirmPassword(_passwordController.text, cPassword)
    );
  }
}
