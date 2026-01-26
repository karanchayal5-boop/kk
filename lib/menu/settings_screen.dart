// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kk/controller/auth_controller.dart';
import 'package:kk/login/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ===== HEADER =====
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.menu),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Settings",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// ===== OPTIONS =====
              _buildTile(Icons.person_outline, "My profile"),
              _buildDivider(),
              _buildTile(Icons.credit_card, "Payment methods"),
              _buildDivider(),

              /// Notifications with switch
              Row(
                children: [
                  const Icon(Icons.notifications_none, color: Colors.grey),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      "Notifications",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Switch(
                    value: true,
                    activeColor: Colors.orange,
                    onChanged: (v) {},
                  )
                ],
              ),

              _buildDivider(),
              _buildTile(Icons.star_border, "Saved address"),

              const SizedBox(height: 30),

              /// ===== CONTACT CARD =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Speak to available staff for assistance",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: const [
                            Icon(Icons.call, color: Colors.blue, size: 32),
                            SizedBox(height: 5),
                            Text("Contact"),
                          ],
                        ),
                        Column(
                          children: const [
                            Icon(Icons.warehouse_sharp, color: Colors.green, size: 32),
                            SizedBox(height: 5),
                            Text("Whatsapp"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const Spacer(),

              /// ===== LOGOUT =====
              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    final AuthController authController = Get.find<AuthController>();

                    await authController.logout(); // 🔥 password delete

                    Get.offAll(() => const LoginScreen());
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: const Icon(Icons.power_settings_new, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 10),
                      const Text("Log Out"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// ===== VERSION =====
              const Center(
                child: Text(
                  "App version v1.0",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 15),
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Divider(height: 1),
    );
  }
}
