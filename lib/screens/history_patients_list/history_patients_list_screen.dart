import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vatsalya_clinic/components/AppLabelValue.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/appointment_info.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/history_patients_bloc.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/history_patients_event.dart';
import 'package:vatsalya_clinic/screens/history_patients_list/history_patients_state.dart';
import 'package:vatsalya_clinic/utils/textfield_builder.dart';

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

  @override
  void initState() {
    super.initState();
    // Set default date as today
    startDateController.text = dateFormatter.format(DateTime.now());
    endDateController.text = dateFormatter.format(DateTime.now());
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
                      :
                      // return widget here based on BlocA's state
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Start Date Picker
                                  Flexible(
                                    child: buildTextField(
                                      controller: startDateController,
                                      labelText: 'Start Date',
                                      readOnly: true,
                                      obscureText: false,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now().subtract(
                                              const Duration(
                                                  days: 365)), // 1 year back
                                          lastDate: DateTime.now(),
                                        );
                                        if (pickedDate != null) {
                                          setState(() {
                                            startDateController.text =
                                                dateFormatter
                                                    .format(pickedDate);

                                            // Reset the end date if it's before the newly selected start date
                                            if (DateTime.parse(
                                                    endDateController.text)
                                                .isBefore(pickedDate)) {
                                              endDateController.text =
                                                  dateFormatter
                                                      .format(pickedDate);
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // End Date Picker
                                  Flexible(
                                    child: buildTextField(
                                      controller: endDateController,
                                      labelText: 'End Date',
                                      readOnly: true,
                                      obscureText: false,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.parse(
                                              startDateController.text),
                                          // Start date
                                          lastDate: DateTime.now(),
                                        );
                                        if (pickedDate != null) {
                                          setState(() {
                                            endDateController.text =
                                                dateFormatter
                                                    .format(pickedDate);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // Filter Button
                                  InkWell(
                                    onTap: () {
                                      // Ensure Start Date <= End Date
                                      if (DateTime.parse(
                                              startDateController.text)
                                          .isAfter(DateTime.parse(
                                              endDateController.text))) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Start Date cannot be after End Date"),
                                          ),
                                        );
                                        return;
                                      }
                                      // Trigger the filter event
                                      BlocProvider.of<HistoryPatientsBloc>(context).add(
                                        FilterPatientsByDate(
                                          startDate: startDateController.text,
                                          endDate: endDateController.text,
                                        ),
                                      );
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Colors.blue, Colors.green],
                                            // Apply gradient colors here
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                        )),
                                  ),
                                ],
                              ),
                            ),
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
