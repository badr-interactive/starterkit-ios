//
//  LoginController.swift
//  Example
//
//  Created by Ade Septiadi on 5/10/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import FirebaseAuth

class LoginController: BaseViewController, UITextFieldDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var tabMenu: UISegmentedControl!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var forgetPassHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registerFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var forgotPassButton: UIButton!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    let register:Int = 1
    let signIn:Int = 0
    var selectedIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureURLSession()
        self.configureAlamoFire()
        // Do any additional setup after loading the view.
        setLayout()
        initiateGoogleSignin()
    }
    
    func initiateGoogleSignin(){
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func setLayout(){
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        tabMenu.selectedSegmentIndex = 0
        hideRegisterField()
        googleButton.setTitle(NSLocalizedString("signin_google", comment: "Authenticate").uppercased(), for: .normal)
        facebookButton.setTitle(NSLocalizedString("signin_facebook", comment: "Authenticate").uppercased(), for: .normal)
        forgotPassButton.setTitle(NSLocalizedString("forget_password", comment: "Authenticate"), for: .normal)
        emailField.setImagePlaceHolder(image: "ic_email_placeholder")
        passwordField.setImagePlaceHolder(image: "ic_password_placeholder")
        confirmPasswordField.setImagePlaceHolder(image: "ic_password_placeholder")
        passwordField.placeholder = NSLocalizedString("password", comment: "Authenticate")
        confirmPasswordField.placeholder = NSLocalizedString("confirm_password", comment: "Authenticate")
        tabMenu.setTitle(NSLocalizedString("register", comment: "Authenticate"), forSegmentAt: 1)
        tabMenu.setTitle(NSLocalizedString("signin", comment: "Authenticate"), forSegmentAt: 0)
    }
    
    @IBAction func onSelectedChange(_ sender: Any) {
        switch tabMenu.selectedSegmentIndex {
        case signIn:
            self.navigationItem.title = NSLocalizedString("signin", comment: "Authenticate")
            selectedIndex = signIn
            hideRegisterField()
        //            Preference.init().setPreferenceBool(Preference.isFromRegister, value: false)
        case register:
            self.navigationItem.title = NSLocalizedString("register", comment: "Authenticate")
            selectedIndex = register
            showRegisterField()
        //            Preference.init().setPreferenceBool(Preference.isFromRegister, value: true)
        default:
            break
        }
    }
    
    @IBAction func facebookLogin(_ sender: UIButton) {
        if Utils.isInternetAvailable(){
            self.showProgress()
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    if (fbloginresult.grantedPermissions == nil) == false{
                        if(fbloginresult.grantedPermissions.contains("email"))
                        {
                            self.getFBUserData()
                        }
                    }else{
                        self.closeProgressDialog()
                        self.showToast("Login canceled.")
                    }
                }else{
                    self.closeProgressDialog()
                    self.showToast("\(String(describing: error?.localizedDescription))")
                }
            }
        }else{
            self.showToast(NSLocalizedString("no_internet", comment: "Dialog"))
        }
    }
    
    func getFBUserData(){
        self.closeProgressDialog()
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    if let dictionary = result as? [String: Any] {
                        var email:String = ""
                        if dictionary["email"] is String{
                            email = dictionary["email"] as! String
                        }
                        let param = ["provider":"facebook",
                                     "email":email,
                                     "token":FBSDKAccessToken.current().tokenString,
                                     "fcm_token":"12345678900000"] as [String : Any]
                        self.callPOSTService(APIMethod.socialLogin, param)
                    }
                }else{
                    self.showToast("\(String(describing: error?.localizedDescription))")
                }
            })
        }
    }
    
    //google login
    @IBAction func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            self.showToast(error.localizedDescription)
            return
        }
        
        showProgress()
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            self.closeProgressDialog()
            if (error == nil){
                if user != nil {
                    let param = ["provider":"google",
                                 "email":user?.email! ?? "",
                                 "token":authentication.idToken  ?? "",
                                 "fcm_token":"12345678900000"] as [String : Any]
                    if Utils.isInternetAvailable(){
                        self.showProgress()
                        APIService.transmitDataPOST(self, APIMethod.socialLogin, param)
                    }else{
                        self.showToast(NSLocalizedString("no_internet", comment: ""))
                    }
                }
            }else{
                self.closeProgressDialog()
                self.showToast("\(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                        withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func hideRegisterField(){
        registerFieldHeight.constant = 0
        confirmPasswordField.isHidden = true
        forgotPassButton.isHidden = false
        forgetPassHeight.constant = 38
        signButton.setTitle(NSLocalizedString("signin", comment: "Authenticate"), for: .normal)
    }
    
    func showRegisterField(){
        registerFieldHeight.constant = 40
        confirmPasswordField.isHidden = false
        forgotPassButton.isHidden = true
        forgetPassHeight.constant = 0
        signButton.setTitle(NSLocalizedString("register", comment: "Authenticate"), for: .normal)
    }
    
    @IBAction func emailSignIn(_ sender: Any) {
        if formValidation().isEmpty{
            if selectedIndex == signIn{
                let params = ["email":emailField.text ?? "",
                              "password":passwordField.text ?? ""] as [String : Any]
                //                              "device_id": UIDevice.current.identifierForVendor!.uuidString,
                //                              "device_name": UIDevice.current.modelName,
                //                              "fcm_token":""] as [String : Any]
                //                              InstanceID.instanceID().token() ?? ""],
                //                               "device_type":"2"] as [String : Any]
                if Utils.isInternetAvailable(){
                    showProgress()
                    APIService.transmitDataPOST(self, APIMethod.emailLogin, params)
                }else{
                    self.showToast(NSLocalizedString("no_internet", comment: ""))
                }
            }else{
                let param  = ["email":emailField.text ?? "",
                              "password":passwordField.text ?? "",
                              "confirmation_password":confirmPasswordField.text ?? ""] as [String : Any]
                if Utils.isInternetAvailable(){
                    showProgress()
                    //                    Preference.init().setPreferenceBool(Preference.isFromRegister, value: true)
                    APIService.transmitDataPOST(self, APIMethod.register, param)
                }else{
                    self.showToast(NSLocalizedString("no_internet", comment: ""))
                }
            }
        }else{
            self.showToast(formValidation())
        }
    }
    
    func formValidation()->String{
        var error = ""
        if (emailField.text?.isEmpty)!{
            if error.isEmpty{
                error.append(NSLocalizedString("err_email_empty", comment: "Authenticate"))
            }else{
                error.append("\n".appending(NSLocalizedString("err_email_empty", comment: "Authenticate")))
            }
        }else{
            if !isValidEmail(emailField.text!){
                if error.isEmpty{
                    error.append(NSLocalizedString("err_invalid_email", comment: "Authenticate"))
                }else{
                    error.append("\n".appending(NSLocalizedString("err_invalid_email", comment: "Authenticate")))
                }
            }
        }
        
        if (passwordField.text?.isEmpty)!{
            if error.isEmpty{
                error.append(NSLocalizedString("err_password_empty", comment: "Authenticate"))
            }else{
                error.append("\n".appending(NSLocalizedString("err_password_empty", comment: "Authenticate")))
            }
        }
        
        if selectedIndex == register{
            if (confirmPasswordField.text?.isEmpty)!{
                if error.isEmpty{
                    error.append(NSLocalizedString("err_password_empty", comment: "Authenticate"))
                }else{
                    error.append("\n".appending(NSLocalizedString("err_password_empty", comment: "Authenticate")))
                }
            }
        }
        
        return error
    }
    
    func isValidEmail(_ emailStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }else if textField == passwordField{
            confirmPasswordField.becomeFirstResponder()
        }else if textField == confirmPasswordField{
            textField.resignFirstResponder()
            emailSignIn(0)
        }
        
        return true
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
