//
//  CoachMarkTests.swift
//  Instructions
//
//  Created by Frédéric Maquin on 03/10/15.
//  Copyright © 2015 Ephread. All rights reserved.
//

import XCTest
@testable import Instructions

class CoachMarkTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testThatOrientationIsTop() {
        var coachMark = CoachMark()
        let overlayFrame = CGRect(x: 0, y: 0, width: 320, height: 480)

        coachMark.cutoutPath = UIBezierPath(rect: CGRect(x: 30, y: 50, width: 30, height: 60))

        coachMark.computeOrientationInFrame(overlayFrame)

        XCTAssertEqual(coachMark.arrowOrientation, CoachMarkArrowOrientation.Top)
    }

    func testThatOrientationIsBottom() {
        var coachMark = CoachMark()
        let overlayFrame = CGRect(x: 0, y: 0, width: 320, height: 480)

        coachMark.cutoutPath = UIBezierPath(rect: CGRect(x: 30, y: 320, width: 30, height: 60))

        coachMark.computeOrientationInFrame(overlayFrame)

        XCTAssertEqual(coachMark.arrowOrientation, CoachMarkArrowOrientation.Bottom)
    }

    func testThatPointOfInterestIsAtCenterOfCutoutPath() {
        var coachMark = CoachMark()
        coachMark.cutoutPath = UIBezierPath(rect: CGRect(x: 30, y: 320, width: 30, height: 60))

        coachMark.computePointOfInterestInFrame()

        XCTAssertEqual(coachMark.pointOfInterest, CGPoint(x: 45, y: 350))
    }
}
