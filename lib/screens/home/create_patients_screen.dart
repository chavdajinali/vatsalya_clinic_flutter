import 'package:flutter/material.dart';

class CreatePatientsScreen extends StatefulWidget {
  const CreatePatientsScreen({super.key});

  @override
  State<CreatePatientsScreen> createState() => _CreatePatientsScreenState();
}

class _CreatePatientsScreenState extends State<CreatePatientsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: const Text('Add Patients')),
      body: Container(),
    );
  }
}
