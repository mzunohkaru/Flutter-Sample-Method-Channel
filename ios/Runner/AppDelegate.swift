import UIKit
import Flutter
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
//    @objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate, FlutterStreamHandler  {
    private var locationChannel: FlutterMethodChannel?
    private var locationManager: CLLocationManager!
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      // ここから追加
      locationManager = CLLocationManager()
      locationManager.delegate = self
      locationManager.requestWhenInUseAuthorization()
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      locationChannel = FlutterMethodChannel(name: "com.example.method_channel_sample",
                                             binaryMessenger: controller.binaryMessenger)
      locationChannel?.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          if call.method == "getLocation" {
              self.getLocation(result: result)
          }
          else {
              result(FlutterMethodNotImplemented)
          }
      })
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
         // 位置情報取得ロジック
         private func getLocation(result: @escaping FlutterResult) {
             if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
                 if let location = locationManager.location {
                     result("\(location.coordinate.latitude),\(location.coordinate.longitude)")
                 } else {
                     result(FlutterError(code: "UNAVAILABLE", message: "Location not available.", details: nil))
                 }
             } else {
                 result(FlutterError(code: "PERMISSION_DENIED", message: "Location permission denied.", details: nil))
             }
         }
}
