//
//  CanvasColorPickerView.swift
//  PaintLab
//
//  Created by David Crooks on 14/09/2015.
//  Copyright (c) 2015 David Crooks. All rights reserved.
//

import UIKit
import DCCoreGraphics

@IBDesignable
class CanvasColorPickerView: UIView {
    
    @IBInspectable var curveFactor:CGFloat = 33.0
    @IBInspectable var swatchMargin:CGFloat = 5.0
    
    var radius:CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private var swatch = CALayer()
    
    private func setup() {
       
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        self.backgroundColor = UIColor.clear
        layer.addSublayer(swatch)
        self.layoutSubviews()
      //  swatch.position = CGPoint(x: layer.position.x,y: layer.position.y - 25 )

    }
    
    func showColor(_ color:Color)
    {
        swatch.backgroundColor = color.uiColor.cgColor
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        radius = 0.5*frame.size.width
        let swatchradius =  radius - swatchMargin
        swatch.frame = CGRect(x: 0, y: 0, width: 2*swatchradius, height: 2*swatchradius)
        swatch.cornerRadius = swatchradius
        swatch.position = CGPoint(x:0,y:0)
    }
    ///animates the view transform such that if the swatch would be above the given rect (and perhaps not visable) it will rotate so that the swatch appears below the point that is pointed too
    func animate(atPoint p:CGPoint, inRect rect:CGRect) {
        layoutIfNeeded()
        if (p.y - bounds.size.height < rect.origin.y)  {
            if  transform.isIdentity {
                UIView.animate(withDuration: 0.3, animations: {
                    self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                })
            }
        }
        else if !transform.isIdentity {
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
      //  let radius = 0.5*rect.size.width
        
        let leftCircleTangentPoint = rect.topLeft + CGPoint(x: 0.0, y:radius)
        let rightCircleTangentPoint = rect.topRight + CGPoint(x: 0.0, y:radius)
        
        
        let ratio = curveFactor/100.0
        let controlPointY = radius + ratio*(rect.height - radius)
        
        context.setFillColor(UIColor.gray.cgColor)
        
        
        
        context.move(to:leftCircleTangentPoint )
        context.addArc(tangent1End:rect.topLeft , tangent2End: rect.topCenter, radius: radius)
        context.addArc(tangent1End: rect.topRight , tangent2End: rightCircleTangentPoint, radius: radius)
        context.addQuadCurve(to: rect.bottomCenter, control: CGPoint(x:rect.topRight.x, y:controlPointY ))
        context.addQuadCurve(to: leftCircleTangentPoint, control:CGPoint(x:rect.topLeft.x, y:controlPointY ))
 
        
        
        
        context.drawPath(using: .fill)
    }
}



class CanvasColorPickerController {
    
    init(canvasView:UIView, containingView:UIView, layer:ColorLayer,pickColorAction:@escaping ((Color) -> ())) {
        self.canvasView = canvasView
        self.paintView = containingView
        colorPickerView = CanvasColorPickerView(frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 100))
        self.layer = layer
        pickColor = pickColorAction
        
        //add gesture to container view
        let gesture = UILongPressGestureRecognizer(target:self,action: #selector(handleLongPress))
        containingView.addGestureRecognizer(gesture)
    }
    
    var canvasView:UIView
    var paintView:UIView
    var colorPickerView:CanvasColorPickerView
    var layer:ColorLayer
    
    var pickColor:(Color) -> ()
    
    @objc func handleLongPress(_ gesture:UILongPressGestureRecognizer) {
        
            let pointInCanvas = gesture.location(in: canvasView)
            let pointInView = gesture.location(in: paintView)
            
            
            let color =   layer.color(atPoint: pointInCanvas.pixelPoint )
        
        
            switch gesture.state {
            case .began:
                if canvasView.bounds.contains(pointInCanvas) {
                    paintView.addSubview(colorPickerView)
                    colorPickerView.showColor(color)
                    colorPickerView.center = pointInView
                }
                colorPickerView.animate(atPoint:pointInView, inRect:paintView.bounds)
                break
            case .changed:

                colorPickerView.center = pointInView
                colorPickerView.animate(atPoint:pointInView, inRect:paintView.bounds)
                colorPickerView.showColor(color)
            
            case .ended:
                colorPickerView.showColor(color)
                colorPickerView.removeFromSuperview()
            case .failed:
                colorPickerView.removeFromSuperview()
            case .cancelled:
                colorPickerView.removeFromSuperview()
            case .possible:
                break
            }
    }
}
