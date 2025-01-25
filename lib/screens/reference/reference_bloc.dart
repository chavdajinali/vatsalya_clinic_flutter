import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vatsalya_clinic/models/refrence_model.dart';
import 'package:vatsalya_clinic/screens/reference/reference_event.dart';
import 'package:vatsalya_clinic/screens/reference/reference_state.dart';

class ReferenceBloc extends Bloc<ReferenceEvent, ReferenceState> {
  ReferenceBloc() : super(ReferenceInitial()) {
    // Register the event handler for SignInRequested
    on<GetReferenceList>(_getReferenceList);
    on<AddReference>(_addReferenceData);
  }

  Future _getReferenceList(
      GetReferenceList event, Emitter<ReferenceState> emit) async {
    emit(ReferenceLoading());

    List<RefrenceModel> referencelList = [];

    try {
      // Query the collection for all documents
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('refernce_tbl').get();
      // Iterate through the documents and extract the 'name' field
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        var reference =
            RefrenceModel.fromJson(doc.data() as Map<String, dynamic>);
        reference.id = doc.id;
        referencelList.add(reference); // Assuming 'name' is the field for names
      }
      emit(ReferenceSuccess(referenceList: referencelList));
    } catch (e) {
      emit(ReferenceFailure(error: e.toString()));
    }
  }

  Future _addReferenceData(
      AddReference event, Emitter<ReferenceState> emit) async {
    try {
      await FirebaseFirestore.instance
          .collection('refernce_tbl')
          .add({'name': event.referenceName});
      emit(ReferenceAddedSuccessfully());
      add(GetReferenceList());
    } catch (e) {
      emit(ReferenceAddFailure(error: e.toString()));
    }
  }
}
