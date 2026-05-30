import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kk/login/OTP_verification_screen.dart';
import 'package:kk/controller/auth_controller.dart';
import 'package:kk/controller/otp_controller.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final OtpController otpController = Get.find<OtpController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  String mobileNumber = "";
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset('assets/images/login.png', height: 120),
            ),
      
            Positioned(
              top: 60,
              left: 20,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 20),
                ),
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 180),
      
                      const Text(
                        "Create a new account",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
      
                      _buildField("First name", firstNameCtrl),
                      const SizedBox(height: 15),
      
                      _buildField("Last name", lastNameCtrl),
                      const SizedBox(height: 15),
      
                      _buildEmailField(),
                      const SizedBox(height: 15),
      
                      IntlPhoneField(
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          mobileNumber = phone.completeNumber;
                        },
                      ),
      
                      const SizedBox(height: 20),
      
                      Row(
                        children: [
                          Checkbox(
                            value: isAccepted,
                            activeColor: Colors.orange,
                            onChanged: (value) {
                              setState(() {
                                isAccepted = value!;
                              });
                            },
                          ),
                          const Text("I accept "),
                          const Text(
                            "Terms & Conditions",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
      
                      const SizedBox(height: 25),
      
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            
      
                            if (!_formKey.currentState!.validate()) return;
      
                            if (mobileNumber.isEmpty) {
                              Get.snackbar("Error", "Please enter mobile number");
                              return;
                            }
      
                            if (!isAccepted) {
                              Get.snackbar(
                                "Error",
                                "Please accept Terms & Conditions",
                              );
                              return;
                            }
      
                            authController.tempEmail.value = emailCtrl.text.trim(); // email ko temp variable me store kar rahe hai
                            authController.tempPhone.value = mobileNumber;
                            otpController.sendOtp(mobileNumber);
      
                            Get.to(() => const OtpVerificationScreen());
      
                            
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
      
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (value) => value!.isEmpty ? "$hint is required" : null,
      decoration: _decoration(hint),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailCtrl,
      validator: (value) {
        if (value!.isEmpty) return "Email is required";
        if (!GetUtils.isEmail(value)) return "Enter valid email";
        return null;
      },
      decoration: _decoration("Email address"),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
