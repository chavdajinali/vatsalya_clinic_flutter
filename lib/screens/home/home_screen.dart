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
import 'package:vatsalya_clinic/screens/reference/reference_add_list.dart';
import '../history_patients_list/history_patients_bloc.dart';
import 'appointment/todays_appointment_page.dart';
import 'package:vatsalya_clinic/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected index
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final pages = [
    const TodaysAppointmentPage(),
    const ProfilePage(),
    BlocProvider(
      create: (BuildContext context) => CreatePatientsBloc(),
      child: const CreatePatientsScreen(),
    ),
    BlocProvider(
      create: (BuildContext context) => HistoryPatientsBloc(),
      child: const HistoryPatientsListScreen(),
    ),
    const ReferenceAddList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context); // Close the drawer if it's open
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context,sizingInformation) {
        double fontSize = sizingInformation.deviceScreenType == DeviceScreenType.Desktop ? 18 : 16; // Adjust font size based on device
        double navItemFontSize = sizingInformation.deviceScreenType == DeviceScreenType.Desktop ? 16 : 14; // Navigation item font size

        return Scaffold(
          key: _scaffoldKey,
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
                title: Text(
                  'Vatsalya Speech & Hearing Clinic Dashboard',
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
                backgroundColor: Colors.transparent,
                centerTitle: false,
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: !isDesktop
                    ? IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                )
                    : null,
              ),
            ),
          ),
          drawer: (isTablet || isMobile ? _buildDrawer() : null),
          backgroundColor: Colors.white,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop) _buildLeftNavigationBar(navItemFontSize),
              Expanded(child: pages[_selectedIndex]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeftNavigationBar(double navItemFontSize) {
    return Container(
      width: 230,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView( // Make the entire column scrollable
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: isDesktop ? 20 : 14),
            _buildNavItem(Icons.home, "Home", 0, navItemFontSize),
            SizedBox(height: isDesktop ? 20 : 14),
            _buildNavItem(Icons.person_2_rounded, 'Profile', 1, navItemFontSize),
            SizedBox(height: isDesktop ? 20 : 14),
            _buildNavItem(Icons.person_add, "Create Patient", 2, navItemFontSize),
            SizedBox(height: isDesktop ? 20 : 14),
            _buildNavItem(Icons.history, "History of Patients", 3, navItemFontSize),
            SizedBox(height: isDesktop ? 20 : 14),
            _buildNavItem(Icons.person, 'Reference', 4, navItemFontSize),
            SizedBox(height: isDesktop ? 20 : 14),
            _buildNavItem(Icons.exit_to_app, "Sign Out", 5, navItemFontSize, isSignOut: true),
            SizedBox(height: isDesktop ? 20 : 14),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Version 1.0.0 | 2024\nDeveloped by: Jinali Chavda\n(chavdajinali@gmail.com)",
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: _buildLeftNavigationBar(14), // Default font size for drawer items
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index, double fontSize, {bool isSignOut = false}) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
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
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<SignInBloc>(context).add(SignOutRequested());
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (ctx) => const SignInScreen()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text("Yes"),
                  ),
                ],
              );
            },
          );
        } else {
          _onItemTapped(index);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.grey.shade300,
          ),
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
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: fontSize, // Responsive font size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}