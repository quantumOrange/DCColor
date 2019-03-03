//
//  DCGradientView.swift
//  DCColor
//
//  Created by David Crooks on 04/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit
import DCCoreGraphics

fileprivate let debug = false

@IBDesignable
class DCGradientView: UIView {
    
    @IBInspectable var iColor:UIColor {
        get {
            return color.uiColor
        }
        set {
            color = newValue
        }

    }
    
    @IBInspectable var iChannel:Int {
        get {
            return channel.rawValue
        }
        set {
            if let c = ColorChannel(rawValue: newValue) {
                channel = c
            }
        }
    }
    
    var  channel:ColorChannel = .red
    
    var color:Color = UIColor.magenta {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var positionOfHandel:CGPoint {
        get {
            return CGPoint(x:bounds.width * color.value(forChannel: channel), y:0.5*bounds.height)
        }
        set {
            let v = newValue.x / self.bounds.width
            color = color.colorWith(channel: channel, value: v)
        }
    }

    override func draw(_ rect: CGRect) {
        
        print("bounds \(bounds) , frame \(frame) , rect \(rect)")
        
        guard  let context = UIGraphicsGetCurrentContext() else { return }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        switch channel {
            
            case .hue:
                context.drawLinearHueGradient(rect:rect,color:color)
            
            case .alpha:
                
                //draw gray checkers before drawing gradient
                let dx = rect.height*0.5
                
                let n_squares = Int(rect.width/dx)
                
                let positions = (0...n_squares).map{ ( CGFloat($0) ,CGFloat( $0 %  2 )) }.map{ CGPoint(x: dx*$0.0, y: dx*$0.1) }
                
                let squares = positions.map{ CGRect(origin: rect.origin + $0, size: CGSize(width:dx,height:dx)) }
                context.setFillColor(UIColor.gray.cgColor)
                context.addRects(squares)
                context.drawPath(using: .fill)
                
                //we still want to draw a gradient
                fallthrough
            
            default:
                
                //draw a liniear gradient for all excpept .hue
                let colors = [color.colorWith(channel: channel, value: 0.0).uiColor.cgColor, color.colorWith(channel: channel, value: 1.0).uiColor.cgColor] as CFArray
                
                if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors , locations:nil)  {
                    context.drawLinearGradient(gradient, start: rect.leftCenter, end: rect.rightCenter, options: .drawsAfterEndLocation)
                }
            
        }
        
        //draw handel
        if debug {
            context.setFillColor(UIColor.black.cgColor)
            var handel = CGRect(origin:CGPoint.zero,size:CGSize(width:10,height:10))
            handel.center = positionOfHandel + rect.origin
            context.addRect(handel)
            context.drawPath(using: .fill)
        }
        
    }
    
}
