//
//  DynamicMultiSwatch.swift
//  DCColor
//
//  Created by David Crooks on 22/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit
import DCCoreGraphics


@IBDesignable
class DynamicMultiSwatch:DCColorControl {
    //MARK:- Inspecatbles
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
    var mainSwatchRadius:CGFloat = 24.0 {
        didSet {
            mainSwatch.radius = mainSwatchRadius
        }
    }
    
    @IBInspectable
    var dynamicSwatchRadius:CGFloat = 16.0 {
        didSet {
            dynamicSwatches.forEach{$0.radius = dynamicSwatchRadius}
        }
    }

    @IBInspectable
    var swatchRadialDistance:CGFloat = 56.0 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable
    var mainSwatchOffset:CGFloat = 30.0 {
        didSet {
            layoutSubviews()
        }
    }
    
    //MARK :- Initialization
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        defer {
            mainSwatch.color = UIColor.magenta
            dynamicSwatches.forEach {$0.setSwatchColor(for: color)}
        }
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
        //do setup
        
        mainSwatch = DCSwatchButton(color: UIColor.magenta, radius: mainSwatchRadius)
        addSubview(mainSwatch)
        mainSwatch.addTarget(self, action: #selector(mainSwatchTapped), for: .primaryActionTriggered)
        mainSwatch.center = centerPositionForMainSwatch
        
        dynamicSwatches = (0..<5).map{  DynamicSwatch(color:color,radius:dynamicSwatchRadius,type:DynmaicSwatchType(rawValue:$0)!)}
        
        
        dynamicSwatches.forEach {
            $0.addTarget(self, action: #selector(dynamicSwatchTapped), for: .primaryActionTriggered )
            setPostionOf(swatch:$0)
            $0.setSwatchColor(for: color)
            
            addSubview($0)
        }
        
        isSetup = true
    }
    
    var centerPositionForMainSwatch:CGPoint {
        let c = bounds.center
        return CGPoint(x:c.x,y:c.y + mainSwatchOffset )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainSwatch.center = centerPositionForMainSwatch
        dynamicSwatches.forEach{
            setPostionOf(swatch:$0)
        }
    }
    
    var dynamicSwatches:[DynamicSwatch]!
    
    @objc func dynamicSwatchTapped(_ swatch:DynamicSwatch){
        
        color = swatch.color
        sendActions(for: .valueChanged)
        
    }
    
    
    ///Tapping the main swatch sends the primaryActionTriggered action.
    @objc func mainSwatchTapped(_ swatch:DCSwatchButton){
        sendActions(for:.primaryActionTriggered)
    }
    
    
    func setPostionOf(swatch:DynamicSwatch){
        let angle = CGFloat.pi + CGFloat(swatch.type.rawValue) * CGFloat.pi * 0.25
        
        let relativePosition = CGPoint(angle: angle, radius: swatchRadialDistance)
        
        swatch.center = mainSwatch.center + relativePosition
        
    }
    
    var mainSwatch:DCSwatchButton!
    
    override var color:Color {
        get {
            return mainSwatch.color
        }
        set {
            mainSwatch.color = newValue
            dynamicSwatches.forEach{ $0.setSwatchColor(for:newValue) }
        }
    }
    
    
}



