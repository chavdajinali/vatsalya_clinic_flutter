// sign_in_state.dart

import 'package:equatable/equatable.dart';

import '../../models/patients_model.dart';

abstract class HistoryPatientsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HistoryPatientsInitial extends HistoryPatientsState {}

class HistoryPatientsLoading extends HistoryPatientsState {}

class HistoryPatientsSuccess extends HistoryPatientsState {
  final List<PatientsModel> patientList;

  HistoryPatientsSuccess({required this.patientList});
}

class HistoryPatientsFailure extends HistoryPatientsState {
  final String error;

  HistoryPatientsFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class HistoryPatientsValidationError extends HistoryPatientsState {
  final String error;

  HistoryPatientsValidationError({required this.error});

  @override
  List<Object?> get props => [error];
}
