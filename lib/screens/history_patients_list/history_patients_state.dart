import 'package:equatable/equatable.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import '../../models/patients_model.dart';

abstract class HistoryPatientsState extends Equatable {
  const HistoryPatientsState();

  @override
  List<Object?> get props => [];
}

class HistoryPatientsInitial extends HistoryPatientsState {
  const HistoryPatientsInitial();
}

class HistoryPatientsLoading extends HistoryPatientsState {
  const HistoryPatientsLoading();
}

class HistoryPatientsSuccess extends HistoryPatientsState {
  final List<PatientsModel> patientList;
  final List<AppointmentModel> patientHistory;
  final bool isPatientHistoryLoading;
  final String errorMessage;
  final AppointmentModel selectedAppointment;
  final bool isFilterPatientListState;
  final double totalPaymentAmount;

  const HistoryPatientsSuccess({
    required this.patientList,
    required this.patientHistory,
    required this.errorMessage,
    required this.selectedAppointment,
    required this.isPatientHistoryLoading,
    required this.isFilterPatientListState,
    required this.totalPaymentAmount
  });

  HistoryPatientsSuccess copyWith({
    List<PatientsModel>? patientList,
    List<AppointmentModel>? patientHistory,
    String? errorMessage,
    AppointmentModel? selectedAppointment,
    bool? isPatientHistoryLoading,
    bool? isFilterPatientListState,
    double? totalPaymentAmount
  }) {
    return HistoryPatientsSuccess(
      patientList: patientList ?? this.patientList,
      patientHistory: patientHistory ?? this.patientHistory,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedAppointment: selectedAppointment ?? this.selectedAppointment,
      isPatientHistoryLoading:
      isPatientHistoryLoading ?? this.isPatientHistoryLoading,
      isFilterPatientListState:
      isFilterPatientListState ?? this.isFilterPatientListState,
      totalPaymentAmount: totalPaymentAmount ?? this.totalPaymentAmount
    );
  }

  @override
  List<Object?> get props => [
    patientList,
    patientHistory,
    isPatientHistoryLoading,
    errorMessage,
    selectedAppointment,
    isFilterPatientListState,
    totalPaymentAmount
  ];
}

class HistoryPatientsFailure extends HistoryPatientsState {
  final String error;

  const HistoryPatientsFailure({required this.error});

  @override
  List<Object?> get props => [error];

  HistoryPatientsState copyWith({required String erorr}) {
    return HistoryPatientsFailure(error: erorr.toString());
  }
}

class HistoryPatientsValidationError extends HistoryPatientsState {
  final String error;

  const HistoryPatientsValidationError({required this.error});

  @override
  List<Object?> get props => [error];
}
