//
//  ColorDrawable.swift
//  DCColor
//
//  Created by David Crooks on 04/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import Foundation

protocol ColorDrawable:Drawable {
    
}

protocol ColorRenderer:Renderer {
    func setFillColor(_ color:CGColor)
    func setStrokeColor(_ color:CGColor)
    
    func fillPath()
    func strokePath()
}

struct ColorDrawing:ColorDrawable {
    
    let shapes:[Drawable]
    let fillColor:UIColor
    let strokeColor:UIColor
    
    func draw(renderer:ColorRenderer) {
        renderer.setFillColor(fillColor.cgColor)
        shapes.forEach{ $0.draw(renderer:renderer) }
        renderer.fillPath()
        renderer.setStrokeColor(strokeColor.cgColor)
        shapes.forEach{ $0.draw(renderer:renderer) }
        renderer.strokePath()
    }
    
    
    func draw(renderer:Renderer) {
        shapes.forEach{ $0.draw(renderer:renderer) }
        fatalError()
    }
}



