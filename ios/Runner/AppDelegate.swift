import UIKit
import Flutter
import MapKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController

    let channel = FlutterMethodChannel(
      name: "apple_maps_route",
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { (call, result) in
      if call.method == "getRoute" {
        let args = call.arguments as! [String: Any]

        let startLat = args["startLat"] as! Double
        let startLng = args["startLng"] as! Double
        let endLat = args["endLat"] as! Double
        let endLng = args["endLng"] as! Double

        self.getAppleRoute(
          startLat: startLat,
          startLng: startLng,
          endLat: endLat,
          endLng: endLng,
          result: result
        )
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  
  func getAppleRoute(
    startLat: Double,
    startLng: Double,
    endLat: Double,
    endLng: Double,
    result: @escaping FlutterResult
  ) {
    let startPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: startLat, longitude: startLng))
    let endPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: endLat, longitude: endLng))

    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: startPlacemark)
    request.destination = MKMapItem(placemark: endPlacemark)
    request.transportType = .automobile

    let directions = MKDirections(request: request)

    directions.calculate { response, error in
      if let error = error {
        result(FlutterError(code: "ROUTE_ERROR", message: error.localizedDescription, details: nil))
        return
      }

      guard let route = response?.routes.first else {
        result(FlutterError(code: "NO_ROUTE", message: "No route found", details: nil))
        return
      }

      var points: [[Double]] = []

      let polyline = route.polyline
      let coords = polyline.points()

      for i in 0..<polyline.pointCount {
        let coord = coords[i].coordinate
        points.append([coord.latitude, coord.longitude])
      }

      let travelTimeMinutes = Int(route.expectedTravelTime / 60)

      let data: [String: Any] = [
        "points": points,
        "time": travelTimeMinutes,
        "distance": route.distance
      ]

      result(data)
    }
  }
}
