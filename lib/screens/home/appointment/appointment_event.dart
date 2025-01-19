// appointment_event.dart
import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAppointments extends AppointmentEvent {}
