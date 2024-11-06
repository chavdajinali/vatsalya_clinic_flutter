import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vatsalya_clinic/models/refrence_by_model.dart';
import 'package:vatsalya_clinic/models/user_model.dart';

Future<void> storeLoginDetails(UserModel userDetails) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_details', jsonEncode(userDetails.toJson()));
}

Future<UserModel> getLoginDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return UserModel.fromJson(
      jsonDecode(prefs.getString('user_details') ?? "{}"));
}


// Function to fetch Reference By data from SharedPreferences
Future<RefrenceByModel?> getRefrenceByList() async {
  try {
    // Fetch the documents from the reference_tbl collection
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('reference_tbl').get();

    if (snapshot.docs.isEmpty) {
      print("No data found in reference_tbl collection.");
      return null;
    }

    // Extract the names
    List<String> names = snapshot.docs.map((doc) {
      if (kDebugMode) {
        print("Fetched name: ${doc['name']}");
      }
      return doc['name'] as String;
    }).toList();

    return RefrenceByModel(options: names);
  } catch (e) {
    if (kDebugMode) {
      print("Error fetching reference by list: $e");
    }
    return null;
  }
}

Future<List<String>> getNamesFromFirestore() async {
  List<String> names = [];

  // Get a reference to the Firestore collection
  final CollectionReference referenceTbl = FirebaseFirestore.instance.collection('refernce_tbl');

  // Query the collection for all documents
  QuerySnapshot querySnapshot = await referenceTbl.get();

  // Iterate through the documents and extract the 'name' field
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    names.add(doc.get('name') as String); // Assuming 'name' is the field for names
  }

  return names;
}

// // Example usage:
// void main() async {
//   List<String> nameList = await getNamesFromFirestore();
//   print(nameList); // Output: The list of names from the Firestore collection
// }