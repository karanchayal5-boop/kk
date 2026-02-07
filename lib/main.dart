import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kk/controller/otp_controller.dart';
import 'package:kk/controller/auth_controller.dart';
import 'package:kk/firebase_options.dart';
import 'package:kk/home/payment_method_page.dart';
import 'package:kk/login/OTP_verification_screen.dart';
import 'package:kk/login/create_password_screen.dart';
import 'package:kk/login/forget_password_screen.dart';
import 'package:kk/login/login_screen.dart';
import 'package:kk/map_screen.dart';
import 'package:kk/login/register_screen.dart';
import 'dart:async';
import 'package:kk/login/screen1.dart';
import 'package:firebase_auth/firebase_auth.dart';


  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
   
   
    Get.put(OtpController());
    Get.put(AuthController(), permanent: true);


  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  
  
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/screen1', page: () => Screen1()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/otp', page: () => OtpVerificationScreen()),
        GetPage(name: '/createpassword', page: () => CreatePasswordScreen()),
        GetPage(name: '/forget', page: () => ForgotPasswordScreen()),
        GetPage(name: '/map', page: () => MyAppleMap()),
        GetPage(name: '/payment', page: () => PaymentMethodPage()),
         ],
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
  await Future.delayed(const Duration(seconds: 3));

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // already logged in
    Get.offAllNamed('/map');
  } else {
    // not logged in
    Get.offAllNamed('/screen1');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash_logo@3x.png',
          width: 300,
        ),
      ),
    );
  }
}
