//
//  UITextField.swift
//  Example
//
//  Created by Ade Septiadi on 8/31/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    func setImagePlaceHolder(image: String){
        self.leftViewMode = UITextFieldViewMode.always
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.center = CGPoint(x: leftView.frame.width/2, y: leftView.frame.height/2)
        leftView.addSubview(imageView)
        self.leftView = leftView
    }
}
