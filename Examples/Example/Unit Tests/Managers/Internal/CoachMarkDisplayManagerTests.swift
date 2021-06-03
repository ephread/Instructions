// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class CoachMarkDisplayManagerTests: XCTestCase {

    let overlayView = OverlayView()
    let overlay = OverlayManager()
    let instructionsRootView = UIView()
    let coachMarksController = CoachMarksController()
    var coachMarkDisplayManager: CoachMarkDisplayManager!

    var viewIsVisibleExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()

        self.overlayView.frame = CGRect(x: 0, y: 0, width: 365, height: 667)
        self.instructionsRootView.frame = CGRect(x: 0, y: 0, width: 365, height: 667)

        instructionsRootView.addSubview(overlayView)

        overlay.overlayView = overlayView

        coachMarkDisplayManager =
            CoachMarkDisplayManager(coachMarkLayoutHelper: CoachMarkLayoutHelper())
        coachMarkDisplayManager.overlayManager = overlay
    }

    override func tearDown() {
        super.tearDown()
        viewIsVisibleExpectation = nil
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
                                             at: 0) {
            XCTAssertEqual(coachMarkView.alpha, 1.0)
            XCTAssertEqual(coachMarkView.isHidden, false)

            self.viewIsVisibleExpectation?.fulfill()
        }

        self.waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

}
