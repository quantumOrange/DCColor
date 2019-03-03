//
//  Drawable.swift
//  DrawingDemoApp
//
//  Created by David Crooks on 28/02/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import Foundation

import Foundation
import CoreGraphics


public protocol Renderer {
    /// Moves the pen to `position` without drawing anything.
    func move(to:CGPoint)
    /// Draws a line from the pen's current position to `position`, updating
    /// the pen position.
    func addLine(to:CGPoint)

    
    /// Draws the fragment of the circle centered at `c` having the given
    /// `radius`, that lies between `startAngle` and `endAngle`, measured in
    /// radians.
    func addArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
    func addCircle(center: CGPoint, radius: CGFloat)
    func addQuadCurve(to: CGPoint, control: CGPoint)
    
    func fillPath()
}

extension CGContext : Renderer {
    
    public func fillPath(){
        self.fillPath(using: .winding)
    }
    
    public func addArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
       //TODO: - WARNING :- Not Working on iOS9.0 
        //update - maybe fixed? changed clockwise from true to false
        let arc = CGMutablePath()
        
       // move(to: center)
        arc.addArc(center: center, radius: radius,
                   startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        addPath(arc)
    }
    
    public func addCircle(center: CGPoint, radius: CGFloat) {
        let side = radius*2.0
        addEllipse(in:CGRect.square(center: center, with:side))
    }
    
}

public struct TestRenderer : Renderer {
    
    public init() {
        
    }
    
    public func fillPath() {
        print("fill path")
    }

    public func addQuadCurve(to p: CGPoint, control: CGPoint){
        print("add quadratic bezier to\(p.x), \(p.y)) with control: \(control.x), \(control.y)) ")
    }
    
    public func addLine(to p: CGPoint) {
         print("lineTo(\(p.x), \(p.y))")
    }

    public func move(to p: CGPoint) { print("moveTo(\(p.x), \(p.y))") }
    
    func line(to p: CGPoint) { print("lineTo(\(p.x), \(p.y))") }
    
    public func addArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        print("arcAt(\(center), radius: \(radius)," + " startAngle: \(startAngle), endAngle: \(endAngle))")
    }
    public func addCircle(center: CGPoint, radius: CGFloat){
        print("circleAt(\(center), radius: \(radius)")
    }
}

//: An element of a `Diagram`.  Concrete examples follow.
public protocol Drawable {
    /// Issues drawing commands to `renderer` to represent `self`.
    func draw(renderer: Renderer)
}

extension Drawable {
    
    func drawPath(withPoints points:[CGPoint], renderer: Renderer) {
        renderer.move(to: points.first!)
        points.dropFirst().forEach{ renderer.addLine(to: $0) }
    }
    
    func drawLoop(withPoints points:[CGPoint], renderer: Renderer) {
        renderer.move(to: points.last!)
        points.forEach{ renderer.addLine(to: $0) }
    }
    
}

public struct Diagram {
    let shapes:[Drawable]
    let fillColor:UIColor
    let strokeColor:UIColor
    
    func draw(context:CGContext) {
        context.setFillColor(fillColor.cgColor)
        shapes.forEach{ $0.draw(renderer:context) }
        context.fillPath()
        context.setStrokeColor(strokeColor.cgColor)
        shapes.forEach{ $0.draw(renderer:context) }
        context.strokePath()
    }
}





