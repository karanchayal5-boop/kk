import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kk/home/search_screen.dart';

class InitialSearchSheet extends StatelessWidget {
  const InitialSearchSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.035,
      minChildSize: 0.035,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: _sheetDecoration(),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            children: [
              const SizedBox(height: 15),
              Text(
                "Hi Karan!",
                style: TextStyle(
                  color: Colors.orange[400],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Where do you want to go?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _searchFieldTrigger(),
              const SizedBox(height: 25),
              _buildLocationTile(Icons.home, "Home", "Fazilka, Punjab"),
              _buildLocationTile(Icons.work, "Work", "Office Address..."),
            ],
          ),
        );
      },
    );
  }

  // Helper Widgets

  BoxDecoration _sheetDecoration() => const BoxDecoration(
    color: Color.fromARGB(255, 255, 255, 255),
    borderRadius: BorderRadius.vertical(top: Radius.circular(1)),
    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
  );

  Widget _searchFieldTrigger() {
    return TextField(
      readOnly: true,
      onTap: () => Get.to(
        () => const SearchDestinationScreen(),
        transition: Transition.downToUp,
      ),
      decoration: InputDecoration(
        hintText: "Search location",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLocationTile(IconData icon, String title, String sub) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey[100],
        child: Icon(icon, color: Colors.grey[600], size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
