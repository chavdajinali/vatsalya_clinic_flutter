import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vatsalya_clinic/components/AppLabelValue.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/appointment_info.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/history_patients_bloc.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/history_patients_event.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/history_patients_state.dart';

class HistoryPatientsListScreen extends StatefulWidget {
  const HistoryPatientsListScreen({super.key});

  @override
  State<HistoryPatientsListScreen> createState() =>
      _HistoryPatientsListScreenState();
}

class _HistoryPatientsListScreenState extends State<HistoryPatientsListScreen> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  DateTimeRange? selectedateRange;

  @override
  void initState() {
    super.initState();
    // Set default date as today
    final today = DateTime.now();
    selectedateRange = DateTimeRange(start: today, end: today);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: BlocProvider(
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
              : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Date Range Picker Button
                    ElevatedButton(
                      onPressed: () async {
                        DateTimeRange? pickedRange =
                        await showDateRangePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(
                              const Duration(days: 365)), // 1 year back
                          lastDate: DateTime.now(),
                          initialDateRange: selectedateRange,
                        );

                        if (pickedRange != null) {
                          setState(() {
                            selectedateRange = pickedRange;
                          });
                        }
                      },
                      child: Text(
                        selectedateRange == null
                            ? 'Select Date Range'
                            : "${dateFormatter.format(selectedateRange!.start)} - ${dateFormatter.format(selectedateRange!.end)}",
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Filter Button
                    InkWell(
                      onTap: () {
                        if (selectedateRange == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Please select a valid date range."),
                            ),
                          );
                          return;
                        }

                        // Trigger the filter event
                        BlocProvider.of<HistoryPatientsBloc>(
                            context)
                            .add(
                          FilterPatientsByDate(
                            startDate: dateFormatter
                                .format(selectedateRange!.start),
                            endDate: dateFormatter
                                .format(selectedateRange!.end),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.green],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(children: [
                            Icon(
                              Icons.filter_alt,
                              color: Colors.white,
                            ),
                            Text("Filter",
                                style: TextStyle(
                                    color: Colors.white))
                          ]),
                        ),
                      ),
                    ),

                    const SizedBox(width: 5),

                    // Reset Button
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedateRange = DateTimeRange(
                              start: DateTime.now(),
                              end: DateTime.now());
                        });
                        BlocProvider.of<HistoryPatientsBloc>(
                            context)
                            .add(GetPatientList());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            Text("Reset",
                                style: TextStyle(
                                    color: Colors.white))
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              state is HistoryPatientsSuccess && state.patientList.isEmpty ?
              const Center(
                child: Text('No data found.',style:TextStyle(fontSize: 16,color: Colors.black54)),
              ) :
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.patientList.length,
                  itemBuilder: (context, index) {
                    var patient = state.patientList[index];
                    return Card(
                      margin: const EdgeInsets.only(
                          top: 16, left: 16, right: 16),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              BlocProvider.of<
                                  HistoryPatientsBloc>(
                                  context)
                                  .add(ExpandCollapsePatientItem(
                                  index));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          patient.name,
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight
                                                  .bold),
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
                                            value:
                                            patient.mobile),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    patient.isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons
                                        .keyboard_arrow_down,
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
                                padding:
                                EdgeInsets.all(
                                    16.0),
                                child:
                                CircularProgressIndicator(),
                              )
                                  : state.patientHistory
                                  .isEmpty
                                  ? Padding(
                                padding:
                                const EdgeInsets
                                    .all(
                                    16.0),
                                child: Text(state
                                    .errorMessage),
                              )
                                  : Wrap(
                                children: getDates(
                                    state
                                        .patientHistory,
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
                                  appointmentData: state
                                      .selectedAppointment)
                                  : Container()
                            ],
                          )
                              : Container(),
                        ],
                      ),
                    );
                  }),
            ],
          )
              : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  List<Widget> getDates(
      List<AppointmentModel> appointments,
      AppointmentModel selectedAppointment,
      Function(AppointmentModel) callback) {
    List<Widget> dates = [];

    for (var appointment in appointments) {
      // Format the DateTime to a readable string
      String formattedDate = DateFormat('yyyy-MM-dd').format(appointment.appointmentDate);

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
          child: Text(formattedDate),
        ),
      ));
    }
    return dates;
  }
}
