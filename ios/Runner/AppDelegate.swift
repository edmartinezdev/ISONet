import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var appChannel: FlutterMethodChannel? = nil
  var flutterResult: FlutterResult? = nil
  let channelName = "com.isonet.app"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    self.createChannelAndRegisterHandlerForCommunication()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension AppDelegate {
    func createChannelAndRegisterHandlerForCommunication() {

        guard let contoller: FlutterBinaryMessenger = self.window.rootViewController as? FlutterBinaryMessenger else { return }

        self.appChannel = FlutterMethodChannel.init(name: self.channelName, binaryMessenger: contoller)
        appChannel?.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let `self` = self else { return }


            if (call.method == "clearNotification") {
                UIApplication.shared.applicationIconBadgeNumber = 0
                result("clearNotification")
            }else {
                result(FlutterMethodNotImplemented)
            }

        }
    }
 }
