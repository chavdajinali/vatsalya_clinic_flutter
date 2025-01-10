import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/screens/create_patients/create_patients_bloc.dart';
import 'package:vatsalya_clinic/screens/create_patients/create_patients_screen.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/history_patients_list_screen.dart';
import 'package:vatsalya_clinic/screens/profile/profile_page.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_bloc.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_event.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_screen.dart';
import 'package:vatsalya_clinic/utils/ResponsiveBuilder.dart';

import '../history_patients_list/history_patients_bloc.dart';
import 'appointment/todays_appointment_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();

  const HomeScreen({
    super.key,
  });
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected index
  var pages = [
    const TodaysAppointmentPage(),
    const ProfilePage(),
    BlocProvider(
        create: (BuildContext context) => CreatePatientsBloc(),
        child: const CreatePatientsScreen()),
    BlocProvider(
        create: (BuildContext context) => HistoryPatientsBloc(),
        child: const HistoryPatientsListScreen()),
  ];

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
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(45.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.green], // Gradient colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: AppBar(
                title: const Text(
                  'Vatsalya Speech & Hearing Clinic Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                centerTitle: false,
                elevation: 0,
                automaticallyImplyLeading: false, // Allows the back button
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Row(
            children: [
              _buildLeftNavigationBar(),
              Expanded(child: pages[_selectedIndex]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeftNavigationBar() {
    return Container(
      width: 230,
      // Set the width of the sidebar
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // Green background for navigation items
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildNavItem(Icons.home, "Home", 0),
                const SizedBox(height: 20),
                _buildNavItem(Icons.person_2_rounded, 'Profile', 1),
                const SizedBox(height: 20),
                _buildNavItem(Icons.person_add, "Create Patient", 2),
                const SizedBox(height: 20),
                _buildNavItem(Icons.history, "History of Patients", 3),
                const SizedBox(height: 20),
                _buildNavItem(Icons.exit_to_app, "Sign Out", 4,
                    isSignOut: true),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Version 1.0.0 | 2024 \nDeveloped by: Jinali Chavda",
              style: TextStyle(fontSize: 10),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index,
      {bool isSignOut = false}) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
        hoverColor: Colors.blue,
        onTap: () {
          if (isSignOut) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const Text("Are you sure you want to sign out?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("No")),
                      TextButton(
                          onPressed: () {
                            BlocProvider.of<SignInBloc>(context)
                                .add(SignOutRequested());

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => const SignInScreen()),
                                (Route<dynamic> route) => false);
                          },
                          child: const Text("Yes"))
                    ],
                  );
                });
          } else {
            _onItemTapped(index);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Colors.blue, Colors.green], // Gradient colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            // No gradient if not selected
            color: isSelected ? null : Colors.white,
            // Set color to white if not selected
            border: Border.all(
              color: isSelected ? Colors.white : Colors.grey.shade300,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
