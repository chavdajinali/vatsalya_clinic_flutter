// authentication_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(UnAuthenticated()) {
    // Register the event handler
    on<SignOutEvent>(_onSignOutEvent);
  }

  // Handle sign-out event and emit states
  Future<void> _onSignOutEvent(
      SignOutEvent event, Emitter<AuthenticationState> emit) async {
    // Emit loading state when signing out
    emit(AuthenticationLoading());

    // Simulate sign-out process (you can replace this with your actual sign-out logic)
    await Future.delayed(Duration(seconds: 2));

    // Emit UnAuthenticated state once sign-out is completed
    emit(UnAuthenticated());
  }
}

