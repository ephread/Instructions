// CoachMarkTests.swift
//
// Copyright (c) 2015 Frédéric Maquin <fred@ephread.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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

        XCTAssertEqual(coachMark.arrowOrientation, CoachMarkArrowOrientation.top)
    }

    func testThatOrientationIsBottom() {
        var coachMark = CoachMark()
        let overlayFrame = CGRect(x: 0, y: 0, width: 320, height: 480)

        coachMark.cutoutPath = UIBezierPath(rect: CGRect(x: 30, y: 320, width: 30, height: 60))

        coachMark.computeOrientationInFrame(overlayFrame)

        XCTAssertEqual(coachMark.arrowOrientation, CoachMarkArrowOrientation.bottom)
    }

    func testThatPointOfInterestIsAtCenterOfCutoutPath() {
        var coachMark = CoachMark()
        coachMark.cutoutPath = UIBezierPath(rect: CGRect(x: 30, y: 320, width: 30, height: 60))

        coachMark.computePointOfInterestInFrame()

        XCTAssertEqual(coachMark.pointOfInterest, CGPoint(x: 45, y: 350))
    }
}
