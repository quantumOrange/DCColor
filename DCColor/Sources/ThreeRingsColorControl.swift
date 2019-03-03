//
//  ThreeRingsColorControl.swift
//  DCColor
//
//  Created by David Crooks on 07/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit
import DCCoreGraphics

@IBDesignable
public class ThreeRingsColorControl: DCColorControl {

    @IBInspectable public var wheelThickness:CGFloat = 20.0
    @IBInspectable public var space:CGFloat = 5.0
    
    
    
    override public func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let radius =  0.5*rect.width
        let r2 = radius - space - wheelThickness
        let r3 = radius - 2.0*space - 2.0*wheelThickness
        
        
       // let da:CGFloat = 0.25 * r2 / wheelThickness / twoPi
       // let da2:CGFloat = 0.25 * r3 / wheelThickness / twoPi
        let da:CGFloat = 0.13
        let da2:CGFloat = 0.2
        
        context.drawColorWheel(center: rect.center, radius: radius, thickness: wheelThickness, color:color , channel: .hue)
        context.drawColorWheel(center: rect.center, radius: r2, thickness: wheelThickness, color:color , channel: .saturation, angularOffset:da, angularMargin:2*da)
        
        
        context.drawColorWheel(center: rect.center, radius: r3, thickness: wheelThickness, color:color , channel: .brightness,angularOffset:da2, angularMargin:2*da2)
        
        context.setFillColor(color.uiColor.cgColor)
        context.addCircle(center: rect.center, radius: radius - 3.0*space - 3.0*wheelThickness)
        context.drawPath(using: .fill)
    }
    

}
