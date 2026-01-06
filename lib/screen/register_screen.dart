import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/login.png', 
              height: 200,
              fit: BoxFit.contain,
            ),
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
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10)
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 180),
                  
                  const Text(
                    'Create a new account',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  
                  _buildTextField('First name'),
                  const SizedBox(height: 15),
                  _buildTextField('Last name'),
                  const SizedBox(height: 15),
                  _buildTextField('Email address'),
                  const SizedBox(height: 15),
                  IntlPhoneField(
                     decoration: InputDecoration(
                     hintText: 'Mobile Number',
                     fillColor: Colors.white,
                     filled: true,
                     border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10),
                     borderSide: BorderSide.none,
                     ),
                    ),
                    initialCountryCode: 'IN', 
                 onChanged: (phone) {
                    print(phone.completeNumber); 
                    },
                   ),
                  const SizedBox(height: 25),

                  
                  Row(
                    children: [
                      Checkbox(
                        value: isAccepted,
                        activeColor: Colors.orange,
                        onChanged: (value) {
                          setState(() => isAccepted = value!);
                        },
                      ),
                      const Text("By click you accept the ", style: TextStyle(fontSize: 13)),
                      const Text(
                        "Terms & conditions",
                        style: TextStyle(fontSize: 13, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                      ),
                      child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}