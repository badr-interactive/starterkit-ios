//
//  Utils.swift
//  Example
//
//  Created by Ade Septiadi on 8/31/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation
import Toaster
import SystemConfiguration
import GoogleSignIn
import FBSDKLoginKit
import Alamofire

class Utils{
    class func serializeError(_ data: Data, _ view: BaseViewController){
        let dataStr = String(data: data, encoding: String.Encoding.utf8)
        if (dataStr?.isEmpty)!{
            Toast(text: "Failed.").show()
        }else{
            do {
                let json = try JSONSerialization.jsonObject(with: (dataStr?.data(using: .utf8))!, options: []) as! NSDictionary
                if let message = json.value(forKey: "message") as? String {
                    Toast(text: "\(message)").show()
                }
            } catch {
                Toast(text: "Failed.").show()
            }
        }
    }
    
    class func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    class func getRectProgressDialog(controller: UIViewController) -> CGRect {
        let size = controller.view.frame.size.width/3
        return CGRect(
            x: ((controller.view.frame.size.width)/2)-(size/2),
            y: (controller.view.frame.size.height/2)-(size/2),
            width: size,
            height: size)
    }
    
    class func clearData(){
        Preference.init().setLoginState(value: false)
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        let googleLogin = GIDSignIn.sharedInstance()
        googleLogin?.disconnect()
        ProfileRealm.deleteprofile()
        clearCookie()
    }
    
    class func clearCookie(){
        let cookieJar = HTTPCookieStorage.shared
        
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
    
    class func getCert()->SecCertificate{
        let rootCertPath:String = Bundle.main.path(forResource: "dev.badr.co.id", ofType: "cer")!
        let rootCertData = NSData(contentsOfFile: rootCertPath)!
        let rootCert:SecCertificate = SecCertificateCreateWithData(nil, rootCertData)!
        
        return rootCert
    }
}
