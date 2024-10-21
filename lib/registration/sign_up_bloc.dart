import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState.empty()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<ConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    on<RegisterSubmitted>((event, emit) async {
      await _mapRegisterSubmittedToState(emit);
    });
  }

  Future<void> _mapRegisterSubmittedToState(Emitter<SignUpState> emit) async {
    if (state.isFormValid) {
      emit(state.copyWith(isSubmitting: true));
      try {
        // Simulate storing data in Firestore
        await FirebaseFirestore.instance.collection('users').add({
          'email': state.email,
          'password': state.password, // In a real app, you'd hash the password
        });

        emit(state.copyWith(isSuccess: true, isSubmitting: false));
      } catch (error) {
        emit(state.copyWith(isFailure: true, isSubmitting: false));
      }
    } else {
      emit(state.copyWith(isFailure: true));
    }
  }
}
