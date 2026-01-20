import 'dart:async';
import 'package:flutter/material.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kk/controller/taxi_controller.dart';
import 'package:kk/home/driver_arriving_sheet.dart';
import 'package:kk/home/finding_driver_sheet.dart';
import 'package:kk/home/initial_search_sheet.dart';
import 'package:kk/home/notes_for_driver_sheet.dart';
import 'package:kk/home/vehicle_selection_sheet.dart';
import 'package:kk/home/custom_menu_button.dart';
import 'package:kk/home/side_menu_page.dart';

class MyAppleMap extends StatefulWidget {
  const MyAppleMap({super.key});

  @override
  State<MyAppleMap> createState() => _MyAppleMapState();
}

class _MyAppleMapState extends State<MyAppleMap> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TaxiController taxiController = Get.put(TaxiController());

  AppleMapController? mapController;

  LatLng _currentLocation = const LatLng(30.4033, 74.0203);

  BitmapDescriptor? userIcon;
  BitmapDescriptor? taxiIcon;
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;

  Set<Annotation> _annotations = {};
  Set<Polyline> _polylines = {};
  Set<Circle> _circles = {};

  StreamSubscription<Position>? _positionStream;

  late AnimationController _blinkController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.2, end: 0.6).animate(_blinkController)
      ..addListener(() {
        _updateTaxiCircles();
      });

    _initMapData();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _blinkController.dispose();
    super.dispose();
  }

  Future<void> _initMapData() async {
    userIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/images/bitmoji@3x.png',
    );

    taxiIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(35, 35)),
      'assets/images/car_group.png',
    );

    sourceIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      'assets/images/Group 36@3x.png',
    );

    destinationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      'assets/images/Group 37@3x.png',
    );

    _checkPermissionsAndStartTracking();
  }

  Future<void> _checkPermissionsAndStartTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    _updateLocation(LatLng(position.latitude, position.longitude));

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      _updateLocation(LatLng(position.latitude, position.longitude));
    });
  }

  void _updateLocation(LatLng pos) {
    setState(() {
      _currentLocation = pos;
      _updateMarkers();
    });

    mapController?.animateCamera(CameraUpdate.newLatLng(pos));
  }

  void _updateMarkers() {
    _annotations = {
      Annotation(
        annotationId:    AnnotationId("user"),
        position: _currentLocation,
        icon: userIcon ?? BitmapDescriptor.defaultAnnotation,
        infoWindow: const InfoWindow(title: "You are here"),
      ),
      Annotation(
        annotationId:  AnnotationId("taxi1"),
        position: LatLng(_currentLocation.latitude + 0.002, _currentLocation.longitude + 0.002),
        icon: taxiIcon ?? BitmapDescriptor.defaultAnnotation,
      ),
      Annotation(
        annotationId:  AnnotationId("taxi2"),
        position: LatLng(_currentLocation.latitude - 0.002, _currentLocation.longitude - 0.001),
        icon: taxiIcon ?? BitmapDescriptor.defaultAnnotation,
      ),
    };
  }
  
  void _updateTaxiCircles() {
    if (taxiController.isDestinationSelected.value) {
      _circles = {};
      return;
    }

    _circles = {
      Circle(
        circleId:  CircleId("blink1"),
        center: LatLng(_currentLocation.latitude + 0.002, _currentLocation.longitude + 0.002),
        radius: 18,
        fillColor: Colors.orange.withOpacity(_opacityAnimation.value),
        strokeWidth: 0,
      ),
    };
  }

 
  void calculateDistanceAndTime(LatLng start, LatLng end) {
    double meters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );

    double km = meters / 1000;
    double avgSpeedKmPerHr = 35;

    double timeInHours = km / avgSpeedKmPerHr;
    int minutes = (timeInHours * 60).round();

    taxiController.estimatedTimeMin.value = minutes;
    taxiController.estimatedDistanceKm.value = double.parse(km.toStringAsFixed(2));
  }

  // =========================
  // ✅ DRAW ROUTE
  // =========================
  void drawOrangeRoute(LatLng start, LatLng end) {
    calculateDistanceAndTime(start, end);

    setState(() {
      _polylines.clear();

      _polylines.add(
        Polyline(
          polylineId:  PolylineId("route"),
          points: [start, end],
          color: Colors.orange,
          width: 5,
        ),
      );

      _annotations.addAll({
        Annotation(
          annotationId:  AnnotationId("source"),
          position: start,
          icon: sourceIcon ?? BitmapDescriptor.defaultAnnotation,
        ),
        Annotation(
          annotationId:   AnnotationId("destination"),
          position: end,
          icon: destinationIcon ?? BitmapDescriptor.defaultAnnotation,
        ),
      });
    });

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        start.latitude < end.latitude ? start.latitude : end.latitude,
        start.longitude < end.longitude ? start.longitude : end.longitude,
      ),
      northeast: LatLng(
        start.latitude > end.latitude ? start.latitude : end.latitude,
        start.longitude > end.longitude ? start.longitude : end.longitude,
      ),
    );

    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: const Drawer(child: Center(child: Text("Menu"))),
      body: Stack(
        children: [
          Positioned.fill(
            child: AppleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: CameraPosition(target: _currentLocation, zoom: 15),
              annotations: _annotations,
              polylines: _polylines,
            circles: _circles,
          ),),

          // ROUTE AUTO DRAW
          Obx(() {
            if (taxiController.isDestinationSelected.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                drawOrangeRoute(_currentLocation, taxiController.destinationLatLng.value);
              });
            }
            return const SizedBox.shrink();
          }),

          
          Obx(() {
            if (!taxiController.isDestinationSelected.value) {
            return const InitialSearchSheet();
            }
                if (taxiController.currentStep.value == 0) {
                 return VehicleSelectionSheet();
             } else if (taxiController.currentStep.value == 1) {
                 return NotesForDriverSheet();
             } else if (taxiController.currentStep.value == 2) {
                 return FindingDriverSheet();
             } else {
                 return const DriverArrivingSheet();
             }
             }),


          CustomMenuButton(
            onTap: () {
              Get.generalDialog(
               pageBuilder: (context, a1, a2) => const SideMenuPage(),
               barrierDismissible: true,
               barrierLabel: "Menu",
               barrierColor: Colors.transparent, // 👈 IMPORTANT
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
