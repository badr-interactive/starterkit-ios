//
//  ProgressDialogStyle.swift
//  Cozer
//
//  Created by Ade Septiadi on 3/22/17.
//  Copyright © 2017 Ade Septiadi. All rights reserved.
//

import Foundation
import GradientCircularProgress

public struct ProgressDialogStyle : StyleProperty {
    /*** style properties **********************************************************************************/
    
    // Progress Size
    public var progressSize: CGFloat = 80
    
    // Gradient Circular
    public var arcLineWidth: CGFloat = 2.0
    public var startArcColor: UIColor = UIColor.white
    public var endArcColor: UIColor = UIColor.blue
    
    // Base Circular
    public var baseLineWidth: CGFloat? = 2.0
    public var baseArcColor: UIColor? = UIColor.white
    
    // Ratio
    public var ratioLabelFont: UIFont? = UIFont(name: "Avenir-Black", size: 8.0)
    public var ratioLabelFontColor: UIColor? = UIColor.white
    
    // Message
    public var messageLabelFont: UIFont? = UIFont.systemFont(ofSize: 8.0)
    public var messageLabelFontColor: UIColor? = UIColor.black
    
    // Background
    public var backgroundStyle: BackgroundStyles = .light
    
    // Dismiss
    public var dismissTimeInterval: Double? = 0.0 // 'nil' for default setting.
    
    /*** style properties **********************************************************************************/
    
    public init() {}
}
