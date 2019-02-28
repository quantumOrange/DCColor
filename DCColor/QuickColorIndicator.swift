//
//  QuickColorIndicator.swift
//  PaintLab
//
//  Created by David Crooks on 20/04/2015.
//  Copyright (c) 2015 David Crooks. All rights reserved.
//

import UIKit
//import DCGeometry

@objc protocol QuickColorDelegate {
    func brightSwatchCenter() -> CGPoint
    func zoneNumberOfPoint(_: CGPoint) -> Int
    var view:UIView {get}
    func quickColorDidSelectColorAdjustmentMode(_: Int)
}

enum ColorMode:Int {
    case whitness = 0,hue,vibrancy
    case notSet
}

@IBDesignable
class QuickColorIndicator: UIViewController {
    var delegate:QuickColorDelegate?
    @IBOutlet weak var colorIndicatorImageView:UIImageView!
   
    @IBOutlet weak var leftSwatch: DCSwatch!
    
    @IBOutlet weak var rightSwatch: DCSwatch!
    
    @IBOutlet weak var horizontalColorBar: UIView!
    @IBOutlet weak var horzontalGradientView: UIView!
    
 //   @IBOutlet weak var colorIndicatorView: UIView!
    var visualEffectView:UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // colorIndicatorView.layer.cornerRadius = 50.0;
         visualEffectView  = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        
        visualEffectView!.frame = view.bounds
        let maskPath = UIBezierPath(ovalIn:view.bounds)
        let mask = CAShapeLayer()
        mask.path = maskPath.cgPath
        visualEffectView!.layer.mask = mask
        //view.addSubview(visualEffectView)
        view.insertSubview(visualEffectView!, at: 0)
        
