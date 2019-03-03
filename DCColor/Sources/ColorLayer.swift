//
//  ColorLayer.swift
//  DCColor
//
//  Created by David Crooks on 09/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import Foundation
import UIKit

protocol ColorLayer {
    func color(atPoint p:PixelPoint) -> Color
}

protocol ComparableColorLayer {
    func compare(withLayer:Self, atPoints points:[PixelPoint], withTolerance:CGFloat) -> Bool
}

extension UIImage:ColorLayer {
    func color(atPoint p:CGPoint) -> Color {
        
        let pixelPoint = PixelPoint(p: p, scale: scale)
        
        return color(atPoint: pixelPoint)
    }
    
    func color(atPoint p:PixelPoint) -> Color {
        guard let image = self.cgImage else { return UIColor(white: 0.0, alpha: 0.0) }
         return image.color(atPoint: p)
    }
}

extension CGImage:ColorLayer {
    func color(atPoint p:PixelPoint) -> Color {
        
        guard let dataProvider = dataProvider else { return UIColor(white: 0.0, alpha: 0.0) }
        
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(dataProvider.data)
        
        if p.x < 0 || p.x >= width || p.y < 0 || p.y >= height {
            return UIColor(white: 0.0, alpha: 0.0)
        }
        
        let pixelIndex = 4*(width * p.y + p.x)
        
        let r = CGFloat(data[pixelIndex]) / CGFloat(255.0)
        let g = CGFloat(data[pixelIndex + 1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelIndex + 2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelIndex + 3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension CGImage:ComparableColorLayer {
    func compare(withLayer other:CGImage, atPoints points:[PixelPoint], withTolerance tolerance:CGFloat) -> Bool {
        
        guard let dataProvider = dataProvider else { return false }
        guard let otherDataProvider = other.dataProvider else { return false }
        
        if width != other.width || height != other.height { return false }
        
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(dataProvider.data)
        let otherData: UnsafePointer<UInt8> = CFDataGetBytePtr(otherDataProvider.data)
        
        
        let pixelIndcies = points.map{4*(width * $0.y + $0.x)}
        
        
        let result = pixelIndcies.reduce(0, { (result, pixelIndex) in
        

            let r = Int( data[pixelIndex] )  - Int( otherData[pixelIndex] )
            let g = Int(data[pixelIndex + 1]) - Int(otherData[pixelIndex + 1])
            let b = Int(data[pixelIndex + 2]) - Int(otherData[pixelIndex + 2])
            let a = Int(data[pixelIndex + 3]) - Int(otherData[pixelIndex + 3])
            
            let diff =  max(abs(r),abs(g),abs(b),abs(a))
            
            return max(result, diff)
        
        })
        
        
        let largestDiff = CGFloat( result) / CGFloat(255.0)

        
        return largestDiff < tolerance
    }
}

extension CGContext:ColorLayer {
    func color(atPoint p:PixelPoint) -> Color {
        guard let image = makeImage() else { return UIColor(white: 0.0, alpha: 0.0) }
        return image.color(atPoint: p)
    }
}


