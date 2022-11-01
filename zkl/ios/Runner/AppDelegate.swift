import UIKit
import Flutter
import NetworkExtension

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    private var utils : VPNUtils! = VPNUtils()
    private var status : FlutterEventSink!
    private var stage : FlutterEventSink!
    
    
    private var EVENT_CHANNEL_VPN_STAGE : String = "id.nizwar.nvpn/vpnstage"
    private var EVENT_CHANNEL_VPN_STATUS : String = "id.nizwar.nvpn/vpnstatus"
    private var METHOD_CHANNEL_VPN_CONTROL : String = "id.nizwar.nvpn/vpncontrol"
    
    override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let vpnControlM = FlutterMethodChannel(name: METHOD_CHANNEL_VPN_CONTROL, binaryMessenger: controller.binaryMessenger)
        let vpnStatusE = FlutterEventChannel(name: EVENT_CHANNEL_VPN_STATUS, binaryMessenger: controller.binaryMessenger)
        let vpnStageE = FlutterEventChannel(name: EVENT_CHANNEL_VPN_STAGE, binaryMessenger: controller.binaryMessenger)
        
        vpnStageE.setStreamHandler(self)
        vpnStatusE.setStreamHandler(self)
        vpnControlM.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method{
            case "stage":
                result(self.utils.currentStatus())
                break;
            case "initialize":
                let providerBundleIdentifier: String? = (call.arguments as? [String: Any])?["providerBundleIdentifier"] as? String
                let localizedDescription: String? = (call.arguments as? [String: Any])?["localizedDescription"] as? String
                if providerBundleIdentifier == nil  {
                    result(FlutterError(code: "-2", message: "providerBundleIdentifier content empty or null", details: nil));
                    return;
                }
                if localizedDescription == nil  {
                    result(FlutterError(code: "-3", message: "localizedDescription content empty or null", details: nil));
                    return;
                }
                self.utils.localizedDescription = localizedDescription
                self.utils.providerBundleIdentifier = providerBundleIdentifier
                self.utils.status = self.status
                self.utils.stage = self.stage
                self.utils.loadProviderManager{(err:Error?) in
                    if err == nil{
                        result(self.utils.currentStatus())
                    }else{
                        result(FlutterError(code: "-4", message: err.debugDescription, details: err?.localizedDescription));
                    }
                }
                
                break;
            case "stop":
                self.utils.stopVPN()
                break;
            case "start":
                let config: String? = (call.arguments as? [String : Any])? ["config"] as? String
                let username: String? = (call.arguments as? [String : Any])? ["username"] as? String
                let password: String? = (call.arguments as? [String : Any])? ["password"] as? String
                if config == nil{
                    result(FlutterError(code: "-1", message:"Config is empty or nulled", details: "Config can't be nulled"))
                    return
                }
                self.utils.configureVPN(config: config, username: username, password: password, completion: {(success:Error?) -> Void in
                    if(success == nil){
                        result(nil)
                    }else{
                        result(FlutterError(code: "-5", message: success?.localizedDescription, details: success.debugDescription))
                    }
                })
                break;
            default:
                break;
                
            }
        })
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        status = eventSink
        stage = eventSink
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}


@available(iOS 9.0, *)
class VPNUtils {
    var providerManager: NETunnelProviderManager!
    var providerBundleIdentifier : String?
    var localizedDescription : String?
    var status : FlutterEventSink!
    var stage : FlutterEventSink!
    
    func loadProviderManager(completion:@escaping (_ error : Error?) -> Void)  {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error)  in
            if error == nil {
                self.providerManager = managers?.first ?? NETunnelProviderManager()
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
    
    func onVpnStatusChanged(notification : NEVPNStatus) {
        switch notification {
        case NEVPNStatus.connected:
            NSLog("CONNECTED")
            stage("connected")
            break;
        case NEVPNStatus.connecting:
            NSLog("CONNECTING")
            stage("connecting")
            break;
        case NEVPNStatus.disconnected:
            NSLog("DISCONNECT")
            stage("disconnected")
            break;
        case NEVPNStatus.disconnecting:
            NSLog("DISCONNECTING")
            stage("disconnecting")
            break;
        case NEVPNStatus.invalid:
            NSLog("INVALID")
            stage("invalid")
            break;
        case NEVPNStatus.reasserting:
            NSLog("REASSERTING")
            stage("reasserting")
            break;
        default:
            stage("null")
            break;
        }
    }
    
    func onVpnStatusChangedString(notification : NEVPNStatus?) -> String?{
        if notification == nil {
            return "disconnected"
        }
        switch notification! {
        case NEVPNStatus.connected:
            return "connected";
        case NEVPNStatus.connecting:
            return "connecting";
        case NEVPNStatus.disconnected:
            return "disconnected";
        case NEVPNStatus.disconnecting:
            return "disconnecting";
        case NEVPNStatus.invalid:
            return "invalid";
        case NEVPNStatus.reasserting:
            return "reasserting";
        default:
            return "";
        }
    }
    
    func currentStatus() -> String? {
        if self.providerManager != nil {
            return onVpnStatusChangedString(notification: self.providerManager.connection.status)}
        else{
            return "disconnected"
        }
        //        return "DISCONNECTED"
    }
    
    func configureVPN(config: String?, username : String?,password : String?,completion:@escaping (_ error : Error?) -> Void) {
        let configData = config
        self.providerManager?.loadFromPreferences { error in
            if error == nil {
                let tunnelProtocol = NETunnelProviderProtocol()
                tunnelProtocol.serverAddress = ""
                tunnelProtocol.providerBundleIdentifier = self.providerBundleIdentifier
                let nullData = "".data(using: .utf8)
                tunnelProtocol.providerConfiguration = [
                    "config": configData?.data(using: .utf8) ?? nullData!,
                    "username" : username?.data(using: .utf8) ?? nullData!,
                    "password" : password?.data(using: .utf8) ?? nullData!
                ]
                tunnelProtocol.disconnectOnSleep = false 
                self.providerManager.protocolConfiguration = tunnelProtocol
                self.providerManager.localizedDescription = self.localizedDescription // the title of the VPN profile which will appear on Settings
                self.providerManager.isEnabled = true
                self.providerManager.saveToPreferences(completionHandler: { (error) in
                    if error == nil  {
                        self.providerManager.loadFromPreferences(completionHandler: { (error) in
                            if error != nil {
                                completion(error);
                                return;
                            }
                            do {
                                NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: nil , queue: nil) { notification in
                                    let nevpnconn = notification.object as! NEVPNConnection
                                    let status = nevpnconn.status
                                    self.onVpnStatusChanged(notification: status)
                                }
                                
                                if username != nil && password != nil{
                                    let options: [String : NSObject] = [
                                        "username": username! as NSString,
                                        "password": password! as NSString
                                    ]
                                    try self.providerManager.connection.startVPNTunnel(options: options)
                                }else{
                                    try self.providerManager.connection.startVPNTunnel()
                                }
                                completion(nil);
                            } catch let error {
                                self.stopVPN()
                                print("Error info: \(error)")
                                completion(error);
                            }
                        })
                    }
                })
            }
        }
    }
    
    func stopVPN() {
        self.providerManager.connection.stopVPNTunnel();
    }
}
