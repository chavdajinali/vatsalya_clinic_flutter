// sign_in_event.dart

import 'package:equatable/equatable.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';

abstract class HistoryPatientsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPatientList extends HistoryPatientsEvent {}

class ExpandCollapsePatientItem extends HistoryPatientsEvent {
  final int index;

  ExpandCollapsePatientItem(this.index);
}

class GetPatientHistory extends HistoryPatientsEvent {
  final String patientId;

  GetPatientHistory(this.patientId);
}

class SelectAppointment extends HistoryPatientsEvent {
  final AppointmentModel selectedAppointment;

  SelectAppointment(this.selectedAppointment);
}


class FilterPatientsByDate extends HistoryPatientsEvent {
  final String startDate;
  final String endDate;

  FilterPatientsByDate({required this.startDate, required this.endDate});
}