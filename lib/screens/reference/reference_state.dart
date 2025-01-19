// sign_in_state.dart

import 'package:equatable/equatable.dart';
import 'package:vatsalya_clinic/models/appointment_model.dart';
import 'package:vatsalya_clinic/models/refrence_model.dart';

import '../../models/patients_model.dart';

abstract class ReferenceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReferenceInitial extends ReferenceState {}

class ReferenceLoading extends ReferenceState {}

class ReferenceAddedSuccessfully extends ReferenceState {}

class ReferenceSuccess extends ReferenceState {
  final List<RefrenceModel> referenceList;

  ReferenceSuccess(
      {required this.referenceList});

  ReferenceSuccess copyWith(
      {List<RefrenceModel>? referenceList}) =>
  ReferenceSuccess(
  referenceList: referenceList ?? this.referenceList);

  @override
  List<Object?> get props => [
  referenceList
  ];
}

class ReferenceAddFailure extends ReferenceState {
  final String error;

  ReferenceAddFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ReferenceFailure extends ReferenceState {
  final String error;

  ReferenceFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ReferenceValidationError extends ReferenceState {
  final String error;

  ReferenceValidationError({required this.error});

  @override
  List<Object?> get props => [error];
}
