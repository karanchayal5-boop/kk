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



Future<void> saveLoginSession(String email) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool("isLoggedIn", true);
  await prefs.setString("currentUser", email);

  print("Login session saved for: $email");
}

  


  
  Future<void> saveUser(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();

  // Load old users
  String? data = prefs.getString("all_users");
  List<UserModel> users = [];

  if (data != null) {
    List list = jsonDecode(data);
    users = list.map((e) => UserModel.fromJson(e)).toList();
  }

  
  int index = users.indexWhere((u) => u.email == email);

  if (index != -1) {
    users[index].password = password; 
  } else {
    users.add(UserModel(email: email, password: password)); 
  }

  
  await prefs.setString("all_users", jsonEncode(users.map((e) => e.toJson()).toList()));

  allUsers.value = users;

  print(" Total Users: ${users.length}");
}


  
  Future<bool> loginFromList(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
  String? data = prefs.getString("all_users");

  if (data == null) return false;

  List list = jsonDecode(data);
  List<UserModel> users = list.map((e) => UserModel.fromJson(e)).toList();

  return users.any((u) => u.email == email && u.password == password);
}

  
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("isLoggedIn");
  await prefs.remove("currentUser");

  Get.offAll(() => MyAppleMap()); 
}

  
  void sendOtp() {
    int otp = 1000 + Random().nextInt(9000); 
    generatedOtp.value = otp.toString();
    print(" Karan your OTP is : ${generatedOtp.value}");
  }

  bool verifyOtp(String inputOtp) {
    return inputOtp == generatedOtp.value;
  }

  void saveUserData(String text, String mobileNumber) {}
}