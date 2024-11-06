import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/screens/book_appoinment/book_appoinment_screen.dart';
import 'package:vatsalya_clinic/utils/gradient_button.dart';

class TodaysAppointmentPage extends StatefulWidget {
  const TodaysAppointmentPage({super.key});

  @override
  State<TodaysAppointmentPage> createState() => _TodaysAppointmentPageState();
}

class _TodaysAppointmentPageState extends State<TodaysAppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 20),
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Today\'s Appointments',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      GradientButton(
                          text: 'Book New Appointment', onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BookAppoinmentScreen()));
                        // BlocProvider(
                        //     create: (BuildContext context) => CreatePatientsBloc(),
                        //     child: const CreatePatientsScreen()),
                      }),
                    ],
                  ),
                ),
                const Divider(height: 1,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('appointments')
                          .where('date',
                          isEqualTo: DateTime.now().toString().substring(
                              0, 10)) // Filter today's appointments
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        // Extract documents from snapshot
                        var appointments = snapshot.data!.docs;

                        // If no appointments, use dummy data
                        List<Map<String, dynamic>> displayedAppointments;
                        if (appointments.isEmpty) {
                          displayedAppointments = [
                            {'patientName': 'Alice Smith', 'date' : '23/10/2024','time': '10:00 AM'},
                            {'patientName': 'Bob Johnson','date' : '23/10/2024' ,'time': '11:00 AM'},
                            {'patientName': 'Charlie Brown','date' : '23/10/2024','time': '12:00 PM'},
                          ];
                        } else {
                          // Extract data from documents
                          displayedAppointments = appointments.map((doc) {
                            var data = doc.data() as Map<String, dynamic>;
                            return {
                              'patientName': data['patientName'] ?? 'Unknown',
                              'time': data['time'] ?? 'Unknown',
                            };
                          }).toList();
                        }

                        return ListView.separated(
                          itemCount: displayedAppointments.length,
                          separatorBuilder: (context, index) =>
                          const Divider(height: 1, color: Colors.transparent),
                          itemBuilder: (context, index) {
                            var appointment = displayedAppointments[index];
                            return Card(
                              color: Colors.grey[100],
                              child: Padding(padding: const EdgeInsets.all(12.0),
                                child:  Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Name: ',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                appointment['patientName'],
                                                style: const TextStyle(fontWeight: FontWeight.normal),
                                                overflow: TextOverflow.ellipsis, // Handles long names
                                              ),
                                            ],
                                          )
                                          ,
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text('Date: ${appointment['date']} ${appointment['time']}',
                                                style: const TextStyle(color: Colors.black54),
                                              ),

                                            ],
                                          ),

                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 16), // Space between info and button
                                    // Button Section
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            // Handle button press
                                          },
                                          // style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                            child: Text('Add Details',style: TextStyle(color: Colors.blue)),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Handle button press
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                            child: Text('Payment' ,style: TextStyle(color: Colors.blue)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
