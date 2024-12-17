import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/screens/create_patients/create_patients_state.dart';

import 'history_patients_event.dart';
import 'history_patients_state.dart';

class HistoryPatientsBloc
    extends Bloc<HistoryPatientsEvent, HistoryPatientsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HistoryPatientsBloc() : super(HistoryPatientsInitial()) {
    // Register the event handler for SignInRequested
    on<HistoryPatientsRequested>(_onHistoryPatientsRequested);
    on<GetPatientList>(_getPatientList);
  }

  // This method handles the SignInRequested event
  Future _getPatientList(GetPatientList event,
      Emitter<HistoryPatientsState> emit) async {
    emit(HistoryPatientsLoading());


  }
  // This method handles the SignInRequested event
  Future<String?> _onHistoryPatientsRequested(HistoryPatientsRequested event,
      Emitter<HistoryPatientsState> emit) async {
    print("HistoryPatientsRequested triggered");

    // Validate patient details
    String? validationError = _validatePatientDetails(
        event.name, event.age, event.gender, event.mobile, event.address);
    if (validationError != null) {
      emit(HistoryPatientsValidationError(error: validationError));
      return 'validation error.';
    }

    emit(HistoryPatientsLoading());

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('patients_tbl')
          .where('mobile', isEqualTo: event.mobile)
          .limit(1) // Limit to 1 result for efficiency
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        emit(HistoryPatientsFailure(
            error: 'Patients is Already registered with this mobile number.'));
        return 'Patients is Already registered.';
      } else {
        try {
          /* var result = await AddPatientsFirestoreService().addPatient(
              name: event.name,
              age: event.age,
              gender: event.gender,
              mobile: event.mobile,
              createdDate: event.createdDate,
              address: event.address);

          if (result != 'success') {
            emit(HistoryPatientsFailure(error: result ?? ""));
            return result;
          } else {
            emit(HistoryPatientsSuccess());
            return result;
          }*/
        } catch (e) {
          emit(HistoryPatientsFailure(error: 'Error: ${e.toString()}'));
          return 'Error: ${e.toString()}';
        }
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  String? _validatePatientDetails(
      String name, String age, String gender, String mobile, String address) {
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
