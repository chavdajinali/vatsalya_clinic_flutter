// sign_in_event.dart

import 'package:equatable/equatable.dart';

abstract class HistoryPatientsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPatientList extends HistoryPatientsEvent {
}

class HistoryPatientsRequested extends HistoryPatientsEvent {
  final String name;
  final String age;
  final String gender;
  final String mobile;
  final String address;
  final String createdDate;

  HistoryPatientsRequested({required this.name, required this.age, required this.gender, required this.mobile, required this.address,required this.createdDate});

  @override
  List<Object> get props => [name, age, gender, mobile, address];
}
