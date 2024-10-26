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
      await _mapRegisterSubmittedToState(event, emit);
    });
  }

  Future<void> _mapRegisterSubmittedToState(
      RegisterSubmitted event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(isSubmitting: true));
    try {

        // Fetch the user from Firestore
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: event.email)
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) {
          await FirebaseFirestore.instance.collection('users').add({
            'email': event.email,
            'password': event.password,
            'name' : event.username,
            'role' : event.role,
          });
          emit(state.copyWith(isSuccess: true, isSubmitting: false));
        }else{
          emit(state.copyWith(isFailure: true, isSubmitting: false));
        }

    } catch (error) {
      emit(state.copyWith(isFailure: true, isSubmitting: false));
    }
  }
}
