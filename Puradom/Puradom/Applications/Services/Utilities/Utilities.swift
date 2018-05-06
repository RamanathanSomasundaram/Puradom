//
//  Utilities.swift
//  MusixxiRecorder
//
//  Created by Lakeba-026 on 06/12/16.
//  Copyright © 2016 Lakeba Corporation Pty Ltd. All rights reserved.
// 255,166,67,
//Blue 18,151,236

import UIKit
import SystemConfiguration
var commonAppDelegate : AppDelegate! = UIApplication.shared.delegate as! AppDelegate
let BASE_URL = "http://puradom.com/puradom_api/main_webservice.php?task="
let CAT_LIST = BASE_URL + "categoryProductlist"
let PRODUCT_LIST = BASE_URL + "getProductList&prodId=";//Product ID
let ALL_PRODUCT_LIST = BASE_URL + "getAllProdList"
let CONTACT_US = BASE_URL + "newEnquiry&"
/* +name=madhu&email=madhu@madhu.com&phone=8892566230&subject=wantproduct&message=wantthisproduct&product_id=23
 */
let processor = RoundCornerImageProcessor(cornerRadius: 20)
//macros
extension UIColor {
    convenience init(netHex:Int) {
        self.init(red: CGFloat((Float((netHex & 0xFF0000) >> 16)) / 255.0), green: CGFloat((Float((netHex & 0xFF00) >> 8)) / 255.0), blue: CGFloat((Float(netHex & 0xFF)) / 255.0), alpha: CGFloat(1.0))
    }
}

class Utilities: NSObject {
    
    //singleton Instance
    class func sharedInstance() -> Utilities {
        var UtilitiesClass: Utilities? = nil
        if(UtilitiesClass != nil)
        {
            UtilitiesClass = Utilities()
        }
        return UtilitiesClass!
    }
    
    class func initPreference()-> Bool
    {
        if(!UserDefaults.standard.bool(forKey: "initPreference"))
        {
        UserDefaults.standard.set(true, forKey: "initPreference")
        UserDefaults.standard.synchronize()
        return true
        }
        return false
    }
    
    //MARK: - Show alert
    //show an alert
    class func showAlert(_ alertMessage: String) {
        let alert = UIAlertController(title: "XpressDeal", message: alertMessage, preferredStyle: .alert)
        let alertCancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertCancel)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    //MARK: - Loading, Hiding progress view
    //show Loading
    class func showLoading() {
        _ = MBProgressHUD.showAdded(to: commonAppDelegate.window!, animated: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    class func showLoading(_ message: String) {
        _ = MBProgressHUD.showAdded(to: commonAppDelegate.window!, animated: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    //To hide the loading
    class func hideLoading() {
        UIApplication.shared.endIgnoringInteractionEvents()
        MBProgressHUD.hide(for: commonAppDelegate.window!, animated: true)
    }
    
    
    //MARK: - date of string change two digits
    class func changeTwoDigitString(_ dateString : String)-> String
    {
        if(dateString.count < 2)
        {
            return "0\(dateString)"
        }
        return dateString
    }
    
    //MARK: - Check Internet Connection
    //Checking the internet connection
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    //MARK: - Check internet Connection
    class func checkForInternet() -> Bool {
        let status = NetworkReachabilityManager.init(host: "www.google.com")
        if self.isConnectedToNetwork() == true && status?.networkReachabilityStatus != .notReachable
        {
            return true
        }
        else
        {
            return false
        }
        
    }

    //Check the Battery level
    class func checkBattertLevel() -> Bool {
        #if (TARGET_IPHONE_SIMULATOR)
            UIDevice.current.isBatteryMonitoringEnabled = true
            var batteryLevel = UIDevice.current.batteryLevel
            batteryLevel *= 100
            //change the minimum battery level
            if(batteryLevel > 3)
            {
                return true
            }
            else
            {
                self.showAlert("You need low battery power")
                return false
            }
        #else
            return true
        #endif
        
    }
    
    //Call Left slide menu
    class func LeftSideMenu(rootVC : UIViewController)
    {
        SideMenuManager.default.menuLeftNavigationController = rootVC.storyboard!.instantiateViewController(withIdentifier: "SideMenu") as? UISideMenuNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: rootVC.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: rootVC.navigationController!.view)
    }
    
    //Call Right slide menu
    class func RightSideMenu(rootVC : UIViewController)
    {
        SideMenuManager.default.menuRightNavigationController = rootVC.storyboard!.instantiateViewController(withIdentifier: "SideMenu") as? UISideMenuNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: rootVC.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: rootVC.navigationController!.view)
    }
    
    
    //MARK: Make cardview for all cell
    //Make card view on cell View
   class func viewBorderColor (ContentView : UIView)
    {
        ContentView.layer.borderColor = UIColor.white.cgColor
        ContentView.layer.borderWidth = 2.0
        ContentView.layer.cornerRadius = 8.0
    }
    class func AnimationShakeTextField(textField:UITextField){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 5, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 5, y: textField.center.y))
        textField.layer.add(animation, forKey: "position")
    }
    
    class func showAlertToast(title: String, message: String, type: Theme){
        
        let validationAlert = MessageView.viewFromNib(layout: .messageView)
        validationAlert.configureTheme(type)
        validationAlert.backgroundColor = UIColor.init(red: 33.0 / 255.0, green: 150.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
        validationAlert.configureDropShadow()
        
        var validationConfig = SwiftMessages.Config()
        validationConfig.duration = .automatic
        validationConfig.interactiveHide = true
        validationConfig.presentationStyle = .center
        
        validationAlert.configureContent(title: title, body: message)
        validationAlert.button?.isHidden = true
        SwiftMessages.hideAll()
        SwiftMessages.show(config: validationConfig, view: validationAlert)
    }
    //MARK: - No Internet handling
    class func changeLanguage(Language : String)
    {
        // This is done so that network calls now have the Accept-Language as "hi" (Using Alamofire) Check if you can remove these
        UserDefaults.standard.set([Language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Update the language by swaping bundle
        Bundle.setLanguage(Language)
        
        // Done to reintantiate the storyboards instantly
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
    }
   
}

