//
//  DCHueWheelControl.swift
//  DCColor
//
//  Created by David Crooks on 04/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit
import DCCoreGraphics
@IBDesignable
public class DCHueWheelControl: DCColorControl {
    
    @IBInspectable public var wheelThickness:CGFloat = 20.0
    @IBInspectable public var space:CGFloat = 5.0
    @IBInspectable public var thumbRadius:CGFloat = 15.0
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func awakeFromNib() {
        setup()
    }
    
    public override func prepareForInterfaceBuilder() {
        setup()
    }
    
    private var isSetup = false
    
    
    var hueThumb:DCSwatch!
    var sbThumb:DCSwatch!
    
    private func setup(){
        if isSetup { return }
       
        hueThumb = DCSwatch(frame:CGRect.square(center:positionOfHue, with:2.0*thumbRadius ))
        hueThumb.color = color
        hueThumb.isUserInteractionEnabled = false
        addSubview(hueThumb)
        
        sbThumb = DCSwatch(frame: CGRect.square(center:positionOfSB, with:2.0*thumbRadius ))
        sbThumb.color = color
        sbThumb.isUserInteractionEnabled = false
        addSubview(sbThumb)
        
        isSetup = true
    }

        
    //MARK:- Thumb positions
    
    private var positionOfHue:CGPoint {
        get {
            
            let radius =  0.5*self.bounds.size.width - 0.5*wheelThickness
            let angle =  color.hsb.hue
            
            return CGPoint(angle: angle, radius: radius)
        
        }
        set {
            
           // let radius =  0.5*self.bounds.size.width - 0.5*wheelThickness
           // let angle = twoPi*color.hue
            
            let hue = newValue.angle / (2.0*CGFloat.pi)
            
            color = color.colorWith(channel: .hue, value: hue)
            sendActions(for: .valueChanged)
        }
    }
    
    
    private var positionOfSB:CGPoint {
        get {
            return CGPoint(x:0.0, y: 0.0)
        }
        set {
            let v = newValue - bounds.center
            let angle = v.angle - color.hsb.hue
            let radius = v.length()
            let range = ClosedRange<CGFloat>( uncheckedBounds: (lower:0.0,upper:colorCircleRadius))
            
            if !range.contains(radius) {
                return
            }
           
            let value = mapRange(fromRange:range, toRange:CGFloat.unitRange)(radius)
            
            //check zone:
            let third = 2.0*CGFloat.pi/3.0
            
            var edgeColor:Color
            var centerColor  = color.colorWith(channel: .saturation, value: 0.5)
            centerColor = centerColor.colorWith(channel: .brightness, value: 0.5)
            
            if angle > 0 &&  angle < third {
                //1: 0 -> third == color to black
                let t = 1.0 - angle/third
                
                edgeColor = color.colorWith(channel: .saturation, value: t)
                edgeColor = edgeColor.colorWith(channel: .brightness, value: t)
            }
            else if angle >= third  &&   angle < 2.0*third {
                //2: third -> 2 third ==  gray (black to white)
                let t = (angle - third)/third
                
                edgeColor = color.colorWith(channel: .saturation, value: 0.0)
                edgeColor = edgeColor.colorWith(channel: .brightness, value: t)
            }
            else {
                //3: 2 third -> whole == white to color
                let t = (angle - 2*third)/third
                
                edgeColor = color.colorWith(channel: .saturation, value: t)
                edgeColor = edgeColor.colorWith(channel: .brightness, value: 1.0)
            }
            //frame.insetBy(dx: 10.0, dy: 10.0)
            
            color = lerp(from:centerColor.rgb, to:edgeColor.rgb, value: value)
            sendActions(for: .valueChanged)
        }
    }

        
    var colorCircleRadius:CGFloat {
        get {
            return hueWheelRadius - space - wheelThickness
        }
    }
    
    var hueWheelRadius:CGFloat {
        get {
            return 0.5*bounds.size.width
        }
    }
    
    override public func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
       
        context.drawHueWheel(center: rect.center, radius: hueWheelRadius, thickness: wheelThickness)
        context.drawColorCircle(center: rect.center, radius: colorCircleRadius, hue: color.hsb.hue)
        
    }
    

}
