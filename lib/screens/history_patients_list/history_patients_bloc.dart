import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    on<GetPatientList>(_getPatientList);
    on<ExpandCollapsePatientItem>(_manageExpandCollapse);
    on<GetPatientHistory>(_getPatientHistory);
    on<SelectAppointment>(_selectAppointment);
  }

  Future<void> _selectAppointment(
      SelectAppointment event, Emitter<HistoryPatientsState> emit) async {
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('report_tbl')
          .where('patientID', isEqualTo: event.selectedAppointment.patientId)
          .where('reportDate', isEqualTo: event.selectedAppointment.timestamp)
          .get();

      List<ReportModel> reports = result.docs
          .map(
              (doc) => ReportModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      emit((state as HistoryPatientsSuccess).copyWith(
          selectedAppointment:
              event.selectedAppointment.copyWith(reports: reports)));
    } catch (error) {
      if (kDebugMode) print("Error fetching reports: $error");
    }
  }

  Future<void> _getPatientList(
      GetPatientList event, Emitter<HistoryPatientsState> emit) async {
    emit(const HistoryPatientsLoading());

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('patients_tbl').get();

      List<PatientsModel> patientsModelList = querySnapshot.docs
          .map((doc) =>
              PatientsModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      emit(HistoryPatientsSuccess(
        patientList: patientsModelList,
        patientHistory: const [],
        isPatientHistoryLoading: false,
        errorMessage: "",
        isFilterPatientListState: false,
        selectedAppointment: AppointmentModel.fromJson({}),
      ));

      final today = DateTime.now().copyWith(
          hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

      add(GetPatientHistory(
          startDate: today.subtract(Duration(days: today.day)),
          endDate: today
              .add(const Duration(days: 1))
              .subtract(const Duration(seconds: 1))));
    } catch (e) {
      emit(HistoryPatientsFailure(error: e.toString()));
    }
  }

  Future<void> _manageExpandCollapse(ExpandCollapsePatientItem event,
      Emitter<HistoryPatientsState> emit) async {
    if (state is HistoryPatientsSuccess) {
      var patientList = List<PatientsModel>.from(
          (state as HistoryPatientsSuccess).patientList);

      for (int i = 0; i < patientList.length; i++) {
        if (i == event.index) {
          patientList[i] = patientList[i].copyWith(
            isExpanded: !patientList[i].isExpanded,
          );
        } else {
          patientList[i] = patientList[i].copyWith(isExpanded: false);
        }
      }

      emit(
          (state as HistoryPatientsSuccess).copyWith(patientList: patientList));
    }
  }

  Future<void> _getPatientHistory(
      GetPatientHistory event, Emitter<HistoryPatientsState> emit) async {
    emit((state as HistoryPatientsSuccess)
        .copyWith(isPatientHistoryLoading: true));

    try {
      List<PatientsModel> patients = [];
      for (var patient in (state as HistoryPatientsSuccess).patientList) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('appointment_tbl')
            .where('patient_id', isEqualTo: patient.id)
            .where('timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(event.startDate))
            .where('timestamp',
                isLessThanOrEqualTo: Timestamp.fromDate(event.endDate))
            .get();

        List<AppointmentModel> appointments = snapshot.docs
            .map((doc) => AppointmentModel.fromJson(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        patients.add(patient.copyWith(appointments: appointments));
      }

      emit((state as HistoryPatientsSuccess).copyWith(patientList: patients));
    } catch (e) {
      emit((state as HistoryPatientsFailure).copyWith(erorr: e.toString()));
    }
  }
}
