//
//  DCColorTests.swift
//  DCColorTests
//
//  Created by David Crooks on 04/03/2017.
//  Copyright © 2017 David Crooks. All rights reserved.
//

import XCTest
@testable import DCColor

class DCColorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func checkColors(red:Color,yellow:Color,white:Color,black:Color,cyan:Color){
        let tolerance:CGFloat  = 0.00001
        XCTAssertEqual(red.rgb.red, 1.0, accuracy: tolerance, "red r != 1")
        XCTAssertEqual(red.rgb.green, 0.0, accuracy: tolerance, "red g != 0")
        XCTAssertEqual(red.rgb.blue, 0.0, accuracy: tolerance, "red b != 0")
        XCTAssertEqual(red.hsb.hue, 0.0, accuracy: tolerance, "red hue != 0")
        XCTAssertEqual(red.value(forChannel: .hue), 0.0, accuracy: tolerance, "red hue value != 0")
        
        XCTAssertEqual(cyan.rgb.red, 0.0, accuracy: tolerance, "cyan r")
        XCTAssertEqual(cyan.rgb.green, 1.0, accuracy: tolerance, "cyan g")
        XCTAssertEqual(cyan.rgb.blue, 1.0, accuracy: tolerance, "cyan b")
        
        XCTAssertEqual(yellow.rgb.red, 1.0, accuracy: tolerance, "yellow r" )
        XCTAssertEqual(yellow.rgb.green, 1.0, accuracy: tolerance, "yellow g")
        XCTAssertEqual(yellow.rgb.blue, 0.0, accuracy: tolerance, "yellow b")
        XCTAssertEqual(yellow.hsb.brightness, 1.0, accuracy: tolerance, "yellow br")
        XCTAssertEqual(yellow.hsb.saturation, 1.0, accuracy: tolerance, "yellow sat" )
        
        
        XCTAssertEqual(white.rgb.red, 1.0, accuracy: tolerance, "white r")
        XCTAssertEqual(white.rgb.green, 1.0, accuracy: tolerance, "white g")
        XCTAssertEqual(white.rgb.blue, 1.0, accuracy: tolerance, "white b")
        XCTAssertEqual(white.hsb.brightness, 1.0, accuracy: tolerance, "white bright")
        XCTAssertEqual(white.hsb.saturation, 0.0, accuracy: tolerance, "white sat")
        
        XCTAssertEqual(black.rgb.blue, 0.0, accuracy: tolerance, "")
        XCTAssertEqual(black.hsb.brightness, 0.0, accuracy: tolerance, "")
        XCTAssertEqual(black.hsb.saturation, 0.0, accuracy: tolerance, "")
        
        XCTAssertEqual(cyan.value(forChannel: .red), 0.0, accuracy: tolerance, "cyan value r")
        XCTAssertEqual(cyan.value(forChannel: .green), 1.0, accuracy: tolerance, "cyan value b")
        XCTAssertEqual(cyan.value(forChannel: .blue), 1.0, accuracy: tolerance, "cyan value g")
        
        XCTAssertEqual(yellow.value(forChannel: .red), 1.0, accuracy: tolerance, "yellow value r")
        XCTAssertEqual(yellow.value(forChannel: .green), 1.0, accuracy: tolerance, "yellow value g")
        XCTAssertEqual(yellow.value(forChannel: .blue), 0.0, accuracy: tolerance, "yellow value b")
        
        let g:CGFloat = 0.34
        let newColor = red.colorWith(channel: .green, value: g)
        
        XCTAssertEqual(newColor.rgb.red, 1.0, accuracy: tolerance, "nc r != 1")
        XCTAssertEqual(newColor.rgb.green, g, accuracy: tolerance, "nc g != g")
        XCTAssertEqual(newColor.rgb.blue, 0.0, accuracy: tolerance, "nc b != 0")
    }
    
    func testUIColor() {
        
        let red = UIColor.red
        let yellow = UIColor.yellow
        let white = UIColor.white
        let black = UIColor.black
        let cyan = UIColor.cyan
        
        checkColors(red: red, yellow: yellow, white: white, black: black, cyan: cyan)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func equalColors(color1:Color, color2:Color,msg:String){
        let tolerance:CGFloat = 0.00001
        XCTAssertEqual(color1.rgb.red, color2.rgb.red, accuracy: tolerance, msg + "not equal  r")
        XCTAssertEqual(color1.rgb.green, color2.rgb.green, accuracy: tolerance,  msg + "not equal g")
        XCTAssertEqual(color1.rgb.blue,color2.rgb.blue, accuracy: tolerance,  msg + "not equal b")
    }
    
    func testDCSwatch() {
        let color1 = UIColor.red
        let color2 = UIColor.blue
        
        let swatch = DCSwatch(color: color1, radius: 20.0)
        equalColors(color1: color1, color2: swatch.color, msg: "DCSwatch init")
        swatch.color = color2
        equalColors(color1: color2, color2: swatch.color, msg: "DCSwatch set")
        
    }
    
    func testDCSwatchButton() {
        let color1 = UIColor.red
        let color2 = UIColor.blue
        
       
        let swatch = DCSwatchButton(color: color1, radius: 20.0)
        equalColors(color1: color1, color2: swatch.color, msg: "Button init")
        swatch.color = color2
        equalColors(color1: color2, color2: swatch.color, msg: "button set ")
    }
    
    
    func testDynamicSwatchButton() {
        let color1 = UIColor.red
        let color2 = UIColor.blue
    
        let swatch = DynamicSwatch(color: color1, radius: 20.0,type:.brightness)
        equalColors(color1: color1, color2: swatch.color, msg: "Multi init")
        swatch.color = color2
        equalColors(color1: color2, color2: swatch.color, msg: "Multi set ")
    }
    
    func testDynamicMultiSwatchButton() {
        let color1 = UIColor.red
        let color2 = UIColor.blue
        
        let colorControl = DynamicMultiSwatch(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 150.0))
        colorControl.color = color1
        equalColors(color1: color1, color2: colorControl.color, msg: "Dynanmic init")
        colorControl.color = color2
        equalColors(color1: color2, color2: colorControl.color, msg: "Dynamic set ")
        
    }

    func testHSBColor(){
        let hsb = HSBColor(hue: 0.35, saturation: 0.41, brightness:0.67 , alpha: 1.0)
        
        let accuracy:CGFloat = 0.0001
        
        XCTAssertEqual(hsb.rgb.red, hsb.uiColor.rgb.red, accuracy: accuracy)
        XCTAssertEqual(hsb.rgb.green, hsb.uiColor.rgb.red, accuracy: accuracy)
        XCTAssertEqual(hsb.rgb.blue, hsb.uiColor.rgb.red, accuracy: accuracy)
    }
    
    func testRGBColor(){
        let rgb = RGBColor(red: 0.35, green: 0.41, blue:0.67 , alpha: 1.0)
        
        let accuracy:CGFloat = 0.0001
        let twopi = 2.0 * CGFloat.pi
        
        XCTAssertEqual(rgb.hsb.hsb.hue, rgb.uiColor.hsb.hue *  twopi , accuracy: accuracy)
        XCTAssertEqual(rgb.hsb.hsb.saturation, rgb.uiColor.hsb.hsb.saturation, accuracy: accuracy)
        XCTAssertEqual(rgb.hsb.hsb.brightness, rgb.uiColor.hsb.hsb.brightness, accuracy: accuracy)
    }
}
