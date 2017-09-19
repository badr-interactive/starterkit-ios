//
//  JavaViewController.swift
//  Example
//
//  Created by Ade Septiadi on 5/5/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import UIKit
import Floaty

class FabViewController: BaseViewController {
    @IBOutlet weak var leftMenuButton: UIBarButtonItem!
    @IBOutlet weak var rightMenuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
        // Do any additional setup after loading the view.
        self.initSideMenu(leftMenuButton, rightMenuButton)
        let floaty = Floaty()
        floaty.addItem("Hello", icon: UIImage(named:"ic_perm_identity"))
        self.view.addSubview(floaty)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setNavigationBarItem()
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
