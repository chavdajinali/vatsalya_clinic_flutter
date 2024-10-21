import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/Registration/sign_up_bloc.dart';
import 'package:vatsalya_clinic/screens/sign_up_screen.dart';
import 'package:vatsalya_clinic/utils/GradientText.dart';
import 'package:vatsalya_clinic/utils/textfield_builder.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';
import 'package:vatsalya_clinic/utils/validation_util.dart';
import '../sign_in/sign_in_bloc.dart';
import '../sign_in/sign_in_event.dart';
import '../sign_in/sign_in_state.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ValidationUtils validationUtils = ValidationUtils();

  final GlobalKey<FormState> _signInFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal  :width*0.25),
      child: Scaffold(
        // Solid background color
        body: Container(
          color: Colors.white, // Set a solid color for the background
          child: BlocProvider(
            create: (context) => SignInBloc(),
            child: BlocListener<SignInBloc, SignInState>(
              listener: (context, state) {
                if (state is SignInSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign In Successful')),
                  );
                  // Navigate to the next screen or home screen
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
                child: SingleChildScrollView(
                  child: Form(
                    key: _signInFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Sign In title
                        Center(child: GradientText('Sign In')),
                        SizedBox(height: 20),
                        // Display image between Sign In title and TextField
                        Center(
                          child: Image.asset(
                            'assets/images/clinic_image.png',
                            // Add your image path here
                            height:
                                220, // Adjust the image height as per your needs
                          ),
                        ),
                        SizedBox(height: 20),
                        // Email TextField
                        _buildEmailField(context),
                        SizedBox(height: 20),
                        // Password TextField
                        _buildPasswordField(context),
                        SizedBox(height: 20),
                    
                        // Sign In button
                        BlocBuilder<SignInBloc, SignInState>(
                          builder: (context, state) {
                            if (state is SignInLoading) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return GradientButton(
                              text: 'Sign In',
                              onPressed: () {
                                if (_signInFormKey.currentState!.validate()) {
                                  // Dispatch the SignInRequested event when the button is pressed
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
                    
                        SizedBox(height: 10),
                    
                        // Forgot Password Button
                        TextButton(
                          onPressed: () {
                            // Handle "Forgot Password" logic here
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.blue, // Change text color if desired
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                    
                        const SizedBox(height: 10),
                    
                        // Create New Account Button
                        GradientButton(
                          text: 'Create New Account',
                          onPressed: () {
                            // Navigate to "Create New Account" screen with BlocProvider for RegistrationBloc
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (newContext) => BlocProvider(
                                  create: (context) => SignUpBloc(),
                                  child: SignUpScreen(),
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
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return buildTextField(
      controller: _emailController,
      labelText: 'Email',
      obscureText: false,
      onValidate: validationUtils.validateEmail
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return buildTextField(
      controller: _passwordController,
      labelText: 'Password',
      obscureText: true,
      onValidate:(password) => validationUtils.validatePassword(password)
    );
  }
}
