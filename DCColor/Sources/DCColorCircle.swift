//
//  DCColorCircle.swift
//  DCColor
//
//  Created by David Crooks on 04/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit
import DCCoreGraphics

@IBDesignable
class DCColorCircle: UIView {

    @IBInspectable var brightnessLevel:CGFloat = 255
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    var brightness:CGFloat {
        get {
            return brightnessLevel/255.0
        }
        set {
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard  let context = UIGraphicsGetCurrentContext() else { return }
        let center = rect.center
        let radius = 0.5*rect.width
        
        context.drawColorCircle(center: center, radius: radius, brightness: brightness)
    }
    
    
}
