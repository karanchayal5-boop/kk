import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kk/controller/taxi_controller.dart';

class SearchDestinationScreen extends StatefulWidget {
  const SearchDestinationScreen({super.key});

  @override
  State<SearchDestinationScreen> createState() => _SearchDestinationScreenState();
}

class _SearchDestinationScreenState extends State<SearchDestinationScreen> {

  // Search result list
  List<Map<String, dynamic>> _locations = [];

  // Your city places database
  final List<Map<String, dynamic>> cityPlaces = [
    
  {
    "name": "Ghanta Ghar, Fazilka",
    "lat": 30.4030,
    "lng": 74.0280,
  },
  {
    "name": "Bus Stand, Fazilka",
    "lat": 30.4021,
    "lng": 74.0251,
  },
  {
    "name": "Railway Station, Fazilka",
    "lat": 30.4012,
    "lng": 74.0305,
  },
  {
    "name": "Civil Hospital, Fazilka",
    "lat": 30.4045,
    "lng": 74.0260,
  },
  {
    "name": "Old Sabzi Mandi, Fazilka",
    "lat": 30.4038,
    "lng": 74.0272,
  },
  {
    "name": "New Grain Market, Fazilka",
    "lat": 30.4060,
    "lng": 74.0310,
  },
  {
    "name": "MC Office, Fazilka",
    "lat": 30.4040,
    "lng": 74.0290,
  },
  {
    "name": "Court Complex, Fazilka",
    "lat": 30.4070,
    "lng": 74.0285,
  },
  {
    "name": "DAV School, Fazilka",
    "lat": 30.4080,
    "lng": 74.0320,
  },
  {
    "name": "Government College, Fazilka",
    "lat": 30.4090,
    "lng": 74.0300,
  },
  {
    "name": "ITI Chowk, Fazilka",
    "lat": 30.4100,
    "lng": 74.0290,
  },
  {
    "name": "Clock Tower Market, Fazilka",
    "lat": 30.4035,
    "lng": 74.0285,
  },
  {
    "name": "Punjab National Bank, Fazilka",
    "lat": 30.4028,
    "lng": 74.0278,
  },
  {
    "name": "State Bank of India, Fazilka",
    "lat": 30.4032,
    "lng": 74.0282,
  },
  {
    "name": "HDFC Bank, Fazilka",
    "lat": 30.4042,
    "lng": 74.0295,
  },
  {
    "name": "Canara Bank, Fazilka",
    "lat": 30.4050,
    "lng": 74.0300,
  },
  {
    "name": "Old Tehsil, Fazilka",
    "lat": 30.4025,
    "lng": 74.0265,
  },
  {
    "name": "New Tehsil, Fazilka",
    "lat": 30.4065,
    "lng": 74.0315,
  },
  {
    "name": "Water Works, Fazilka",
    "lat": 30.4110,
    "lng": 74.0330,
  },
  {
    "name": "Police Line, Fazilka",
    "lat": 30.4120,
    "lng": 74.0340,
  },
  {
    "name": "Truck Union, Fazilka",
    "lat": 30.4130,
    "lng": 74.0350,
  },
  {
    "name": "Old Grain Market, Fazilka",
    "lat": 30.4048,
    "lng": 74.0270,
  },
  {
    "name": "Shiv Mandir, Fazilka",
    "lat": 30.4039,
    "lng": 74.0289,
  },
  {
    "name": "Gurudwara Sahib, Fazilka",
    "lat": 30.4046,
    "lng": 74.0298,
  },
  {
    "name": "SD College, Fazilka",
    "lat": 30.4095,
    "lng": 74.0312,
  },
  {
    "name": "Mini Secretariat, Fazilka",
    "lat": 30.4140,
    "lng": 74.0360,
  },
];

  

  final TaxiController taxiController = Get.put(TaxiController());

  final TextEditingController _pickupController =
      TextEditingController(text: "Current location");

  final TextEditingController _dropController = TextEditingController();

  // 🔍 Local search function
  void _onSearchChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _locations = [];
      });
      return;
    }

    final results = cityPlaces.where((place) {
      return place["name"]
          .toString()
          .toLowerCase()
          .contains(value.toLowerCase());
    }).toList();

    setState(() {
      _locations = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            // 🔙 Back button
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔎 Search box
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [

                  // Pickup
                  Row(
                    children: [
                      const Icon(Icons.circle,
                          color: Colors.orange, size: 12),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: _pickupController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Current location",
                            hintStyle: TextStyle(color: Colors.orange),
                          ),
                          style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  // Divider
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

                  // Drop
                  Row(
                    children: [
                      const Icon(Icons.square,
                          color: Colors.orange, size: 12),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: _dropController,
                          autofocus: true,
                          onChanged: (value) {
                            _onSearchChanged(value);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Drop off",
                            hintStyle:
                                TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 📋 Suggestions list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _locations.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey[200]),
                itemBuilder: (context, index) {

                  final selected = _locations[index];

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading:
                        const Icon(Icons.location_on, color: Colors.grey),
                    title: Text(
                      selected['name'],
                      style:
                          const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap: () {

                      double latitude =
                          selected['lat']?.toDouble() ?? 0.0;
                      double longitude =
                          selected['lng']?.toDouble() ?? 0.0;

                      taxiController.destinationDone(
                        selected['name'] ?? "unknown",
                        LatLng(latitude, longitude),
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
