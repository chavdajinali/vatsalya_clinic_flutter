import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EmailChanged extends RegistrationEvent {
  final String email;

  EmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends RegistrationEvent {
  final String password;

  PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class ConfirmPasswordChanged extends RegistrationEvent {
  final String confirmPassword;

  ConfirmPasswordChanged({required this.confirmPassword});

  @override
  List<Object> get props => [confirmPassword];
}

class RegisterSubmitted extends RegistrationEvent {}
