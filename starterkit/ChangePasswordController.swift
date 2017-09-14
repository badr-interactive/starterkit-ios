//
//  ChangePasswordController.swift
//  Example
//
//  Created by Ade Septiadi on 9/12/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import UIKit

class ChangePasswordController: BaseViewController {
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var reTypePasswordTextField: UITextField!
    var code = ""
    var fromEmail = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        codeTextField.text = code
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
