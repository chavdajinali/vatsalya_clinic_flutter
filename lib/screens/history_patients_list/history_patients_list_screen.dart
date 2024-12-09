import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vatsalya_clinic/models/patients_model.dart';
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
    return Scaffold(
      body: FutureBuilder(
          future: getNamesOfPatientsFromFirestore(),
          builder: (ctx, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : snapshot.hasError
                    ? Center(child: Text(snapshot.error.toString()))
                    : ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          var patient = snapshot.data![index];
                          return Card(
                            margin: const EdgeInsets.only(
                                top: 16, left: 16, right: 16),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {},
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
                        });
          }),
    );
  }
}
