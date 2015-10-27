//
//  CoachMarkDisplayManager.swift
//  Instructions
//
//  Created by Frédéric Maquin on 26/10/15.
//  Copyright © 2015 Ephread. All rights reserved.
//

import XCTest
@testable import Instructions

class CoachMarkDisplayManagerTests: XCTestCase {

    let overlayView = OverlayView()
    let instructionsTopView = UIView()
    let coachMarksController = CoachMarksController()
    var coachMarkDisplayManager: CoachMarkDisplayManager!

    var viewIsVisibleExpectation: XCTestExpectation? = nil

    override func setUp() {
        super.setUp()

        self.overlayView.frame = CGRect(x: 0, y: 0, width: 365, height: 667)
        self.instructionsTopView.frame = CGRect(x: 0, y: 0, width: 365, height: 667)

        self.coachMarkDisplayManager =
            CoachMarkDisplayManager(coachMarksController: coachMarksController, overlayView: self.overlayView, instructionsTopView: self.instructionsTopView)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testThatCoachMarkViewIsShown() {
        let coachMarkView = CoachMarkView(bodyView: CoachMarkBodyDefaultView())
        var coachMark = CoachMark()
        coachMark.cutoutPath = UIBezierPath(rect: CGRect(x: 30, y: 30, width: 60, height: 30))

        self.viewIsVisibleExpectation = self.expectationWithDescription("viewIsVisible")

        coachMark.computeOrientationInFrame(self.instructionsTopView.frame)
        coachMark.computePointOfInterestInFrame()

        self.coachMarkDisplayManager.displayCoachMarkView(coachMarkView, coachMark: coachMark) {
            XCTAssertEqual(coachMarkView.alpha, 1.0)
            XCTAssertEqual(coachMarkView.hidden, false)

            self.viewIsVisibleExpectation?.fulfill()
        }

        self.waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
