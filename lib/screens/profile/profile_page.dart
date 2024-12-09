import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_bloc.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_screen.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            // const Text(
            //   'User Profile',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            const SizedBox(height: 20),
            // FutureBuilder to fetch user details
            FutureBuilder(
              future: getLoginDetails(),
              builder: (context, result) {
                if (!result.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final userDetails = result.data!;
                return Column(
                  // mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // User Role Image
                    _buildUserRoleImage(userDetails.role),
                    const SizedBox(height: 20),
                    // User Details
                    _buildUserDetailRow('Name: ', userDetails.name),
                    _buildUserDetailRow('Email: ', userDetails.email),
                    _buildUserDetailRow('Role: ', userDetails.role),
                    const SizedBox(height: 30),
                    // Sign Out Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        MaterialPageRoute(
                          builder: (newContext) => BlocProvider(
                            create: (context) => SignInBloc(),
                            child: const SignInScreen(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child:  Text(
                          'Sign Out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget for displaying role-based images
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
        assetPath = 'assets/images/logo.jpeg'; // Default app logo for normal users
    }

    return Container(decoration:const BoxDecoration(shape: BoxShape.circle,color: Colors.blue),child: Image.asset(height: 200,assetPath,fit: BoxFit.fill));
  }

  // Widget for displaying user details in a row
  Widget _buildUserDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
