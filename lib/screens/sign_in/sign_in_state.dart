// sign_in_state.dart

import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final String userId;

  SignInSuccess({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class SignInFailure extends SignInState {
  final String error;

  SignInFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class SignInValidationError extends SignInState {
  final String error;

  SignInValidationError({required this.error});

  @override
  List<Object?> get props => [error];
}
