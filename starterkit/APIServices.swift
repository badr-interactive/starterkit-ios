//
//  APIServices.swift
//  Example
//
//  Created by Ade Septiadi on 8/31/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation
import Toaster
import Alamofire

class APIService{
    
    static func transmitDataPOST(_ view: BaseViewController, _ method: APIMethod, _ param:Any){
        let urlApi = getUrlAPI(enumMethod: method.rawValue)
        
        print(urlApi+" "+String(describing: param).appending("\n"+getHeader().description))
        Alamofire.request(urlApi, method: .post, parameters: (param as! Parameters), encoding: JSONEncoding.default, headers: getHeader()).responseJSON { response in
            switch response.result {
            case .success:
                let jsonResult = response.result.value as! NSDictionary
                if jsonResult.value(forKey: "data") is NSDictionary{
                    objectResponse(view, jsonResult, method.hashValue)
                }else{
                    view.closeProgressDialog()
                    if let errorMsg = jsonResult.value(forKey: "message") as? String{
                        Utils.clearData()
                        view.showToast(errorMsg)
                    }
                }
                break
            case .failure( _):
                failedHandler(response.data!, view, method)
                break
            }
        }
    }
    
    static func objectResponse(_ controller: BaseViewController, _ response: NSDictionary, _ method: Int){
        var isFinish = false
        if let message = response.value(forKey: "message") as? String{
            controller.showToast(message)
        }
        switch method {
        case APIMethod.register.hashValue:
            if let dataDict = response.value(forKey: "data") as? NSDictionary{
                print(dataDict)
            }
            isFinish = true
        case APIMethod.emailLogin.hashValue:
            if let dataDict = response.value(forKey: "data") as? NSDictionary{
                ProfileRealm.saveOrUpdate(profile: ProfileRealm.serializeprofile(dataDict))
                Preference.init().setBoolPref(Preference.loginState, true)
            }
            isFinish = true
        case APIMethod.socialLogin.hashValue:
            if let dataDict = response.value(forKey: "data") as? NSDictionary{
                ProfileRealm.saveOrUpdate(profile: ProfileRealm.serializeprofile(dataDict))
                Preference.init().setBoolPref(Preference.loginState, true)
            }
            isFinish = true
        case APIMethod.forgotPassword.hashValue:
            controller.showToast("please open your email to verification code")
            isFinish = true
        default:
            break
        }
        
        if isFinish{
            controller.closeProgressDialog()
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    private class func failedHandler(_ responseData:Data, _ view:BaseViewController, _ method:APIMethod){
        view.closeProgressDialog()
        if method == APIMethod.socialLogin{
            Utils.clearData()
            Utils.clearCookie()
        }
        
        Utils.serializeError(responseData, view)
    }
    
    private class func getUrlAPI(enumMethod: String)->String{
        return Constants.API_URL+enumMethod
    }
    
    private class func getHeader()->HTTPHeaders{
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as! String
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let OSVersion = "IOS/".appending(UIDevice.current.systemVersion)
        let deviceModelName = UIDevice.current.modelName.appending(")")
        return ["Content-Type": "application/json",
                "Origin": appName,
                "User-Agent": appName.appending("("+appVersion+";").appending(OSVersion+";").appending(deviceModelName)
        ]
    }
}
