import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/utils/ResponsiveBuilder.dart';

import '../authentication_bloc/authentication_bloc.dart';
import '../authentication_bloc/authentication_event.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

  final Map<String, String?> loginDetails;

  HomeScreen({required this.loginDetails});
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(context),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Clinic Dashboard',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false, // Blue background for AppBar
    );
  }

  Widget _buildBody(BuildContext context) {
    return Row(
      children: [
        _buildLeftNavigationBar(),
        Expanded(
          flex: 3, // For today's appointments
          child: _buildAppointmentsList(context),
        ),
      ],
    );
  }

  Widget _buildLeftNavigationBar() {
    return Container(
      width: 210,
      // Set the width of the sidebar
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16),
      // Green background for navigation items
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildNavItem(Icons.home, "Home", 0),
          const SizedBox(height: 20),
          _buildNavItem(Icons.person_add, "Create Patient", 1),
          const SizedBox(height: 20),
          _buildNavItem(Icons.history, "History of Patients", 2),
          const SizedBox(height: 20),
          _buildNavItem(Icons.exit_to_app, "Sign Out", 3, isSignOut: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index,
      {bool isSignOut = false}) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        if (isSignOut) {
          BlocProvider.of<AuthenticationBloc>(context).add(SignOutEvent());
        } else {
          _onItemTapped(index);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            border: Border.all(
                color: isSelected ? Colors.white : Colors.grey.shade500),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.grey),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginDetails() {
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
            _buildUserDetailRow('Name', 'Dr. John Doe'),
            _buildUserDetailRow('Email', 'johndoe@clinic.com'),
            _buildUserDetailRow('Role', 'Admin'),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLoginDetails(),

        // const SizedBox(height: 20),
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today\'s Appointments',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Logic to book a new appointment
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Button color
                        ),
                        child: const Text(
                          'Book New Appointment',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('appointments')
                          .where('date',
                              isEqualTo: DateTime.now().toString().substring(
                                  0, 10)) // Filter today's appointments
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // Extract documents from snapshot
                        var appointments = snapshot.data!.docs;

                        // If no appointments, use dummy data
                        List<Map<String, dynamic>> displayedAppointments;
                        if (appointments.isEmpty) {
                          displayedAppointments = [
                            {'patientName': 'Alice Smith', 'time': '10:00 AM'},
                            {'patientName': 'Bob Johnson', 'time': '11:00 AM'},
                            {
                              'patientName': 'Charlie Brown',
                              'time': '12:00 PM'
                            },
                          ];
                        } else {
                          // Extract data from documents
                          displayedAppointments = appointments.map((doc) {
                            var data = doc.data() as Map<String, dynamic>;
                            return {
                              'patientName': data['patientName'] ?? 'Unknown',
                              'time': data['time'] ?? 'Unknown',
                            };
                          }).toList();
                        }

                        return ListView.separated(
                          itemCount: displayedAppointments.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 1, color: Colors.grey.shade200),
                          itemBuilder: (context, index) {
                            var appointment = displayedAppointments[index];
                            return ListTile(
                              title: Text(
                                  'Patient: ${appointment['patientName']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text('Time: ${appointment['time']}',
                                  style:
                                      const TextStyle(color: Colors.black54)),
                              tileColor: Colors.grey[100],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
