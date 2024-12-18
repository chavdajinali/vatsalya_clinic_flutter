// appointment_state.dart
import 'package:equatable/equatable.dart';

abstract class AppointmentState extends Equatable {
  @override
  List<Object> get props => [];
}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List appointments;

  AppointmentLoaded({required this.appointments});

  @override
  List<Object> get props => [appointments];
}

class AppointmentError extends AppointmentState {}
