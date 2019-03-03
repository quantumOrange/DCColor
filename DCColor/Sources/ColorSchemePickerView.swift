//
//  ColorSchemePickerView.swift
//  PaintLab
//
//  Created by David Crooks on 21/04/2015.
//  Copyright (c) 2015 David Crooks. All rights reserved.
//

import UIKit
import DCCoreGraphics
@IBDesignable
class ColorSchemePickerView: DCColorControl {
   
    
    //MARK:- Initialization
    
    override init(frame: CGRect) {
      
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
      
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        print("hello")
        setup()
    }
    override func prepareForInterfaceBuilder() {
        setup()
        colorScheme = defaultColorScheme
    }
    
    var visualEffectView:UIVisualEffectView!

    
    var hasSetup = false
    func setup() {
        if hasSetup { return }
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
       
        visualEffectView  = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = self.bounds
        visualEffectView.isUserInteractionEnabled = false
        let maskPath = UIBezierPath(ovalIn:bounds)
        let mask = CAShapeLayer()
        mask.path = maskPath.cgPath
        visualEffectView.layer.mask = mask
        
        self.addSubview(visualEffectView)
        colorScheme = defaultColorScheme
        hasSetup = true
    }
    
    
    var defaultColorScheme:[Color] {
        return (0..<12).map{ CGFloat($0)/12.0 }.map{ UIColor(hue: $0, saturation: 0.85, brightness: 0.95, alpha: 1.0)}
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    let swatchRadialSpace:CGFloat = 150.0
    var swatchAngularSpacing:CGFloat = 0.0
    var numberOfSegments:Int = 0 //total number of arc segments around circle
    var clostestDistance:CGFloat = 200.0
    var nextClostestDistance:CGFloat = 200.0
    var positionOfClosestSwatch = -1
    var closestSwatch:DCSwatch?
    var maxSelectionDistance:CGFloat = 70.0
    var minSelectionDifferance:CGFloat = 8.0
    
    
    //MARK:- Touch
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        clostestDistance = 200.0
        closestSwatch = nil
        positionOfClosestSwatch = -1
        
        return true
    }
    
    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let p = touch.location(in: self)
            
        let gestureDist = p.distanceTo(self.bounds.center)
        var  factor =  2.0 * gestureDist /  swatchRadialSpace
        if factor > 1.0 {
            factor = 1.0
        }
        clostestDistance = 200.0
        nextClostestDistance = 200.0
        closestSwatch = nil
        positionOfClosestSwatch = -1
        for index in 0..<swatches.count {
            let swatch = swatches[index]
            let trueCenter =  swatch.convert(swatch.bounds.center, to: self)
            let trueDistance = trueCenter.distanceTo(p)
            if trueDistance < clostestDistance {
                nextClostestDistance = clostestDistance
                clostestDistance = trueDistance
                positionOfClosestSwatch = index
                closestSwatch = swatch
            }
        }
        
        
        
        
        if let _ = closestSwatch
        {
            for index in 0..<self.swatches.count
            {
                let swatch = self.swatches[index]
                let trueCenter =  swatch.convert(swatch.bounds.center, to: self)
                let trueDistance = trueCenter.distanceTo(p)
                let originalSwatchCenter = self.centerPositionForSwatchInPostion(index)
                
                let distanceFactor =   clamp(value: 1.0 - trueDistance/self.swatchRadialSpace  ,minimum:0.0 , maximum: 1.0)
                // let distanceFactor =   clamp(0.0 , max: 1.0,value: 1.0-trueDistance/self.swatchRadialSpace)
                
                let distanceOfGestureToPickerCenter = clamp(value: bounds.center.distanceTo(p)/self.swatchRadialSpace, minimum:0.0 , maximum: 1.0)
                let d = distanceOfGestureToPickerCenter;
                
                let beta = 4.0*( d - d*d)
                let relativeDistance = clamp(value: self.clostestDistance/trueDistance, minimum:0.0 , maximum: 1.0)
                // let v = self.bounds.center - 0.5*originalSwatchCenter
                let v = p - originalSwatchCenter
                
                
                let gamma = relativeDistance*distanceFactor
                let tranlationVector = gamma*beta*v
                
                var scale =  CGAffineTransform.identity
                let scaleFactor = (0.333 + 0.666*relativeDistance)*(1.0  + 3.0*gamma)
                
                
                
                scale = CGAffineTransform( scaleX: scaleFactor, y: scaleFactor)
                swatch.center = originalSwatchCenter + tranlationVector
                swatch.transform = scale
                
                UIView.animate(withDuration: 0.3, animations: {
                    swatch.transform = scale
                    
                })
            }
            
        }
            
            
        
        return true
    }
    
    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        print("closest dist = \(clostestDistance)")
        
        let differance = abs(clostestDistance - nextClostestDistance)
        print("dif to next  = \(differance)")
        if clostestDistance < maxSelectionDistance && differance > minSelectionDifferance {
            if let swatch = closestSwatch {
                color = swatch.color
                sendActions(for: .valueChanged)
            }
        }
        
        UIView.animate(withDuration: 0.3, animations:
            {
                self.swatches.forEach({$0.transform = CGAffineTransform.identity})
                for index in 0..<self.swatches.count
                {
                    let swatch = self.swatches[index]
                    swatch.center = self.centerPositionForSwatchInPostion(index)
                }
        })

    }
    

    
      
    
    func centerPositionForSwatchInPostion(_ swatchPoitionNumber:Int) -> CGPoint {
        let angle = CGFloat.pi + CGFloat(swatchPoitionNumber)*swatchAngularSpacing
        let swatchVector = CGPoint(x: swatchRadialSpace*cos(angle),y: swatchRadialSpace*sin(angle))
        return self.bounds.center + swatchVector
    }

    var swatches:[DCSwatch] = []
    
    @IBInspectable var swatchRadius:CGFloat = 15.0;
    
    var colorScheme:[Color] = [] {
        willSet {
            swatches.forEach({$0.removeFromSuperview()})
        }
        
        didSet {
            swatches = colorScheme.map({return  DCSwatch(color:$0, radius:swatchRadius)})
            let count = swatches.count
             numberOfSegments = (count - 1 )*2
             swatchAngularSpacing = 2.0*CGFloat.pi / CGFloat(numberOfSegments)
           
            for index in 0..<count {
                let swatch = swatches[index]
                addSubview(swatch)
                swatch.center = centerPositionForSwatchInPostion(index)
            }
            
        }
    }
    
   }
