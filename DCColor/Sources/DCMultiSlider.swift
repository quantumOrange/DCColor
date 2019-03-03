//
//  DCMultiSlider.swift
//  DCColor
//
//  Created by David Crooks on 06/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import UIKit

@IBDesignable
public class DCMultiSlider: DCColorControl {
    
    fileprivate var channels:[ColorChannel]  { return  [.red,.green,.blue,.hue,.saturation,.brightness,.alpha]  }
    fileprivate var sliderArray:[DCColorSlider] = []
    
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
    
    func setup() {
        if isSetup { return }
        
        sliderArray = channels.map{ channel -> DCColorSlider in
            let slider = DCColorSlider(frame: CGRect.zero)
            slider.channel = channel
            slider.addTarget(self, action: #selector(sliderChanged), for: UIControl.Event.valueChanged )
            return slider
        }
        
        let stackView = UIStackView(arrangedSubviews: sliderArray)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        
        //add autolayout constraints
        let viewsDictionary = ["stackView":stackView]
        let stackView_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[stackView]-0-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[stackView]-0-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutConstraint.FormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        
        addConstraints(stackView_H)
        addConstraints(stackView_V)
        
        isSetup = true
    }
    
    @objc func sliderChanged(slider:DCColorSlider) {
        
        color = slider.color
        
        //update the other sliders
        sliderArray.forEach{
            if $0 != slider {
                $0.color = slider.color
            }
        }
        

        sendActions(for: .valueChanged)
    }
    
    //MARK:- Inspectabeles
    
    @IBInspectable
    public var thumbRadius:CGFloat = 20.0 {
        didSet {
            sliderArray.forEach{ $0.thumbRadius = thumbRadius   }
        }
    }

    
    public var cornerRadius:CGFloat = 5.0 {
        didSet {
            sliderArray.forEach{ $0.cornerRadius = cornerRadius   }
        }
    }
    
    @IBInspectable
    public var iColor:UIColor {
        set {
            color = iColor
            sliderArray.forEach{ $0.color = iColor   }
        }
        get {
            return self.color.uiColor
        }
    }

    
}

@IBDesignable
class RGBSlider:DCMultiSlider {
    override var channels:[ColorChannel] { return [.red,.green,.blue] }
}


@IBDesignable
class HSBSlider:DCMultiSlider {
    override var channels:[ColorChannel] { return [.hue,.saturation,.brightness] }
}

@IBDesignable
class RGBHSBSlider:DCMultiSlider {
    override var channels:[ColorChannel] { return [.red,.green,.blue,.hue,.saturation,.brightness] }
}
