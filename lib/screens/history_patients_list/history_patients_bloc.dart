import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      emit(HistoryPatientsSuccess(patientList: patientsModelList));
    } catch (e) {
      emit(HistoryPatientsFailure(error: e.toString()));
    }
  }

  Future<void> _manageExpandCollapse(
      ExpandCollapsePatientItem event, Emitter<HistoryPatientsState> emit) async {
    if (state is HistoryPatientsSuccess) {
      // Clone the patient list to ensure immutability
      var patientList = List<PatientsModel>.from(
          (state as HistoryPatientsSuccess).patientList);

      for (int i = 0; i < patientList.length; i++) {
        patientList[i] = patientList[i].copyWith(
          isExpanded: i == event.index, // Update only the selected item
        );
      }

      // Emit a new instance of the state with the updated list
      emit(HistoryPatientsSuccess(patientList: patientList));
    }
  }

// Future _manageExpandCollapse(ExpandCollapsePatientItem event,
  //     Emitter<HistoryPatientsState> emit) async {
  //   // emit(HistoryPatientsLoading());
  //
  //   if (state is HistoryPatientsSuccess) {
  //     var patientList = (state as HistoryPatientsSuccess).patientList;
  //     for (int i = 0; i < patientList.length; i++) {
  //       patientList[i].isExpanded = i == event.index;
  //     }
  //     emit(HistoryPatientsSuccess(patientList: patientList));
  //   }
  // }
}
