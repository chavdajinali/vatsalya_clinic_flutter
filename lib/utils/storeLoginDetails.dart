import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
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
