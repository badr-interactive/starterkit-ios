//
//  MenuController.swift
//  Example
//
//  Created by Ade Septiadi on 5/9/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import UIKit
import AlamofireImage

class MenuController: UITableViewController {
    var headerView: ImageHeaderView!
    @IBOutlet weak var loginLabel: UILabel!
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = ImageHeaderView.loadNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func goToProfile(){
        let story = UIStoryboard(name: "Profile", bundle: nil)
        present(story.instantiateViewController(withIdentifier: "ProfileController"), animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Preference.init().getBoolPref(Preference.loginState)==nil{
            Preference.init().setBoolPref(Preference.loginState, false)
            self.tableView.tableHeaderView = nil
        }else{
            if Preference.init().getBoolPref(Preference.loginState)!{
                self.tableView.tableHeaderView = headerView
                let profile = ProfileRealm.getData()
                headerView.profileName.text = profile.name
                headerView.profileEmail.text = profile.email
                if !(profile.photo.isNilOrEmpty()){
                    headerView.profileImage.af_setImage(withURL: URL(string: profile.photo)!)
                }
                loginLabel.text = "Logout"
            }else{
                self.tableView.tableHeaderView = nil
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(String(indexPath.section)+" - "+String(indexPath.row))
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                if Preference.init().getBoolPref(Preference.loginState)! {
                    self.tableView.tableHeaderView = nil
                    loginLabel.text = "Login"
                    Preference.init().setBoolPref(Preference.loginState, false)
                    Utils.clearData()
                    self.performSegue(withIdentifier: "openHome", sender: nil)
                }else{
                    goToLogin()
                }
                break
            default:
                break
            }
        default:
            break
        }
    }
    
    private func goToLogin(){
        let story = UIStoryboard(name: "Authenticate", bundle: nil)
        let loginNavBar = story.instantiateViewController(withIdentifier: "LoginNavBar") as! UINavigationController
        present(loginNavBar, animated: true, completion: nil)
    }
    
}