        colorIndicatorImageView.image =  colorIndicatorImageView.image?.withRenderingMode(.alwaysTemplate)
        
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(QuickColorIndicator.colorModelChanged), name: NSNotification.Name(rawValue: NOTIFICATION_COLOR_CHANGED), object: nil)
        */
        self.view.clipsToBounds = false
        self.view.alpha = 0.0
        
      //colorIndicatorImageView.tintColor =  PaintModel.sharedInstance().paintColorCopy().uiColor()
       //keyColor = PaintModel.sharedInstance().paintColorCopy()
        //keyColor.opacity = 1.0
        // Do any additional setup after loading the view.
    }
    
    var keyColor:Color = UIColor.red
    
    func colorModelChanged() {
        if colorModeSetWithWhitness  {
            
            colorModeSetWithWhitness = false
        }
        else {
            //keyColor = ????
            //keyColor.opacity = 1.0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let vev = visualEffectView {
            vev.frame = view.bounds
            let maskPath = UIBezierPath(ovalIn:view.bounds)
            let mask = CAShapeLayer()
            mask.path = maskPath.cgPath
            vev.layer.mask = mask
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    fileprivate var colorMode = ColorMode.notSet
    
    func update(_ color:Color) {
        colorIndicatorImageView.tintColor = color.uiColor
        positionColorBar(color)
        
        switch colorMode {
        case .whitness, .vibrancy:
            positionColorBar(color)
        case .hue:
            createHueGradientLayer(color)
        case .notSet:
            break
        }

    }
    
    func configureWithColor(_ color:Color)
    {
        
        switch colorMode {
            case .whitness:
              //  view.transform  = CGAffineTransformIdentity
                createWhitnessGradientLayer(keyColor)
            case .hue:
              //  view.transform  = CGAffineTransformIdentity
                createHueGradientLayer(color)
            case .vibrancy:
                // view.transform  = CGAffineTransformTranslate(CGAffineTransformMakeRotation(CGFloat(M_PI_2)), 0.0, -200.0)
                //view.transform  = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                 createVibrancyGradientLayer(color)
            case .notSet:
                break
        }
        positionColorBar(color)
    }
    
    fileprivate func positionColorBar(_ color:Color) {
        switch colorMode {
            case .whitness:
                positionColorBar(color.whiteness())
            case .hue:
                positionColorBar(0.5)
            case .vibrancy:
                positionColorBar( color.vibrancy())
            
            case .notSet:
                break
        }
    }
    
    fileprivate func positionColorBar(_ value:CGFloat) {
        let dx = horzontalGradientView.bounds.center.x -  barMovementRange*value
        let p = view.bounds.center
        //horizontalColorBar.center = CGPoint(x:p.x + dx, y: horizontalColorBar.center.y)
        colorIndicatorImageView.center = CGPoint(x:p.x - dx, y: colorIndicatorImageView.center.y)
    }
   // let minimumBrightnessAndSaruration:CGFloat = 0.15
    
    let minimumColorfullness:CGFloat = 0.3
    fileprivate func createHueGradientLayer(_ color:Color) {
        
        if let gl = gradientLayer {
            gl.removeFromSuperlayer()
        }
        
        gradientLayer = CAGradientLayer()
        gradientLayer!.frame = horzontalGradientView.bounds
        
        
        
       
        
        let s = color.saturation
        let b = color.brightness
        
        var colorStops:[Color] = [ ]
        //var cgColorStops:[CGColorRef] = [ ]
        for i in  0...20   {
            let beta = CGFloat(i)/CGFloat(20.0)
            let hue:CGFloat = color.hue - hueRange + 2.0*hueRange*beta
            let colorStop = Color(hue: hue, saturation: s, brightness:b )
            colorStops.append(colorStop!)
          //  cgColorStops.append(colorStop.UIColor().CGColor)
        }
        
        
        gradientLayer!.colors = colorStops.map({$0.uiColor().cgColor })
        
        
        self.leftSwatch.color = colorStops.first
        self.rightSwatch.color = colorStops.last
        
        gradientLayer!.startPoint = CGPoint(x: 0.0, y: 0.5);
        gradientLayer!.endPoint = CGPoint(x: 1.0, y: 0.5);
        
        self.horzontalGradientView.layer.addSublayer(gradientLayer!)
    }
    
    fileprivate func createVibrancyGradientLayer(_ color:Color) {
        if let gl = gradientLayer {
            gl.removeFromSuperlayer()
        }
        
        gradientLayer = CAGradientLayer()
        gradientLayer!.frame = horzontalGradientView.bounds
        
        let startColor = color.colorDesaturated()
        let endColor =  color.atMaxBrightnessAndSaturation()
        
        
        
        gradientLayer!.colors = [startColor?.uiColor().cgColor ?? UIColor.blue.cgColor, color.uiColor().cgColor,endColor?.uiColor().cgColor ?? UIColor.red.cgColor]
       // let x = NSNumber(color.vibrancy())
        let vib = color.vibrancy()
        let loc = vib as NSNumber
        gradientLayer!.locations = [ 0.0, loc, 1.0]
        
        self.leftSwatch.color = startColor
        self.rightSwatch.color = endColor
        
        gradientLayer!.startPoint = CGPoint(x: 0.0, y: 0.5);
        gradientLayer!.endPoint = CGPoint(x: 1.0, y: 0.5);
        
        self.horzontalGradientView.layer.addSublayer(gradientLayer!)
    }
    
    
    
    var gradientLayer:CAGradientLayer?
    
    func createWhitnessGradientLayer(_ color:Color) {
        
        if let gl = gradientLayer {
            gl.removeFromSuperlayer()
        }
        
        print("\(color)")
        
        color.opacity = 1.0
        
        
        gradientLayer = CAGradientLayer()
        gradientLayer!.frame = horzontalGradientView.bounds
        gradientLayer!.colors = [UIColor.black.cgColor, color.uiColor().cgColor,UIColor.white.cgColor]
        
        let white = color.whiteness()
        let loc = white as NSNumber
        gradientLayer!.locations = [ 0.0, loc , 1.0]
        
        self.leftSwatch.color = Color.black()
        self.rightSwatch.color = Color.white()
        
         gradientLayer!.startPoint = CGPoint(x: 0.0, y: 0.5);
         gradientLayer!.endPoint = CGPoint(x: 1.0, y: 0.5);
        
        self.horzontalGradientView.layer.addSublayer(gradientLayer!)
    }
    
    
    var newColor:Color = Color.red()
    var startColor:Color = Color.red()
    
    var barMovementRange:CGFloat {
        return self.horzontalGradientView.bounds.size.width
    }
    
    /*
    -(CGPoint)centerOfPaintSwatch
    {
    return CGPointMake(self.view.bounds.size.width*0.5, self.view.bounds.size.height -BIG_SWATCH_RADIUS-7);
    }
    
    -(CGPoint) centerPositionForSwatchInPostion:(NSUInteger )position
    {
    CGPoint  center=[self centerOfPaintSwatch];
    
    return CGPointMake( center.x + SWATCH_SPACING*cos(M_PI +position*SWATCH_ANGLE), center.y + SWATCH_SPACING*sin(M_PI + position*SWATCH_ANGLE));
    }
    */
    
    
    var brightSwatchCenter:CGPoint = CGPoint.zero
    
    func pan(_ gesture:UIPanGestureRecognizer, gestureOutOfBounds:Bool){
        //tool hiddin and
       // if(!CGAffineTransformIsIdentity( self.toolVC.view.transform )  || vertical<BIG_SWATCH_RADIUS){
            
        //}
       // [self.toolVC.paintVC.quickColorIndicator pan:gesture];
        // }
        switch gesture.state {
            case .began:
                if gestureOutOfBounds {
                    break
                }
              // startColor = PaintModel.sharedInstance().paintColorCopy()
               startColor.opacity = 1.0
            case .changed:
                if gestureOutOfBounds {
                    break
                }
                if let del = delegate {
                    let v = gesture.translation(in: del.view)
                    
                    switch colorMode {
                        case .notSet:
                            
                            
                            let p =  gesture.location(in: del.view)
                        let zoneNumber = del.zoneNumberOfPoint(p)
                        
                            switch zoneNumber {
                                case 2:
                                    colorMode = .vibrancy
                                case 1,3:
                                    colorMode = .hue
                                default:
                                 colorMode = .whitness
                                
                            }
                        
                            
                                delegate?.quickColorDidSelectColorAdjustmentMode(colorMode.rawValue)
                            
                         
                                configureWithColor(startColor)
                                UIView.animate(withDuration: 0.4, animations:{
                                    self.view.alpha = 1.0
                                    
                                })

                        
                       
                        case .whitness:
                            let dx = v.x/barMovementRange
                            let value = clamp(value:startColor.whiteness() + dx ,min:0.0,max:1.0)
                          //  let value = clamp(0.0, max: 1.0,  value: startColor.whiteness() + dx )
                          
                            newColor = keyColor.colorWhiteness(value)
                            
                           
                            update(newColor)
                        case .vibrancy:
                            let dx:CGFloat = v.x/barMovementRange
                            let value = clamp(value:startColor.vibrancy()  + dx ,min:0.0,max:1.0)
                           // let value = clamp(0.0, max: 1.0,  value: startColor.vibrancy() + dx )
                            
                            newColor = startColor.withVibrancy(value)
                            
                            
                            update(newColor)

                        
                        case .hue:
                            let dx = -v.x/barMovementRange
                            let value = hueRange*dx 
                           
                            
                            newColor = startColor.colorAddHue(value)
                            
                            
                            
                            if newColor.colorfullness() < minimumColorfullness {
                                newColor = newColor.withColorfullness(minimumColorfullness)
                            }
                          
                            update(newColor)
                    }
                    
                    
                }
        case  .ended:
            if colorMode == .whitness {
                colorModeSetWithWhitness = true
            }
         ///   PaintModel.sharedInstance().setPaintColorColorOnly(newColor) ??????
            UIView.animateKeyframes(withDuration: 0.7, delay: 0.4, options:[], animations: {self.view.alpha = 0.0}, completion: {didComplete in})
            
            colorMode = .notSet
        case .cancelled, .failed :
            UIView.animateKeyframes(withDuration: 0.7, delay: 0.4, options:[], animations: {self.view.alpha = 0.0}, completion: {didComplete in})
            colorMode = .notSet
        case .possible:
                break
        }
    }
    var colorModeSetWithWhitness = false
    let hueRange:CGFloat = 1.0 / 3.0
    
   

}
