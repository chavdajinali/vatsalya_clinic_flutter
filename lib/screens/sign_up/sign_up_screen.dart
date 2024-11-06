import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/screens/home/home_screen.dart';
import 'package:vatsalya_clinic/screens/sign_up/sign_up_bloc.dart';
import 'package:vatsalya_clinic/screens/sign_up/sign_up_event.dart';
import 'package:vatsalya_clinic/screens/sign_up/sign_up_state.dart';
import 'package:vatsalya_clinic/utils/CustomPicker.dart';
import 'package:vatsalya_clinic/utils/GradientText.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/textfield_builder.dart';
import 'package:vatsalya_clinic/utils/validation_util.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Define the controllers for password and confirm password
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _registrationFormKey = GlobalKey();

  final List<String> roles = ['superadmin', 'admin', 'receptionist'];
  String? selectedRole;

  ValidationUtils validationUtils = ValidationUtils();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.25),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: BlocListener<SignUpBloc, SignUpState>(
              listener: (context, state) async {
                if (state.isSuccess) {
                  // Navigate to the Sign In screen
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const HomeScreen(), // Navigate to HomeScreen
                      ));
                } else {
                  if (state.isFailure) {
                    // Handle registration failure (show error message, etc.)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Registration failed. Please try again.')),
                    );
                  }
                }
              },
              child: Center(
                child: Form(
                  key: _registrationFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const GradientText('New User'),
                      const SizedBox(height: 30),
                      _buildUserNameField(context),
                      const SizedBox(height: 16),
                      _buildEmailField(context),
                      const SizedBox(height: 16),
                      _buildURoleField(context),
                      const SizedBox(height: 16),
                      _buildPasswordField(context),
                      const SizedBox(height: 16),
                      _buildConfirmPasswordField(context),
                      const SizedBox(height: 30),
                      _buildSubmitButton(context),
                      const SizedBox(height: 16),
                      _buildSignInButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildSubmitButton(BuildContext contextNew) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        if (state.isSubmitting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return GradientButton(
            text: 'Signup',
            padding: EdgeInsets.all(12.0),
            onPressed: () {
              if (_registrationFormKey.currentState != null &&
                  _registrationFormKey.currentState!.validate()) {
                String email = _emailController.text;
                String password = _passwordController.text;
                String username = _userNameController.text;

                BlocProvider.of<SignUpBloc>(context).add(RegisterSubmitted(
                    email: email,
                    password: password,
                    username: username,
                    role: selectedRole.toString()));
              }
            },
          );
        }
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

  Widget _buildUserNameField(BuildContext context) {
    return buildTextField(
        controller: _userNameController,
        labelText: 'User Name',
        obscureText: false,
        onValidate: null);
  }

  Widget _buildURoleField(BuildContext context) {
    return buildTextField(
        controller: TextEditingController(text: selectedRole),
        onTap: () => CustomPicker.show(
              context: context,
              items: roles,
              title: 'Select a Role',
              onSelected: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
            ),
        readOnly: true,
        labelText: 'Select Role',
        decoration: InputDecoration(
          labelText: "Select Role",
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
        onValidate: null);
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
        onValidate: (cPassword) => validationUtils.validateConfirmPassword(
            _passwordController.text, cPassword));
  }
}

Widget _buildSignInButton(BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: const Text('Already have an account? Sign In'),
  );
}
