//
//  ForgotPasswordController.swift
//  Example
//
//  Created by Ade Septiadi on 9/12/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import UIKit

class ForgotPasswordController: BaseViewController{
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: Any) {
        if Utils.isInternetAvailable(){
            showProgress()
            let param = ["email":emailTextField.text ?? ""] as [String:Any]
            APIService.transmitDataPOST(self, APIMethod.forgotPassword, param)
        }else{
            showToast(NSLocalizedString("no_internet", comment: ""))
        }
    }
    
    func goToChangePage(){
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "changePassword") as! UINavigationController), animated: true, completion: nil)
    }
    
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
