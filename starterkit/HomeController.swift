//
//  HomeController.swift
//  Example
//
//  Created by Ade Septiadi on 5/8/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import UIKit

class HomeController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var leftMenuButton: UIBarButtonItem!
    @IBOutlet weak var rightMenuButton: UIBarButtonItem!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var sectionInsets: UIEdgeInsets!
    
    let margin:CGFloat = 4.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initSideMenu(leftMenuButton, rightMenuButton)
        self.automaticallyAdjustsScrollViewInsets = false
        self.productCollectionView.delegate = self
        self.productCollectionView.dataSource = self
        self.sectionInsets = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
        setMarginCell(productCollectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Home"
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showToast("item ".appending(String(indexPath.row)))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionCell
        cell.layer.cornerRadius = 4
        cell.productImageHeight.constant = cell.layer.bounds.width
        cell.productLabel.text = "Product ".appending(String(indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (productCollectionView.frame.width/3)-(margin*1.8)
        
        return CGSize(width: width, height: UIScreen.main.bounds.height/4)
    }
    
    func setMarginCell(_ collectionView: UICollectionView){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = self.sectionInsets
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = margin*2
        collectionView.collectionViewLayout = layout
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
