//
//  DCColorSlider.swift
//  DCColor
//
//  Created by David Crooks on 04/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit
import DCCoreGraphics

@IBDesignable
public class DCColorSlider: DCColorControl {
    
    
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
    
    private func setup(){
        if isSetup { return }
        
        thumb = DCSwatch(frame: CGRect.square(center:positionOfHandel, with:2.0*thumbRadius ))
        thumb.color = color
        thumb.isUserInteractionEnabled = false
        gradient = DCGradientView(frame: activeFrame())
        gradient.channel = channel
        gradient.color = color
        gradient.isUserInteractionEnabled = false
       
        addSubview(gradient)
        addSubview(thumb)
        
        isSetup = true
    }
    
    /// The frame over which the center of the thumb handel will slide. Inset by the radius of the thumb on the left and right so that the thumb will still fit in the view even when at the extremes of the activeFrame.
    func activeFrame() -> CGRect {
        
        let origin = bounds.origin + CGPoint(x:thumbRadius , y:0.0)
        let width = bounds.size.width - 2.0*thumbRadius
        let rect = CGRect(origin: origin, size: CGSize(width: width, height: bounds.height))
        
        print(rect)
        
        return rect
    }
    
    private var thumb:DCSwatch!
    private var gradient:DCGradientView!
    
    override public func  layoutSubviews() {
        super.layoutSubviews()
        thumb.frame = CGRect.square( center:positionOfHandel,  with:2.0*thumbRadius )
        thumb.center = positionOfHandel
        gradient.frame = activeFrame()
        
    }
    
    
    //MARK:- Inspectabeles
    @IBInspectable
    public var thumbRadius:CGFloat = 20.0
    
    public var cornerRadius:CGFloat = 5.0 {
        didSet {
            gradient.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    public var iColor:UIColor {
        get {
            return color.uiColor
        }
        set {
            color = newValue
        }
        
    }
    
    @IBInspectable
    public var iChannel:Int {
        get {
            return channel.rawValue
        }
        set {
            if let c = ColorChannel(rawValue: newValue) {
                channel = c
            }
        }
    }
    
    //MARK:- Touch
    var initialPosition:CGPoint = CGPoint.zero
    var initialTouch:CGPoint = CGPoint.zero
    var didDragHandel = false
    var dragBeganInThumbRect = false
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        initialTouch = touch.location(in: self)
        initialPosition = thumb.center
        
        didDragHandel = false
        dragBeganInThumbRect = thumb.frame.contains(initialTouch)
        
        return true
    }
    
    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        didDragHandel = true
        
        if dragBeganInThumbRect {
            let p = touch.location(in: self)
            let translation = p - initialTouch
            positionOfHandel = initialPosition + translation
            return true
        }
        return false
    }
    
    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if !didDragHandel {
            if let p = touch?.location(in: self) {
                positionOfHandel = p
            }
            didDragHandel = false
        }
        super.endTracking(touch, with: event)
    }
    
    //MARK:- Color
    
    public var channel:ColorChannel = .red {
        didSet {
            gradient.channel = channel
        }
    }
    
    public override var color:Color  {
        didSet {
            
            print("did set color")
            
            gradient.color = color
            gradient.setNeedsDisplay()
            thumb.color = color
            print("Animate thumb with p:\(self.positionOfHandel)")
            
            if didDragHandel {
                self.thumb.center = self.positionOfHandel
            }
            else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.thumb.center = self.positionOfHandel
                })
            }
        }
    }
    
    //MARK:- Thumb
    
    private var positionOfHandel:CGPoint {
        get {
            
            let mapToPosition = mapRange(fromRange: CGFloat.unitRange, toRange: activeFrame().rangeX)
            let value = color.value(forChannel: channel)
            return CGPoint(x: mapToPosition(value), y: 0.5*bounds.height)
        }
        set {
            let mapFromPosition = mapRange(fromRange:activeFrame().rangeX,  toRange: CGFloat.unitRange)
            let value = mapFromPosition(newValue.x)
            color = color.colorWith(channel: channel, value: value)
            sendActions(for: .valueChanged)
        }
    }
    
}
