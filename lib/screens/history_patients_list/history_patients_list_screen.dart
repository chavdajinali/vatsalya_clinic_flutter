import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/components/AppLabelValue.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/models/patients_model.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/appointment_info.dart';
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
                            color: Colors.white,
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
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              AppLabelValue(
                                                  label: "Age",
                                                  value:
                                                      "${patient.age}(${patient.gender})"),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              AppLabelValue(
                                                  label: "Mobile",
                                                  value: patient.mobile),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          patient.isExpanded
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: Colors.blue,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                patient.isExpanded
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Divider(
                                            height: 1,
                                          ),
                                          state.isPatientHistoryLoading
                                              ? const Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : state.patientHistory.isEmpty
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Text(
                                                          state.errorMessage),
                                                    )
                                                  : Wrap(
                                                      children: getDates(
                                                          state.patientHistory,
                                                          state
                                                              .selectedAppointment,
                                                          (appointment) {
                                                        BlocProvider.of<
                                                                    HistoryPatientsBloc>(
                                                                context)
                                                            .add(SelectAppointment(
                                                                appointment));
                                                      }),
                                                    ),
                                          state.selectedAppointment.id
                                                  .isNotEmpty
                                              ? AppointmentInfo(
                                                  appointmentData:
                                                      state.selectedAppointment)
                                              : Container()
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          );
                        })
                : const Center(child: CircularProgressIndicator());
      }),
    );
  }

  List<Widget> getDates(
      List<AppointmentModel> appointments,
      AppointmentModel selectedAppointment,
      Function(AppointmentModel) callback) {
    List<Widget> dates = [];
    for (var appointment in appointments) {
      dates.add(Padding(
        padding: const EdgeInsets.all(16.0),
        child: OutlinedButton(
          onPressed: () {
            callback(appointment);
          },
          style: appointment.id == selectedAppointment.id
              ? OutlinedButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white)
              : null,
          child: Text(appointment.appointmentDate),
        ),
      ));
    }
    return dates;
  }
}
