import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:math';
import 'package:get/get.dart';
import 'package:kk/map_screen.dart';
import 'package:kk/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {

  var allUsers = <UserModel>[].obs;

  var generatedOtp = "".obs;

  var savedEmail = "".obs;
  var savedPassword = "".obs;

  var tempEmail = "".obs;

  get auth => null;


  // ================= SAVE EMAIL + PASSWORD =================
  Future<void> saveUser(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();

  // Load old users
  String? data = prefs.getString("all_users");
  List<UserModel> users = [];

  if (data != null) {
    List list = jsonDecode(data);
    users = list.map((e) => UserModel.fromJson(e)).toList();
  }

  // Check if user already exists
  int index = users.indexWhere((u) => u.email == email);

  if (index != -1) {
    users[index].password = password; // update
  } else {
    users.add(UserModel(email: email, password: password)); // add new
  }

  // Save again
  await prefs.setString("all_users", jsonEncode(users.map((e) => e.toJson()).toList()));

  allUsers.value = users;

  print(" Total Users: ${users.length}");
}


  // ================= LOGIN CHECK =================
  Future<bool> loginFromList(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
  String? data = prefs.getString("all_users");

  if (data == null) return false;

  List list = jsonDecode(data);
  List<UserModel> users = list.map((e) => UserModel.fromJson(e)).toList();

  return users.any((u) => u.email == email && u.password == password);
}


  // ================= LOGOUT =================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('user_password');

    savedEmail.value = "";
    savedPassword.value = "";

    print(" User logged out, credentials cleared.");
  }

  // ================= OTP =================
  void sendOtp() {
    int otp = 1000 + Random().nextInt(9000); // 4 digit
    generatedOtp.value = otp.toString();
    print(" Karan your OTP IS: ${generatedOtp.value}");
  }

  bool verifyOtp(String inputOtp) {
    return inputOtp == generatedOtp.value;
  }

  void saveUserData(String text, String mobileNumber) {}
}