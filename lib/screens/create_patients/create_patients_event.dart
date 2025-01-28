// sign_in_event.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class CreatePatientsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreatePatientsRequested extends CreatePatientsEvent {
  final String name;
  final String age;
  final String gender;
  final String mobile;
  final String address;
  final Timestamp createdDate;

  CreatePatientsRequested({required this.name, required this.age, required this.gender, required this.mobile, required this.address,required this.createdDate});

  @override
  List<Object> get props => [name, age, gender, mobile, address];
}
