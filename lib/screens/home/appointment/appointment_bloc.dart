// appointment_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(AppointmentLoading()) {
    // Register the event handler to map the event to the state
    on<FetchAppointments>(_onFetchAppointments);
  }

  // Handler for FetchAppointments event
  Future<void> _onFetchAppointments(
      FetchAppointments event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());  // Emit loading state before fetching data

    try {
      // Fetch today's appointments from Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('appointment_tbl')
          .where('appoinment_date', isEqualTo: Timestamp.fromDate(DateTime.now()))
          .get();

      // Convert the fetched appointments into a list
      final appointments = querySnapshot.docs.map((doc) => doc.data()).toList();

      emit(AppointmentLoaded(appointments: appointments));  // Emit loaded state with data
    } catch (error) {
      emit(AppointmentError());  // Emit error state if fetching fails
    }
  }
}
