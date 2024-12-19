import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_bloc.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_screen.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              // Top card view
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FutureBuilder(
                    future: getLoginDetails(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final userDetails = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildUserRoleImage(userDetails.role),
                          const SizedBox(height: 20),
                          _buildUserDetailRow('Name: ', userDetails.name),
                          _buildUserDetailRow('Email: ', userDetails.email),
                          _buildUserDetailRow('Role: ', userDetails.role),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding:
                              const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (newContext) => BlocProvider(
                                    create: (context) => SignInBloc(),
                                    child: const SignInScreen(),
                                  ),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Sign Out',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const Spacer(),
              // Optional additional content or spacing
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserRoleImage(String role) {
    String assetPath;
    switch (role.toLowerCase()) {
      case 'superadmin':
        assetPath = 'assets/images/superadmin_logo.png';
        break;
      case 'admin':
        assetPath = 'assets/images/admin_logo.jpg';
        break;
      default:
        assetPath = 'assets/images/logo.jpeg';
    }

    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: Image.asset(
          assetPath,
          height: 450,
          width: 450,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildUserDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
