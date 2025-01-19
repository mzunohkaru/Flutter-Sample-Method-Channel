import UIKit
import Flutter
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate, FlutterStreamHandler {

    private var locationChannel: FlutterMethodChannel?
    private var locationManager: CLLocationManager!
    
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

        /// MethodChannelのチャンネル名
        locationChannel = FlutterMethodChannel(name: "com.example.method_channel_sample",
                                               binaryMessenger: controller.binaryMessenger)
        locationChannel?.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "getLocation" {
                self.getLocation(result: result)
            } else if call.method == "watchLocation" {
                self.watchLocation()
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        /// EventChannelのチャンネル名
        eventChannel = FlutterEventChannel(name: "com.example.event_channel_sample", binaryMessenger: controller.binaryMessenger)
        eventChannel?.setStreamHandler(self)
        
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

// 位置情報監視処理
extension AppDelegate {
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        locationManager.stopUpdatingLocation()
        return nil
    }
    
    private func watchLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            eventSink?("\(location.coordinate.latitude),\(location.coordinate.longitude)")
        }
    }
}

