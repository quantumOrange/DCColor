//
//  DCHueWheel.swift
//  DCColor
//
//  Created by David Crooks on 04/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit
import DCCoreGraphics


@IBDesignable
class DCHueWheel: UIView {

    @IBInspectable var wheelWidth:CGFloat = 100.0
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
 
        let center = rect.center
        let radius = 0.5*rect.width

        context.drawHueWheel(center: center, radius: radius, thickness: wheelWidth)
    }
}
