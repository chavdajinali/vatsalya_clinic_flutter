// sign_in_state.dart

import 'package:equatable/equatable.dart';

abstract class CreatePatientsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreatePatientsInInitial extends CreatePatientsState {}

class CreatePatientsLoading extends CreatePatientsState {}

class CreatePatientsSuccess extends CreatePatientsState {
}

class CreatePatientsFailure extends CreatePatientsState {
  final String error;

  CreatePatientsFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class CreatePatientsValidationError extends CreatePatientsState {
  final String error;

  CreatePatientsValidationError({required this.error});

  @override
  List<Object?> get props => [error];
}
