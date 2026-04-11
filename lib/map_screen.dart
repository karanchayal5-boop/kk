import 'dart:async'; // async ka use future/stream ke liye hota hai
import 'package:flutter/material.dart'; // UI banane ke liye
import 'package:apple_maps_flutter/apple_maps_flutter.dart'; // Apple map
import 'package:get/get.dart'; // state management
import 'package:kk/controller/taxi_controller.dart'; // controller
import 'package:kk/home/driver_arriving_sheet.dart'; // UI screens
import 'package:kk/home/finding_driver_sheet.dart';
import 'package:kk/home/initial_search_sheet.dart';
import 'package:kk/home/notes_for_driver_sheet.dart';
import 'package:kk/home/vehicle_selection_sheet.dart';
import 'package:kk/home/custom_menu_button.dart';
import 'package:kk/menu/side_menu_page.dart';
import 'package:firebase_database/firebase_database.dart'; // firebase

class MyAppleMap extends StatefulWidget {
  const MyAppleMap({super.key}); // constructor

  @override
  State<MyAppleMap> createState() => _MyAppleMapState(); // state create
}

class _MyAppleMapState extends State<MyAppleMap>
    with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // drawer control

  final TaxiController taxiController = Get.put(TaxiController()); // controller init

  DatabaseReference? driverRef; // firebase reference
  StreamSubscription<DatabaseEvent>? driverListener; // listener

  AppleMapController? mapController; // map controller

  // 👉 FIXED LOCATION (manual set kiya)
  LatLng _currentLocation = const LatLng(30.4033, 74.0203); // default location

  BitmapDescriptor? userIcon; // user icon
  BitmapDescriptor? taxiIcon; // taxi icon

  Set<Annotation> _annotations = {}; // markers
  final Set<Polyline> _polylines = {}; // route lines

  late AnimationController _blinkController; // animation
// opacity animation

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // blink speed
    )..repeat(reverse: true); // animation loop

// opacity change

    _initMapData(); // icons load

    // 👉 Firebase driver location listen
    driverRef = FirebaseDatabase.instance.ref("driversLocation/driver_1");

    driverListener = driverRef!.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;

        LatLng driverPos = LatLng(
          data["lat"], // latitude
          data["lng"], // longitude
        );

        _updateDriverMarker(driverPos); // marker update
      }
    });

    _updateMarkers(); // initial marker set
  }

  @override
  void dispose() {
    driverListener?.cancel(); // listener stop
    _blinkController.dispose(); // animation stop
    super.dispose();
  }

  // 👉 Driver marker update
  void _updateDriverMarker(LatLng driverPos) {
    setState(() {
      _annotations.removeWhere(
          (a) => a.annotationId.value == "taxi1"); // old remove

      _annotations.add(
        Annotation(
          annotationId: AnnotationId("taxi1"), // id
          position: driverPos, // position
          icon: taxiIcon ?? BitmapDescriptor.defaultAnnotation,
        ),
      );
    });
  }

  // 👉 Icons load
  Future<void> _initMapData() async {
    userIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/images/bitmoji@3x.png',
    );

    taxiIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(35, 35)),
      'assets/images/car_group.png',
    );
  }

  // 👉 User marker set (fixed location)
  void _updateMarkers() {
    _annotations = {
      Annotation(
        annotationId: AnnotationId("user"),
        position: _currentLocation, // fixed position
        icon: userIcon ?? BitmapDescriptor.defaultAnnotation,
        infoWindow: const InfoWindow(title: "You are here"),
      ),
    };
  }

  // 👉 Route draw (simple line)
  void drawOrangeRoute(LatLng start, LatLng end) {
    setState(() {
      _polylines.clear();

      _polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          points: [start, end], // start to end line
          color: Colors.orange,
          width: 5,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Positioned.fill(
            child: AppleMap(
              onMapCreated: (controller) =>
                  mapController = controller, // map init

              initialCameraPosition: CameraPosition(
                target: _currentLocation, // fixed location
                zoom: 15,
              ),

              annotations: _annotations, // markers
              polylines: _polylines, // route
            ),
          ),

          // 👉 Route auto draw
          Obx(() {
            if (taxiController.isDestinationSelected.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                drawOrangeRoute(
                  _currentLocation,
                  taxiController.destinationLatLng.value,
                );
              });
            }
            return const SizedBox();
          }),

          // 👉 Bottom sheets logic
          Obx(() {
            if (!taxiController.isDestinationSelected.value) {
              return const InitialSearchSheet();
            } else if (taxiController.currentStep.value == 0) {
              return VehicleSelectionSheet();
            } else if (taxiController.currentStep.value == 1) {
              return NotesForDriverSheet();
            } else if (taxiController.currentStep.value == 2) {
              return FindingDriverSheet();
            } else {
              return const DriverArrivingSheet();
            }
          }),

          // 👉 Menu button
          CustomMenuButton(
            onTap: () {
              Get.generalDialog(
                pageBuilder: (context, a1, a2) => const SideMenuPage(),
                barrierDismissible: true,
                barrierLabel: "Menu",
                barrierColor: Colors.transparent,
                transitionDuration: const Duration(milliseconds: 300),
                transitionBuilder: (context, anim, secAnim, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}