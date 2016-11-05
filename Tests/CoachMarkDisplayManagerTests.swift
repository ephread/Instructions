// CoachMarkTests.swift
//
// Copyright (c) 2015, 2016 Frédéric Maquin <fred@ephread.com>
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

class CoachMarkDisplayManagerTests: XCTestCase {

    let overlayView = OverlayView()
    let instructionsRootView = UIView()
    let coachMarksController = CoachMarksController()
    var coachMarkDisplayManager: CoachMarkDisplayManager!

    var viewIsVisibleExpectation: XCTestExpectation? = nil

    override func setUp() {
        super.setUp()

        self.overlayView.frame = CGRect(x: 0, y: 0, width: 365, height: 667)
        self.instructionsRootView.frame = CGRect(x: 0, y: 0, width: 365, height: 667)

        instructionsRootView.addSubview(overlayView)

        self.coachMarkDisplayManager =
            CoachMarkDisplayManager(coachMarkLayoutHelper: CoachMarkLayoutHelper())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testThatCoachMarkViewIsShown() {
        let coachMarkView = CoachMarkView(bodyView: CoachMarkBodyDefaultView(),
                                          coachMarkInnerLayoutHelper: CoachMarkInnerLayoutHelper())
        var coachMark = CoachMark()
        coachMark.cutoutPath = UIBezierPath(rect: CGRect(x: 30, y: 30, width: 60, height: 30))

        self.viewIsVisibleExpectation = self.expectation(description: "viewIsVisible")

        coachMark.computeOrientation(inFrame: self.instructionsRootView.frame)
        coachMark.computePointOfInterest()

        self.coachMarkDisplayManager.showNew(coachMarkView: coachMarkView, from: coachMark,
                                             on: self.overlayView) {
            XCTAssertEqual(coachMarkView.alpha, 1.0)
            XCTAssertEqual(coachMarkView.isHidden, false)

            self.viewIsVisibleExpectation?.fulfill()
        }

        self.waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
