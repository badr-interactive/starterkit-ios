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
    let CERTIFICATE_NAME = "dev.badr.co.id"
    
    override var prefersStatusBarHidden: Bool{
//        if Preference.init().getBoolPref(Preference.loginState)!{ return true }
        return false
    }
}

extension BaseViewController{
    
    /*
     Fungsi initialisasi left dan right bar button item untuk membuat menu sisi(kanan dan kiri)
     Parameter :
     @param leftMenu => View UIBarButtonItem
     @param rightMenu = View UIBarButtonItem
     */
    func initSideMenu(_ leftMenu: UIBarButtonItem, _ rightMenu: UIBarButtonItem) {
//        self.revealViewController().rightViewRevealWidth = width
        leftMenu.target = self.revealViewController()
        leftMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        rightMenu.target = self.revealViewController()
        rightMenu.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    /*
     Fungsi initialisasi left dan right bar button item untuk membuat menu sisi kiri
     Parameter :
     @param leftMenu => View UIBarButtonItem
     */
    func initSideMenu(leftMenu: UIBarButtonItem) {
//        self.revealViewController().rightViewRevealWidth = width
        leftMenu.target = self.revealViewController()
        leftMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    /*
     Fungsi initialisasi left dan right bar button item untuk membuat menu sisi kanan
     Parameter :
     @param rightMenu = View UIBarButtonItem
     */
    func initSideMenu(rightMenu: UIBarButtonItem) {
//        self.revealViewController().rightViewRevealWidth = width
        rightMenu.target = self.revealViewController()
        rightMenu.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    /*
     Fungsi Untuk menampilkan progress dialog dan activity indicator di statusbar secara global.
     Progress dialog menggunakan library GradientCircularProgress
     */
    func showProgress(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.progressBar = GradientCircularProgress()
        self.progressView = progressBar.show(frame: Utils.getRectProgressDialog(self), message: NSLocalizedString("please_wait", comment: "Dialog"), style: ProgressDialogStyle())
        progressView?.layer.cornerRadius = 10.0
        progressView?.tag = 99
        if progressView != nil {
            view.addSubview(progressView!)
        }
    }
    
    /*
     Fungsi Untuk mematikan dan menampilkan progress dialog dan activity indicator di statusbar secara global
     */
    func closeProgressDialog(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if self.progressView != nil {
            self.progressBar.dismiss(progress: progressView)
        }
    }
    
    /*
     Fungsi Untuk menampilkan Toast(text dialog)
     */
    func showToast(_ message:String){
        Toast(text: message).show()
    }
    
    func configureURLSession() {
        self.urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }
    
    /*
     Fungsi Untuk konfigirasi Alamofire dengan pinning self signing certificate
     */
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
            CERTIFICATE_NAME : self.serverTrustPolicy!
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
        let pathToCert = Bundle.main.path(forResource: CERTIFICATE_NAME, ofType: "cer")
        let localCertificate:NSData = NSData(contentsOfFile: pathToCert!)!
        
        if (remoteCertificateData.isEqual(to: localCertificate as Data)) {
            let credential:URLCredential = URLCredential(trust: serverTrust!)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    /*
     Fungsi untuk memanggil api dengan metode POST
     Param :
     @param method =  method yang dipanggil(berupa object enum)
     @param param = Parameter yang dibutuhkan di request bodynya
     */
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
