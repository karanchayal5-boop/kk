import 'package:flutter/material.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:kk/controller/taxi_controller.dart';
import 'package:kk/home/search_screen.dart';

class MyAppleMap extends StatefulWidget {
  const MyAppleMap({super.key});

  @override
  State<MyAppleMap> createState() => _MyAppleMapState();
}

class _MyAppleMapState extends State<MyAppleMap> {
  
  final TaxiController taxiController = Get.put(TaxiController());
  late AppleMapController mapController;
  
  LatLng _selectedLocation = LatLng(30.4033, 74.0203);
  BitmapDescriptor? taxiIcon;
  Set<Annotation> _annotations = {};

  @override
  void initState() {
    super.initState();
    _loadIconsAndTaxis();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
     
      if (!taxiController.isDestinationSelected.value) {
        _openBookingSheet();
      }
    });
  }

  Future<void> _loadIconsAndTaxis() async {
    taxiIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(35, 35)),
      'assets/images/bitmoji@3x.png', 
    );
    _updateMarkers(_selectedLocation);
  }

  void _updateMarkers(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _annotations = {
        Annotation(
          annotationId:  AnnotationId("user_selection"),
          position: position,
          icon: BitmapDescriptor.defaultAnnotationWithHue(BitmapDescriptor.hueOrange),
        ),
      };
    });
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
      initialChildSize: 0.45,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: _sheetDecoration(),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            children: [
              _handleBar(),
              const SizedBox(height: 25),
              Text("Hi James!", style: TextStyle(color: Colors.orange[400], fontSize: 16, fontWeight: FontWeight.bold)),
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
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: _sheetDecoration(),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              _handleBar(),
              const SizedBox(height: 15),
              const Text("You will reach by 12:44 PM", textAlign: TextAlign.center, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              _vehicleCard("First Available", "4 Seater", "\$64", 'assets/images/car_group.png', false),
              const SizedBox(height: 10),
              _vehicleCard("Sedan", "4 Seater", "\$45", 'assets/images/sedan.png', true),
              const SizedBox(height: 20),
              _buildPaymentInfo(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
          ),

          
          Obx(() => taxiController.isDestinationSelected.value 
            ? _buildTopRouteBar() 
            : _buildMenuButton()),

          
          Obx(() => taxiController.isDestinationSelected.value 
            ? _buildVehicleSelectionSheet() 
            : const SizedBox.shrink()), 
        ],
      ),
    );
  }

  

  Widget _buildTopRouteBar() {
    return Positioned(
      top: 60, left: 20, right: 20,
      child: Column(
        children: [
          _routeInputBox("Crunt Location", isTop: true),
          _routeInputBox("Destination", isTop: false),
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
      onTap: () => Get.to(() => const SearchDestinationScreen(), transition: Transition.downToUp),
      decoration: InputDecoration(
        hintText: "Search location",
        prefixIcon: const Icon(Icons.search),
        filled: true, fillColor: Colors.grey[100],
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
          const Icon(Icons.directions_car, size: 40), // Replace with Image.asset(img)
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
        Text("Change", style: TextStyle(color: Colors.orange[400])),
        const SizedBox(width: 10),
        const Icon(Icons.calendar_month, size: 18),
        const Text(" Schedule"),
      ],
    );
  }

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