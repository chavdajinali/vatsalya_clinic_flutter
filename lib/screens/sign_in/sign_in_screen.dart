import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_bloc.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_event.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_state.dart';
import 'package:vatsalya_clinic/utils/GradientText.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';
import 'package:vatsalya_clinic/utils/textfield_builder.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/validation_util.dart';

import '../home/home_screen.dart';
import '../sign_up/sign_up_bloc.dart';
import '../sign_up/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  ValidationUtils validationUtils = ValidationUtils();

  final GlobalKey<FormState> _signInFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.25),
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: BlocProvider(
            create: (context) => SignInBloc(),
            child: BlocListener<SignInBloc, SignInState>(
              listener: (context, state) async {
                if (state is SignInSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sign In Successful')),
                  );
                  // Navigate to the HomeScreen after successful sign-in

                  String email = _emailController.text;
                  String password = _passwordController.text;

                  storeLoginDetails(email, password);
                  Map<String, String?> loginDetails = await getLoginDetails();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                          loginDetails: loginDetails), // Navigate to HomeScreen
                    ),
                  );
                } else if (state is SignInFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.error}')),
                  );
                } else if (state is SignInValidationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Validation Error: ${state.error}')),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _signInFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/logo.jpeg',
                          height: 220,
                        ),
                      ),
                      const Center(child: GradientText('Welcome Back!')),
                      const SizedBox(height: 16),
                      const SizedBox(height: 20),
                      _buildEmailField(context),
                      const SizedBox(height: 20),
                      _buildPasswordField(context),
                      const SizedBox(height: 20),
                      BlocBuilder<SignInBloc, SignInState>(
                        builder: (context, state) {
                          if (state is SignInLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return GradientButton(
                            text: 'Sign In',
                            onPressed: () {
                              if (_signInFormKey.currentState!.validate()) {
                                BlocProvider.of<SignInBloc>(context).add(
                                  SignInRequested(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          // Handle "Forgot Password"
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        child:const Text( 'New User? Create New Account'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (newContext) => BlocProvider(
                                create: (context) => SignUpBloc(),
                                child: const SignUpScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return buildTextField(
      controller: _emailController,
      labelText: 'Email',
      obscureText: false,
      onValidate: validationUtils.validateEmail,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return buildTextField(
      controller: _passwordController,
      labelText: 'Password',
      obscureText: true,
      onValidate: validationUtils.validatePassword,
    );
  }
}
