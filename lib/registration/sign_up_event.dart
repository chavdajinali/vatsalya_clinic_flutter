import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EmailChanged extends SignUpEvent {
  final String email;

  EmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends SignUpEvent {
  final String password;

  PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class ConfirmPasswordChanged extends SignUpEvent {
  final String confirmPassword;

  ConfirmPasswordChanged({required this.confirmPassword});

  @override
  List<Object> get props => [confirmPassword];
}

class RegisterSubmitted extends SignUpEvent {}
