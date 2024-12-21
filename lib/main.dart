import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/models/user_model.dart';
import 'package:vatsalya_clinic/screens/home/home_screen.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_bloc.dart';
import 'package:vatsalya_clinic/screens/sign_in/sign_in_screen.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserModel userModel = await getLoginDetails();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(loginDetails: userModel));
}

class MyApp extends StatelessWidget {
  final UserModel loginDetails;

  // Ensure that the constructor accepts the 'key' parameter as well
  const MyApp({super.key, required this.loginDetails});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(),
      lazy: false,
      child: MaterialApp(
        home: (loginDetails.email.isNotEmpty)
            ? const HomeScreen()
            : const SignInScreen(),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: BlocProvider(create: (context) => SignInBloc(),child: SignInScreen(),)//const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
