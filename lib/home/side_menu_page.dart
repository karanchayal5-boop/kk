import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenuPage extends StatelessWidget {
  const SideMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          // ================= LEFT MENU =================
          Container(
            width: 110,
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  _item(Icons.home, "Home", true),
                  _item(Icons.waves, "Trips", false),
                  _item(Icons.settings, "Settings", false),
                  _item(Icons.card_giftcard, "Promo's", false),
                  _item(Icons.description, "Legal", false),
                  _item(Icons.chat_bubble_outline, "Contact", false),
                ],
              ),
            ),
          ),

          // ================= RIGHT DARK AREA =================
          Expanded(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                color: Colors.black.withOpacity(0.45),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _item(IconData icon, String text, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: active ? Colors.orange : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: active ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: active ? Colors.orange : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
