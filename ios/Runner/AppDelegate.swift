import UIKit // iOS UI ke liye
import Flutter // Flutter engine
import Firebase // Firebase use karne ke liye

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication, // app lifecycle
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? // launch options
  ) -> Bool {

    FirebaseApp.configure() // 🔥 Firebase initialize kar raha hai

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
