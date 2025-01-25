import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/models/user_model.dart';
import 'package:vatsalya_clinic/screens/home/home_screen.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_bloc.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_screen.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

double deviceWidth = 0.0;
double screenWidth = 0.0;
bool isMobile = false;
bool isTablet = false;
bool isDesktop = false;
String platform = "";


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    UserModel userModel = await getLoginDetails();
    if (Firebase.apps.isEmpty) {
      if (kIsWeb) {
        await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
        );
      } else {
        await Firebase.initializeApp();
      }
    }
    runApp(MyApp(loginDetails: userModel));
  });
}

class MyApp extends StatefulWidget {
  final UserModel loginDetails;

  // Ensure that the constructor accepts the 'key' parameter as well
  const MyApp({super.key, required this.loginDetails});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void didChangeDependencies() {
    // MediaQuery is now available here
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    deviceWidth = MediaQuery.of(context).size.shortestSide;
    isTablet = screenWidth >= 600 && screenWidth < 1200;
    isMobile = screenWidth < 600;
    isDesktop = screenWidth >= 1200;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(),
      lazy: false,
      child: MaterialApp(
        title: "Vatsalya clinic",debugShowCheckedModeBanner: false,
        home: (widget.loginDetails.email.isEmpty)
            ? const HomeScreen()
            : const SignInScreen(),
      ),
    );
  }
}

