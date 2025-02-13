import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vatsalya_clinic/components/AppLabelValue.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/models/user_model.dart';
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

  final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
  DateTimeRange? selectedDateRange;
  late UserModel? userData;

  @override
  void initState() {
    super.initState();
    // Set default date as current month.
    _loadUserData();
    final today = DateTime.now();
    final firstDayOfMonth = DateTime(today.year, today.month, 1);
    selectedDateRange = DateTimeRange(
        start: firstDayOfMonth, end: today);
  }

  void _loadUserData()async {
    userData = await getLoginDetails();
    setState(()  {
      userData;
    });  // Update the UI after fetching the user data
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
                      ? const Center(child: Text("No patients found."))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
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
                                                const Duration(
                                                    days: 365)), // 1 year back
                                            lastDate: DateTime.now(),
                                            initialDateRange: selectedDateRange,
                                          );

                                          if (pickedRange != null) {
                                            setState(() {
                                              selectedDateRange = pickedRange;
                                            });
                                          }
                                        },
                                        child: Text(
                                          selectedDateRange == null
                                              ? 'Select Date Range'
                                              : "${dateFormatter.format(selectedDateRange!.start)} to ${dateFormatter.format(selectedDateRange!.end)}",
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Filter Button
                                      InkWell(
                                        onTap: () {
                                          // Trigger the filter event
                                          BlocProvider.of<HistoryPatientsBloc>(
                                                  context)
                                              .add(GetPatientHistory(
                                                  // patientId: patientList[i].id,
                                                  startDate:
                                                      selectedDateRange!.start,
                                                  endDate: selectedDateRange!.end));
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0, vertical: 6),
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

                                      const SizedBox(width: 16),

                                      // Reset Button
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedDateRange = DateTimeRange(
                                                start: DateTime.now(),
                                                end: DateTime.now());
                                          });
                                          BlocProvider.of<HistoryPatientsBloc>(
                                                  context)
                                              .add(GetPatientHistory(
                                                  startDate:
                                                      selectedDateRange!.start,
                                                  endDate: selectedDateRange!.end));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0, vertical: 6),
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
                                  if (userData!.role == "Super Admin")
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text("Total Payment Amount : ${state.totalPaymentAmount}"),
                                      )
                                    ],
                                  ) ,
                                ],
                              ),
                            ),
                            state.isFilterPatientListState &&
                                    state.patientList.isEmpty
                                ? Center(
                                    child: Text(state.errorMessage,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54)),
                                  )
                                : Expanded(
                                  child: ListView.builder(
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
                                                      .add(
                                                          ExpandCollapsePatientItem(
                                                              index));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(16.0),
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
                                                                value: patient
                                                                    .mobile),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            if (userData!.role == "Super Admin")
                                                              AppLabelValue(label: "Total Payment", value: "${patient.totalPayment}"),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            AppLabelValue(
                                                                label:
                                                                    "Total Appointments",
                                                                value: patient
                                                                    .appointments
                                                                    .length
                                                                    .toString()),
                                                          ],
                                                        ),
                                                      ),
                                                      Icon(
                                                        patient.isExpanded
                                                            ? Icons
                                                                .keyboard_arrow_up
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Divider(
                                                          height: 1,
                                                        ),
                                                        patient.appointments
                                                                .isEmpty
                                                            ? const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            16.0),
                                                                child: Text(
                                                                    "No history found."),
                                                              )
                                                            : Wrap(
                                                                children: getDates(
                                                                    patient.appointments,
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
                                                        state.selectedAppointment
                                                                .id.isNotEmpty
                                                            ? AppointmentInfo(
                                                                appointmentData: state
                                                                    .selectedAppointment)
                                                            : Container()
                                                      ],
                                                    )
                                                  : Text(state.errorMessage,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black54)),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
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
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(appointment.timestamp.toDate());

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
