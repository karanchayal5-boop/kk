import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:kk/controller/taxi_controller.dart';

class SearchDestinationScreen extends StatefulWidget {
  const SearchDestinationScreen({super.key});

  @override
  State<SearchDestinationScreen> createState() => _SearchDestinationScreenState();
}

class _SearchDestinationScreenState extends State<SearchDestinationScreen> {
  final TextEditingController _pickupController = TextEditingController(text: "Current location");
  final TextEditingController _dropController = TextEditingController();

 
  final List<String> _suggestions = [
    "Radan Ropal Road",
    "Railway Staion",
    "Fazilka, Punjab, India",
    "Chandigarh, India"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
           
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),


            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[100], 
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                
                  Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.orange, size: 12),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: _pickupController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Current location",
                            hintStyle: TextStyle(color: Colors.orange), 
                          ),
                          style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  
                 
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.5),
                        child: Container(
                          height: 25, 
                          width: 1, 
                          color: Colors.grey[400], 
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(child: Divider(color: Colors.grey[300])), 
                    ],
                  ),

                  
                  Row(
                    children: [
                      const Icon(Icons.square, color: Colors.orange, size: 12), 
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: _dropController,
                          autofocus: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Drope off",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _suggestions.length,
                separatorBuilder: (context, index) => Divider(color: Colors.grey[200]),
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on, color: Colors.grey),
                    title: Text(
                      _suggestions[index],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      
                      Get.find<TaxiController>().destinationDone("Fazilka");
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}