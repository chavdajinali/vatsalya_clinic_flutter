import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/models/report_model.dart';
import 'package:vatsalya_clinic/screens/create_patients/create_patients_state.dart';

import '../../models/patients_model.dart';
import 'history_patients_event.dart';
import 'history_patients_state.dart';

class HistoryPatientsBloc
    extends Bloc<HistoryPatientsEvent, HistoryPatientsState> {
  HistoryPatientsBloc() : super(HistoryPatientsInitial()) {
    // Register the event handler for SignInRequested
    on<GetPatientList>(_getPatientList);
    on<ExpandCollapsePatientItem>(_manageExpandCollapse);
    on<GetPatientHistory>(_getPatientHistory);
    on<SelectAppointment>(_selectAppointment);
  }

  Future _selectAppointment(
      SelectAppointment event, Emitter<HistoryPatientsState> emit) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('report_tbl')
        .where('patientID', isEqualTo: event.selectedAppointment.patientName)
        .where('reportDate', isEqualTo: event.selectedAppointment.appointmentDate)
        .get();
    List<ReportModel> reports = [];
    for (QueryDocumentSnapshot doc in result.docs) {
      reports.add(ReportModel.fromJson(doc.data()
          as Map<String, dynamic>)); // Assuming 'name' is the field for names
    }

    // if (state is HistoryPatientsSuccess) {
    emit((state as HistoryPatientsSuccess).copyWith(
        selectedAppointment:
            event.selectedAppointment.copyWith(reports: reports)));
    // }
  }

// This method handles the SignInRequested event
  Future _getPatientList(
      GetPatientList event, Emitter<HistoryPatientsState> emit) async {
    emit(HistoryPatientsLoading());

    List<PatientsModel> patientsModelList = [];

    try {
      // Query the collection for all documents
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('patients_tbl').get();
      // Iterate through the documents and extract the 'name' field
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        var patient =
            PatientsModel.fromJson(doc.data() as Map<String, dynamic>);
        patient.id = doc.id;
        patientsModelList
            .add(patient); // Assuming 'name' is the field for names
      }
      emit(HistoryPatientsSuccess(
          patientList: patientsModelList,
          patientHistory: [],
          isPatientHistoryLoading: false,
          errorMessage: "",
          selectedAppointment: AppointmentModel.fromJson({})));
    } catch (e) {
      emit(HistoryPatientsFailure(error: e.toString()));
    }
  }

  Future<void> _manageExpandCollapse(ExpandCollapsePatientItem event,
      Emitter<HistoryPatientsState> emit) async {
    if (state is HistoryPatientsSuccess) {
      // Clone the patient list to ensure immutability
      var patientList = List<PatientsModel>.from(
          (state as HistoryPatientsSuccess).patientList);

      for (int i = 0; i < patientList.length; i++) {
        if (i == event.index) {
          patientList[i] = patientList[i].copyWith(
            isExpanded:
                !patientList[i].isExpanded, // Update only the selected item
          );
          if (patientList[i].isExpanded) {
            add(GetPatientHistory(patientList[i].id));
          }
        } else {
          patientList[i] = patientList[i].copyWith(
            isExpanded: false, // Update only the selected item
          );
        }
      }

      // Emit a new instance of the state with the updated list
      emit(
          (state as HistoryPatientsSuccess).copyWith(patientList: patientList));
    }
  }

  Future<void> _getPatientHistory(
      GetPatientHistory event, Emitter<HistoryPatientsState> emit) async {
    emit((state as HistoryPatientsSuccess)
        .copyWith(isPatientHistoryLoading: true));

    // Fetch the user from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('appointment_tbl')
        .where('patients_name', isEqualTo: event.patientId)
        .get();

    if (snapshot.docs.isEmpty) {
      emit((state as HistoryPatientsSuccess).copyWith(
          isPatientHistoryLoading: false,
          errorMessage: "No history found.",
          selectedAppointment: AppointmentModel.fromJson({}),
          patientHistory: []));
    } else {
      List<AppointmentModel> appointments = [];
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        appointments.add(AppointmentModel.fromJson(doc.data()
            as Map<String, dynamic>)); // Assuming 'name' is the field for names
      }
      emit((state as HistoryPatientsSuccess).copyWith(
          isPatientHistoryLoading: false,
          errorMessage: "",
          selectedAppointment: AppointmentModel.fromJson({}),
          patientHistory: appointments));
    }
  }
}
