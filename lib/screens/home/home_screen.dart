import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/screens/create_patients/create_patients_bloc.dart';
import 'package:vatsalya_clinic/screens/create_patients/create_patients_screen.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/history_patients_list_screen.dart';
import 'package:vatsalya_clinic/screens/home/todays_appointment_page.dart';
import 'package:vatsalya_clinic/screens/home/work_in_progress_page.dart';
import 'package:vatsalya_clinic/screens/profile/profile_page.dart';
import 'package:vatsalya_clinic/utils/ResponsiveBuilder.dart';

import '../authentication_bloc/authentication_bloc.dart';
import '../authentication_bloc/authentication_event.dart';

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
    const HistoryPatientsListScreen()
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
                // Make AppBar transparent
                elevation: 0,
                // Remove shadow
                automaticallyImplyLeading: false, // Allows the back button
              ),
            ),
          ),
          body: Row(
            // AppBar(
            //   title: const Text(
            //     'Vatsalya Speech & Hearing Clinic Dashboard',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   backgroundColor: Colors.blue,
            //   automaticallyImplyLeading: true, // Blue background for AppBar
            // ),

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
      width: 210,
      // Set the width of the sidebar
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // Green background for navigation items
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
          _buildNavItem(Icons.exit_to_app, "Sign Out", 4, isSignOut: true),
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
              color: isSelected ? Colors.white : Colors.grey.shade500,
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
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
