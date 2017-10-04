//
//  UIView.swift
//  Example
//
//  Created by Ade Septiadi on 5/8/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
    /*
     Fungsi untuk membuat shadow pada view(seperti tampilan cardview pada android)
     */
    func dropShadow(scale: Bool = true) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 2
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    /*
     Fungsi untuk membuat corner dari view berbentuk rounded
     Parameter :
     @param rectCorner = object untuk menentuka sisi mana saja yang akan diround. contoh [.topLeft, .bottomRight]
     @param size = ukuran lengkung yang diinginkan. contoh : 1,2,..
     */
    func setRounded(_ rectCorner:UIRectCorner, _ size: CGFloat){
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: size, height: size)).cgPath
        
        self.layer.mask = rectShape
    }
}
