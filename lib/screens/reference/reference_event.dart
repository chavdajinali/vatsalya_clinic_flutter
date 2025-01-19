// sign_in_event.dart

import 'package:equatable/equatable.dart';

abstract class ReferenceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetReferenceList extends ReferenceEvent {}

class AddReference extends ReferenceEvent {
  final String referenceName;

  AddReference(this.referenceName);
}

