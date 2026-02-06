import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kk/controller/auth_controller.dart';
import 'package:kk/login/forget_password_screen.dart';
import 'package:kk/map_screen.dart';
import 'package:kk/login/register_screen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find<AuthController>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  
  bool isPasswordWrong = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/login.png',
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 230),
                const Text(
                  'Login to your account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                
                if (isPasswordWrong)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        const Text(
                          "Incorrect Password. ",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => const ForgotPasswordScreen()),
                          child: const Text(
                            "Reset your password.",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                _buildTextField('Email address', emailController),
                const SizedBox(height: 15),
                _buildTextField('Password', passwordController, isPasswordWrong: isPasswordWrong),
                const SizedBox(height: 30),

                
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      Get.snackbar('Error', 'Please fill in all fields.',
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white);
                      return;
                    }

                    bool isCorrect = await authController.loginUser(email, password);

                  if (isCorrect) {

                    
                  
                  Get.offAll(() => MyAppleMap());
                 } else {
                  
                  setState(() {
                  isPasswordWrong = true;
                 });
                }
              },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
                  child: const Text(
                    'Log In',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

                const SizedBox(height: 40),

                Center(
                  child: Column(
                    children: [
                      const Text("Don’t have an account?"),
                      TextButton(
                        onPressed: () => Get.to(() => const RegisterScreen()),
                        child: const Text(
                          'Create new account.',
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text("By logging in you are agree to Terms & conditions", 
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    {bool isPasswordWrong = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: hint == 'Password',
        onChanged: (value) {
          if (isPasswordWrong) {
            setState(() {
              isPasswordWrong = false;
            });
          }
        },
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}