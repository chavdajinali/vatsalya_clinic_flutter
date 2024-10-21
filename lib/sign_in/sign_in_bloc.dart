import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SignInBloc() : super(SignInInitial()) {
    // Register the event handler for SignInRequested
    on<SignInRequested>(_onSignInRequested);
  }

  // This method handles the SignInRequested event
  Future<void> _onSignInRequested(SignInRequested event, Emitter<SignInState> emit) async {
    // Validate email and password
    String? validationError = _validateCredentials(event.email, event.password);
    if (validationError != null) {
      emit(SignInValidationError(error: validationError));
      return;
    }

    emit(SignInLoading());

    try {
      // Fetch the user from Firestore
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: event.email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        emit(SignInFailure(error: 'User not found'));
        return;
      }

      // Assuming the user document has a 'password' field
      var userData = snapshot.docs.first.data() as Map<String, dynamic>;
      String storedPassword = userData['password'];

      if (event.password == storedPassword) {
        emit(SignInSuccess(userId: snapshot.docs.first.id));
      } else {
        emit(SignInFailure(error: 'Incorrect password'));
      }
    } catch (e) {
      emit(SignInFailure(error: 'Error: ${e.toString()}'));
    }
  }

  // Validate email and password
  String? _validateCredentials(String email, String password) {
    // Email validation
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email format';
    }

    // Password validation: at least 8 characters, 1 punctuation, 1 capital letter, 1 number
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#\$&*~])(?=.*[0-9]).{8,}$');
    if (!passwordRegex.hasMatch(password)) {
      return 'Password must be at least 8 characters long, include 1 capital letter, 1 number, and 1 punctuation mark.';
    }

    return null;
  }
}
