import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let plattformChannel = FlutterMethodChannel(name: "com.sensor.speaker",
    binaryMessenger: controller.binaryMessenger)
    
    plattformChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult)-> Void in
        if(call.method=="genTone"){
            result("Hi Kartik Jabreba")
            
            
        }
    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

