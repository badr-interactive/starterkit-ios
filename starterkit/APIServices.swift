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
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Origin": Bundle.main.bundleIdentifier!
        ]
        print(urlApi+" "+String(describing: param))
        Alamofire.request(urlApi, method: .post, parameters: (param as! Parameters), encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch response.result {
            case .success:
                let jsonResult = response.result.value as! NSDictionary
                if jsonResult.value(forKey: "data") is NSDictionary{
                    objectResponse(baseController: view, response: jsonResult, method: method.hashValue)
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
    
    static func objectResponse(baseController: BaseViewController, response: NSDictionary, method: Int){
        if let message = response.value(forKey: "message") as? String{
            baseController.showToast(message)
        }
        switch method {
        case APIMethod.register.hashValue:
            if let dataDict = response.value(forKey: "data") as? NSDictionary{
                print(dataDict)
            }
            baseController.closeProgressDialog()
            baseController.dismiss(animated: true, completion: nil)
        case APIMethod.emailLogin.hashValue:
            if let dataDict = response.value(forKey: "data") as? NSDictionary{
                ProfileRealm.saveOrUpdate(profile: ProfileRealm.serializeprofile(dataDict))
                Preference.init().setLoginState(value: true)
            }
            baseController.closeProgressDialog()
            baseController.dismiss(animated: true, completion: nil)
        case APIMethod.socialLogin.hashValue:
            if let dataDict = response.value(forKey: "data") as? NSDictionary{
                ProfileRealm.saveOrUpdate(profile: ProfileRealm.serializeprofile(dataDict))
            }
            baseController.closeProgressDialog()
            baseController.dismiss(animated: true, completion: nil)
        case APIMethod.forgotPassword.hashValue:
            baseController.showToast("please open your email to verification code")
            baseController.closeProgressDialog()
            baseController.dismiss(animated: true, completion: nil)
        default:
            break
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
}
