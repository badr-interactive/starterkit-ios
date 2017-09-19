//
//  UIViewController.swift
//  Example
//
//  Created by Ade Septiadi on 5/8/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation
import UIKit
import GradientCircularProgress
import Toaster
import Alamofire

class BaseViewController: UIViewController, URLSessionDelegate, URLSessionTaskDelegate{
    var progressBar: GradientCircularProgress!
    var progressView: UIView!
    var urlSession: URLSession!
    var serverTrustPolicy: ServerTrustPolicy!
    var serverTrustPolicies: [String: ServerTrustPolicy]!
    var afManager: SessionManager!
    
    override var prefersStatusBarHidden: Bool{
//        if Preference.init().getBoolPref(Preference.loginState)!{ return true }
        return true
    }
}

extension BaseViewController{
    
    func initSideMenu(_ leftMenu: UIBarButtonItem, _ rightMenu: UIBarButtonItem) {
//        self.revealViewController().rightViewRevealWidth = width
        leftMenu.target = self.revealViewController()
        leftMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        rightMenu.target = self.revealViewController()
        rightMenu.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func initSideMenu(leftMenu: UIBarButtonItem) {
//        self.revealViewController().rightViewRevealWidth = width
        leftMenu.target = self.revealViewController()
        leftMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func initSideMenu(rightMenu: UIBarButtonItem) {
//        self.revealViewController().rightViewRevealWidth = width
        rightMenu.target = self.revealViewController()
        rightMenu.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func showProgress(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.progressBar = GradientCircularProgress()
        self.progressView = progressBar.show(frame: Utils.getRectProgressDialog(controller: self), message: NSLocalizedString("please_wait", comment: "Dialog"), style: ProgressDialogStyle())
        progressView?.layer.cornerRadius = 10.0
        progressView?.tag = 99
        if progressView != nil {
            view.addSubview(progressView!)
        }
    }
    
    func showToast(_ message:String){
        Toast(text: message).show()
    }
    
    func closeProgressDialog(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if self.progressView != nil {
            self.progressBar.dismiss(progress: progressView)
        }
    }
    
    func configureURLSession() {
        self.urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }
    
    func configureAlamoFire() {
        self.serverTrustPolicy = ServerTrustPolicy.pinCertificates(
            // Getting the certificate from the certificate data
            certificates: [Utils.getCert()],
            // Choose to validate the complete certificate chain, not only the certificate itself
            validateCertificateChain: true,
            // Check that the certificate mathes the host who provided it
            validateHost: true
        )
        
        self.serverTrustPolicies = [
            "dev.badr.co.id": self.serverTrustPolicy!
        ]
        
        self.afManager = SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: self.serverTrustPolicies)
        )
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let serverTrust = challenge.protectionSpace.serverTrust
        let certificate = SecTrustGetCertificateAtIndex(serverTrust!, 0)
        
        // Set SSL policies for domain name check
        let policies = NSMutableArray();
        policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString)))
        SecTrustSetPolicies(serverTrust!, policies);
        
        // Evaluate server certificate
        var result: SecTrustResultType = SecTrustResultType(rawValue: 0)!
        SecTrustEvaluate(serverTrust!, &result)
        
        
        // Get local and remote cert data
        let remoteCertificateData:NSData = SecCertificateCopyData(certificate!)
        let pathToCert = Bundle.main.path(forResource: "dev.badr.co.id", ofType: "cer")
        let localCertificate:NSData = NSData(contentsOfFile: pathToCert!)!
        
        if (remoteCertificateData.isEqual(to: localCertificate as Data)) {
            let credential:URLCredential = URLCredential(trust: serverTrust!)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    func callPOSTService(_ method:APIMethod, _ param:Any){
        configureAlamoFire()
        if Utils.isInternetAvailable(){
            self.showProgress()
            APIService.transmitDataPOST(self, method, param)
        }else{
            self.showToast(NSLocalizedString("no_internet", comment: ""))
        }
    }
    
    
}
