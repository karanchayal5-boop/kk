import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:kk/controller/taxi_controller.dart';

class SearchDestinationScreen extends StatefulWidget {
  const SearchDestinationScreen({super.key});

  @override
  State<SearchDestinationScreen> createState() => _SearchDestinationScreenState();
}

class _SearchDestinationScreenState extends State<SearchDestinationScreen> {
  List<Map<String, dynamic>> _locations = [];
  final TaxiController taxiController = Get.put(TaxiController());
  final TextEditingController _pickupController = TextEditingController(text: "Current location");
  final TextEditingController _dropController = TextEditingController();

  void _onSearchChanged(String query) async {
  if (query.isEmpty) return;

  try {
    
    List<Location> locations = await locationFromAddress(query);
    
    setState(() {
      _locations = locations.map((loc) => {
        "name": query, 
        "lat": loc.latitude,
        "lng": loc.longitude,
      }).toList();
    });
  } catch (e) {
    print("Error finding place: $e");
  }
}

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
                          // ignore: non_constant_identifier_names
                          onChanged: (Value){
                            _onSearchChanged(Value);
                          },
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
                itemCount: _locations.length,
                separatorBuilder: (context, index) => Divider(color: Colors.grey[200]),
                itemBuilder: (context, index) {

                  final selected = _locations[index];

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on, color: Colors.grey),
                    title: Text(
                      selected['name'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      final selected =_locations[index];
                      double latitude = selected['lat']?.toDouble()?? 0.0;
                      double longitude = selected['lng']?.toDouble()?? 0.0;

                      taxiController.destinationDone(
                        selected['name'] ?? "unknown",
                        LatLng(latitude, longitude)
                      ); 
                     
                      Get.back();

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