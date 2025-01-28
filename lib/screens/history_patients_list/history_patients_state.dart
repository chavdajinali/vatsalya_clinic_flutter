// sign_in_state.dart

import 'package:equatable/equatable.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';

import '../../models/patients_model.dart';

abstract class HistoryPatientsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HistoryPatientsInitial extends HistoryPatientsState {}

class HistoryPatientsLoading extends HistoryPatientsState {}

class HistoryPatientsSuccess extends HistoryPatientsState {
  final List<PatientsModel> patientList;
  final List<AppointmentModel> patientHistory;
  final bool isPatientHistoryLoading;
  final String errorMessage;
  final AppointmentModel selectedAppointment;

  HistoryPatientsSuccess(
      {required this.patientList,
      required this.patientHistory,
      required this.errorMessage,
      required this.selectedAppointment,
      required this.isPatientHistoryLoading});

  HistoryPatientsSuccess copyWith(
          {List<PatientsModel>? patientList,
          List<AppointmentModel>? patientHistory,
          String? errorMessage,
          AppointmentModel? selectedAppointment,
          bool? isPatientHistoryLoading}) =>
      HistoryPatientsSuccess(
          patientList: patientList ?? this.patientList,
          errorMessage: errorMessage ?? this.errorMessage,
          selectedAppointment: selectedAppointment ?? this.selectedAppointment,
          isPatientHistoryLoading:
              isPatientHistoryLoading ?? this.isPatientHistoryLoading,
          patientHistory: patientHistory ?? this.patientHistory);

  @override
  List<Object?> get props => [
        patientList,
        patientHistory,
        isPatientHistoryLoading,
        errorMessage,
        selectedAppointment
      ];
}

class HistoryFilteredSuccess extends HistoryPatientsState {
  final List<PatientsModel> filteredPatientList;

  HistoryFilteredSuccess({required this.filteredPatientList});

  HistoryFilteredSuccess copyWith({List<PatientsModel>? filteredPatientList}) => HistoryFilteredSuccess(filteredPatientList: filteredPatientList ?? this.filteredPatientList);

  @override
  List<Object?> get props => [filteredPatientList];
}

class HistoryFilteredpatientsFailure extends HistoryPatientsState {
  final String error;

  HistoryFilteredpatientsFailure({required this.error});

  @override
  List<Object?> get props => [error];
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
