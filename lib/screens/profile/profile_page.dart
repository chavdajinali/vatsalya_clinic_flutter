import 'package:flutter/material.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      surfaceTintColor: Colors.white,
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Details',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
                future: getLoginDetails(),
                builder: (context, result) {
                  return result.hasData == false
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            _buildUserDetailRow('Name: ', result.data!.name),
                            _buildUserDetailRow('Email: ', result.data!.email),
                            _buildUserDetailRow('Role: ', result.data!.role),
                          ],
                        );
                })
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
