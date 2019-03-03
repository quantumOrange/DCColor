//
//  DynamicSwatch.swift
//  DCColor
//
//  Created by David Crooks on 22/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit



enum DynmaicSwatchType:Int {
    case black = 0, hueMinus,brightness, huePlus,   white
}


@IBDesignable
class DynamicSwatch: DCSwatchButton {
    
    var type:DynmaicSwatchType
    init(color: Color, radius: CGFloat,type:DynmaicSwatchType) {
        self.type = type
        super.init(color: color, radius: radius)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        type = .black
        
        super.init(coder: aDecoder)
    }
    
    let hueShift:CGFloat =  60.0/360.0 * .pi
    let minColorfulness:CGFloat = 0.25
    
    func setSwatchColor(for paintColor:Color ) {
        
        func colorfulness(_ color:Color) -> Color {
            var newColor = paintColor
            if newColor.hsb.brightness < minColorfulness {
                newColor = newColor.colorWith(channel: .brightness, value: minColorfulness)
            }
            if newColor.hsb.saturation < minColorfulness {
                newColor = newColor.colorWith(channel: .saturation, value: minColorfulness)
            }
            return newColor
        }
        
        switch self.type {
        case .black:
            color = UIColor.black
        case .white:
            color = UIColor.white
        case .huePlus:
            color = colorfulness(paintColor.colorWith(channel: .hue, value: paintColor.hsb.hue + hueShift))
        case .hueMinus:
            color = colorfulness(paintColor.colorWith(channel: .hue, value: paintColor.hsb.hue - hueShift))
        case .brightness:
            let newColor = paintColor.colorWith(channel: .brightness, value: 1.0)
            color = newColor.colorWith(channel: .saturation, value: 1.0)
           
        }
    }
    
}

