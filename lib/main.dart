import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kk/screen/login_screen.dart';
import 'package:kk/screen/register_screen.dart';
import 'dart:async';

import 'package:kk/screen/screen1.dart';

void main() {
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
  Null get sizedbox => null;

  @override
  void initState() {
    super.initState();
    
    Future.delayed(Duration(seconds: 3), () {
      if (Get.currentRoute == '/splash') {
         Get.offNamed('/screen1');
      }
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center
      
      (child: Image.asset('assets/images/splash_logo@3x.png',
      width: 300,)),
      
    );
  }
}



