import 'dart:async'; // Stream ke liye zaroori
import 'package:flutter/material.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart'; // Geolocator import
import 'package:kk/controller/taxi_controller.dart';
import 'package:kk/home/search_screen.dart';

class MyAppleMap extends StatefulWidget {

  const MyAppleMap({super.key});

  @override
  State<MyAppleMap> createState() => _MyAppleMapState();
}

class _MyAppleMapState extends State<MyAppleMap> {
 
  
  final TaxiController taxiController = Get.put(TaxiController());
   AppleMapController? mapController;
  
  // Default Location (Jab tak real location na mile)
  LatLng _selectedLocation = const LatLng(30.4033, 74.0203);
  
  BitmapDescriptor? userIcon; // Rename kiya taaki clear rahe
  BitmapDescriptor? taxiIcon; // Fake taxis ke liye
  Set<Annotation> _annotations = {};

  Set<Polyline> _polylines = {};
  
  // Live Tracking Subscription
  StreamSubscription<Position>? _positionStream;

   


  @override
  void initState() {
    super.initState();
    _initMapData(); 

    
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    mapController = null; // App band hone par tracking band karein
    super.dispose();
  }

  Future<void> _initMapData() async {
    // Icons load karein
    userIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/images/bitmoji@3x.png', 
    );
    
