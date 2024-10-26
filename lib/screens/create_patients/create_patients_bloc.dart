import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/screens/create_patients/create_patients_state.dart';
import 'add_patients_firestore_service.dart';
import 'create_patients_event.dart';

class CreatePatientsBloc
    extends Bloc<CreatePatientsEvent, CreatePatientsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CreatePatientsBloc() : super(CreatePatientsInInitial()) {
    // Register the event handler for SignInRequested
    on<CreatePatientsRequested>(_onCreatePatientsRequested);
  }

  // This method handles the SignInRequested event
  Future<void> _onCreatePatientsRequested(CreatePatientsRequested event,
      Emitter<CreatePatientsState> emit) async {
    // Validate email and password
    String? validationError = _validatePatientDetails(
        event.name, event.age, event.gender, event.mobile, event.address);
    if (validationError != null) {
      emit(CreatePatientsValidationError(error: validationError));
      return;
    }

    emit(CreatePatientsLoading());

    try {
      var result = await AddPatientsFirestoreService().addPatient(
          name: event.name,
          age: event.age,
          gender: event.gender,
          mobile: event.mobile,
          createdDate: event.createdDate,
          address: event.address); // Fetch the user from Firestore

      // Check if the result is null, which indicates success
      if (result != null) {
        emit(CreatePatientsFailure(
            error: result)); // Emit failure with the error message
      } else {
        emit(CreatePatientsSuccess()); // Emit success if the result is null
      }
    }catch (e) {
      emit(CreatePatientsFailure(error: 'Error: ${e.toString()}'));
    }
  }

  String? _validatePatientDetails(String name, String age, String gender,
      String mobile, String address) {
    // Name validation: Must not be empty and only contain letters and spaces
    final nameRegex = RegExp(r"^[a-zA-Z\s]+$");
    if (name.isEmpty || !nameRegex.hasMatch(name)) {
      return 'Name must contain only letters and spaces.';
    }

    // Age validation: Must be a positive integer and at least 1
    final ageRegex = RegExp(r"^[1-9][0-9]*$");
    if (!ageRegex.hasMatch(age) || int.parse(age) < 1) {
      return 'Age must be a positive integer.';
    }

    // Gender validation: Must be one of the accepted values ("Male", "Female", "Other")
    final validGenders = ["Male", "Female", "Other"];
    if (!validGenders.contains(gender)) {
      return 'Gender must be "Male", "Female", or "Other".';
    }

    // Mobile number validation: Must be 10 digits (adjust as per country requirements)
    final mobileRegex = RegExp(r"^\d{10}$");
    if (!mobileRegex.hasMatch(mobile)) {
      return 'Mobile number must contain exactly 10 digits.';
    }

    // Address validation: Cannot be empty and should contain at least 5 characters
    if (address.isEmpty || address.length < 5) {
      return 'Address must contain at least 5 characters.';
    }

    // If all validations pass
    return null;
  }

}
