//
//  ProfileController.swift
//  Example
//
//  Created by Ade Septiadi on 5/12/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import UIKit

class ProfileController: BaseViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var detailView: UIView!
    
    var profile:Profile!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        self.automaticallyAdjustsScrollViewInsets = false
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.height/2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        bind()
        // Do any additional setup after loading the view.
    }
    
    /*
     Menampilkan data user pada layout profile
     */
    func bind(){
        self.profile = ProfileRealm.getData()
        if self.profile != nil{
            self.profileName.text = profile.name
            self.profileEmail.text = profile.email
            if !(profile.photo.isNilOrEmpty()){
                self.profileImage.af_setImage(withURL: URL(string: profile.photo)!)
            }
        }
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
