// sign_in_event.dart

import 'package:equatable/equatable.dart';

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
