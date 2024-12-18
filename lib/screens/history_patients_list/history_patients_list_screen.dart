import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/models/patients_model.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/history_patients_bloc.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/history_patients_event.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/history_patients_state.dart';
import 'package:vatsalya_clinic/utils/storeLoginDetails.dart';

class HistoryPatientsListScreen extends StatefulWidget {
  const HistoryPatientsListScreen({super.key});

  @override
  State<HistoryPatientsListScreen> createState() =>
      _HistoryPatientsListScreenState();
}

class _HistoryPatientsListScreenState extends State<HistoryPatientsListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var block = HistoryPatientsBloc();
        block.add(GetPatientList());
        return block;
      },
      child: BlocConsumer<HistoryPatientsBloc, HistoryPatientsState>(
          listener: (context, state) {
        // do stuff here based on BlocA's state
      }, builder: (context, state) {
        return state is HistoryPatientsFailure
            ? Center(child: Text(state.error))
            : state is HistoryPatientsSuccess
                ? state.patientList.isEmpty
                    ? const Center(child: Text("No data found."))
                    :
                    // return widget here based on BlocA's state
                    ListView.builder(
                        itemCount: state.patientList.length,
                        itemBuilder: (context, index) {
                          var patient = state.patientList[index];
                          return Card(
                            margin: const EdgeInsets.only(
                                top: 16, left: 16, right: 16),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    BlocProvider.of<HistoryPatientsBloc>(
                                            context)
                                        .add(ExpandCollapsePatientItem(index));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                patient.name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  "Age: ${patient.age}(${patient.gender})"),
                                              Text("Mobile: ${patient.mobile}"),
                                            ],
                                          ),
                                        ),
                                        Icon(patient.isExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down)
                                      ],
                                    ),
                                  ),
                                ),
                                patient.isExpanded
                                    ? const Text("History....")
                                    : Container()
                              ],
                            ),
                          );
                        })
                : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
