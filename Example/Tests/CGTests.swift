//
//  CGTests.swift
//  DCColorTests
//
//  Created by David Crooks on 19/02/2019.
//  Copyright © 2019 David Crooks. All rights reserved.
//

import XCTest

class CGTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAngles() {
        let theta:CGFloat = 0.45678
        
        func testAngle(_ theta:CGFloat){
            let p = CGPoint(angle: theta, radius: 1.0)
            
            XCTAssertEqual(theta,p.angle, accuracy: 0.01)
        }
        
        testAngle(.pi)
        testAngle(0.4567 )
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