    // Car icon (Fake taxis ke liye)
    taxiIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(35, 35)),
      'assets/images/car_group.png', // Make sure ye image assets mein ho
    );

    // Permissions check karke Live Tracking start karein
    _checkPermissionsAndStartTracking();
  }

  // --- LIVE TRACKING LOGIC ---
  Future<void> _checkPermissionsAndStartTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    // 1. Pehle current location lein aur camera wahan move karein
    Position position = await Geolocator.getCurrentPosition();
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);
    
    _updateMarkers(currentLatLng);

    
    // Map controller agar ready hai to move karein
    // Note: Kabhi kabhi controller init hone me time leta hai
    Future.delayed(const Duration(seconds: 1), () {
      mapController?.animateCamera(CameraUpdate.newLatLng(currentLatLng));
    });

    // 2. Real-time updates sunna shuru karein (User chalega to marker chalega)
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Har 5 meter par update karega
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      LatLng livePos = LatLng(position.latitude, position.longitude);
      
      // Marker update karein
      _updateMarkers(livePos);
      
      // Optional: Agar aap chahte hain camera hamesha user ke piche chale
      // mapController.animateCamera(CameraUpdate.newLatLng(livePos));
    });
  }

  void _updateMarkers(LatLng position) {
    if (mounted) { // Check karein widget screen par hai ya nahi
      setState(() {
        _selectedLocation = position;
        _annotations = {
          // LIVE USER MARKER (Bitmoji)
          Annotation(
            annotationId:  AnnotationId("user_live_location"),
            position: position,
            icon: userIcon ?? BitmapDescriptor.defaultAnnotation,
          ),
          
          // FAKE TAXI 1 (Thoda door)
          Annotation(
            annotationId:  AnnotationId("taxi_1"),
            position: LatLng(position.latitude + 0.002, position.longitude + 0.002),
            icon: taxiIcon ?? BitmapDescriptor.defaultAnnotation,
          ),
          
          // FAKE TAXI 2 (Thoda door)
          Annotation(
            annotationId:  AnnotationId("taxi_2"),
            position: LatLng(position.latitude - 0.002, position.longitude - 0.001),
            icon: taxiIcon ?? BitmapDescriptor.defaultAnnotation,
          ),
        };
      });
    }
  }
  void _drawOrangeRoute(LatLng destinationCoords) {
    if (!mounted|| mapController == null) return;

    setState(() {
      _polylines.clear(); 
      _polylines.add(
        Polyline(
          polylineId: PolylineId("route_1"),
          visible: true,
          points: [_selectedLocation, destinationCoords], 
          color: Colors.orange, 
          width: 5, 
        ),
      );
      _annotations.add(
        Annotation(
          annotationId: AnnotationId("destination_point"),
          position: destinationCoords,
          icon: BitmapDescriptor.defaultAnnotation,
          
          )
      );
    });
    LatLngBounds bounds;
    if (_selectedLocation.latitude< destinationCoords.latitude) {
      bounds =LatLngBounds(southwest: _selectedLocation, northeast: destinationCoords);
    } else {
      bounds =LatLngBounds(southwest: destinationCoords, northeast: _selectedLocation);
    }

    try{
    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds,100));
  } catch (e) {
    print("Map controller error: $e");
  }
}

  
  
  void _openBookingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => _buildInitialSearchUI(),
    );
  }

  Widget _buildInitialSearchUI() {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: _sheetDecoration(),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            children: [
              _handleBar(),
              const SizedBox(height: 10),
              const Center(
                child: Icon(Icons.keyboard_arrow_up, color : Colors.grey),
              ),
              const SizedBox(height: 15),
              Text("Hi Karan!", style: TextStyle(color: Colors.orange[400], fontSize: 16, fontWeight: FontWeight.bold)),
              const Text("Where do you want to go?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 20),
              _searchFieldTrigger(),
              const SizedBox(height: 25),
              _buildWhiteLocationTile(Icons.home, "Home", "Fazilka, Punjab"),
              _buildWhiteLocationTile(Icons.work, "Work", "Office Address..."),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVehicleSelectionSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: _sheetDecoration(),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            children: [
              _handleBar(),
              const SizedBox(height: 15),
              const Text("You will reach by 12:44 PM", textAlign: TextAlign.center, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              _vehicleCard("First Available", "4 Seater", "\$64", 'assets/images/firsr_available@3x.png', false),
              const SizedBox(height: 10),
              _vehicleCard("Sedan", "4 Seater", "\$45", 'assets/images/sedan@3x.png', true),
              const SizedBox(height: 20),
              _buildPaymentInfo(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  taxiController.currentStep.value = 1;
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        );
      },
    );
  }
  Widget _buildNotesForDriverSheet() {
  return DraggableScrollableSheet(
    initialChildSize: 0.3,
    minChildSize: 0.2,
    maxChildSize: 0.5,
    builder: (context, scrollController) {
      return Container(
        decoration: _sheetDecoration(),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          children: [
            _handleBar(),
            const SizedBox(height: 20),
            const Text("Add notes for driver", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "Type your message here",
                fillColor: Colors.grey[100],
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.horizontal(), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => taxiController.currentStep.value = 0, // Wapas vehicle par jane ke liye
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text("Cancel",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      taxiController.currentStep.value=2;
                    },
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    elevation: 0,
                    ),
                    child: const Text("Continue",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
              ],
            )
          ],
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: CameraPosition(target: _selectedLocation, zoom: 15),
            annotations: _annotations,
            polylines: _polylines,
            myLocationEnabled: false,
            
          ),

          Obx(() {
            if (taxiController.isDestinationSelected.value) {
              return _buildTopRouteBar();
            } else {
              return const SizedBox.shrink();
            }
          }),

        // 3. Taxi Selection Sheet (Search ke baad wali)
          Obx(() {
            if (taxiController.isDestinationSelected.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _drawOrangeRoute(taxiController.destinationLatLng.value);
              });
              if (taxiController.currentStep.value == 0) {
                return _buildVehicleSelectionSheet();
              } else if ( taxiController.currentStep.value == 1) {
                return _buildNotesForDriverSheet();
              } else if (taxiController.currentStep.value == 2) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildFindingDriverSheet(),
                );
              } else { 
                return _buildVehicleSelectionSheet();
              }
              } else {
              return _buildInitialSearchUI();
            }
          }),
            
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildTopRouteBar() {
    return Positioned(
      top: 60, left: 20, right: 20,
      child: Column(
        children: [
          _routeInputBox("Current Location", isTop: true),
          Obx(() => _routeInputBox(
            taxiController.destinationAddress.value.isEmpty
            ? "destination"
            : taxiController.destinationAddress.value,
          isTop: false,
          ))
        ],
      ),
    );
  }

  Widget _routeInputBox(String text, {required bool isTop}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: isTop ? 1 : 0))),
      child: Row(
        children: [
          Icon(isTop ? Icons.circle : Icons.square, size: 10, color: Colors.orange),
          const SizedBox(width: 15),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _searchFieldTrigger() {
  return TextField(
    readOnly: true,
    onTap: () {
      
      // Get.to ka use karein taaki Map Screen piche zinda rahe (stack mein)
      Get.to(
        () => const SearchDestinationScreen(), 
        transition: Transition.downToUp, // Neeche se upar aane wali animation
      );
    },
    decoration: InputDecoration(
      hintText: "Search location",
      prefixIcon: const Icon(Icons.search),
      filled: true, 
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
    ),
  );
}

  Widget _vehicleCard(String title, String sub, String price, String img, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSelected ? Colors.orange : Colors.grey[200]!, width: 2),
      ),
      child: Row(
        children: [
          // Yahan Image.asset use karein jab actual images hon
          const Icon(Icons.directions_car, size: 40), 
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(sub, style: const TextStyle(color: Colors.grey))])),
          Text(price, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isSelected ? Colors.orange : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Row(
      children: [
        const Text("Payment", style: TextStyle(color: Colors.grey)),
        const SizedBox(width: 10),
        const Text("xxxx xxxx 4793", style: TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        Text("Change", style: TextStyle(color: Colors.orange[900])),
        const SizedBox(width: 10),
        const Icon(Icons.calendar_month, size: 18),
        const Text(" Schedule"),
      ],
    );
  }
  Widget _buildFindingDriverSheet() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start, // Left aligned text ke liye
      children: [
        // 1. Text Heading
        const Text(
          "Searching nearby cabs...",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 25),

        // 2. Orange Progress Bar
        const LinearProgressIndicator(
          backgroundColor: Color(0xFFEEEEEE), // Halka grey background
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)), // Orange color
          minHeight: 4, // Patli bar jaisa screenshot mein hai
        ),
        const SizedBox(height: 35),

        // 3. Cancel Ride Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              taxiController.currentStep.value = 1; // Wapas notes wali screen par
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D2E32), // Dark grey/black
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Cancel Ride",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}

  // ignore: unused_element
  Widget _buildMenuButton() {
    return Positioned(top: 60, left: 20, child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(icon: const Icon(Icons.menu, color: Colors.black87), onPressed: _openBookingSheet)));
  }

  BoxDecoration _sheetDecoration() => BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(30)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)]);
  Widget _handleBar() => Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))));

  Widget _buildWhiteLocationTile(IconData icon, String title, String sub) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: Colors.grey[100], child: Icon(icon, color: Colors.grey[600], size: 20)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}