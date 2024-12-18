// sign_in_event.dart

import 'package:equatable/equatable.dart';

abstract class HistoryPatientsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPatientList extends HistoryPatientsEvent {}

class ExpandCollapsePatientItem extends HistoryPatientsEvent {
  late final int index;

  ExpandCollapsePatientItem(this.index);
}
