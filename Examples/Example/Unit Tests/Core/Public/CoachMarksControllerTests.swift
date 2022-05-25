// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class CoachMarksControllerTests: XCTestCase, CoachMarksControllerDelegate {

    let coachMarksController = CoachMarksController()
    let parentController = UIViewController()
    let mockedDataSource = CoachMarkControllerMockedDataSource()
    let mockedWindow = UIWindow()

    var delegateEndExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()

        coachMarksController.dataSource = self.mockedDataSource
        coachMarksController.delegate = self

        mockedWindow.addSubview(self.parentController.view)
    }

    override func tearDown() {
        super.tearDown()
        delegateEndExpectation = nil
    }

    func testThatDidFinishShowingIsCalled() {
        delegateEndExpectation = self.expectation(description: "DidFinishShowing")

        coachMarksController.start(in: .window(over: parentController))
        coachMarksController.stop()

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatCoachMarkControllerAttachItselfToParent() {
        coachMarksController.start(in: .window(over: parentController))

        let attached = (coachMarksController.overlay.overlayView.window != nil &&
                        coachMarksController.overlay.overlayView.window != mockedWindow)

        XCTAssertTrue(attached)
    }

    func testThatCoachMarkControllerDetachItselfFromParent() {
        delegateEndExpectation = self.expectation(description: "Detachment")

        coachMarksController.start(in: .window(over: parentController))
        coachMarksController.stop()

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatCoachMarkStoppedBySkipping() {
        delegateEndExpectation = self.expectation(description: "DidFinishShowingBySkipping")

        let skipView = CoachMarkSkipDefaultView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        coachMarksController.skipView = skipView

        coachMarksController.start(in: .window(over: parentController))

        skipView.skipControl?.sendActions(for: .touchUpInside)

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatDidFinishShowingBySkippingIsNotCalledWhenStoppingImmediately() {
        delegateEndExpectation = self.expectation(description: "StopImmediately")
        delegateEndExpectation?.isInverted = true

        coachMarksController.start(in: .window(over: parentController))
        coachMarksController.stop(immediately: true)

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatSkippedIsTrueWhenSkippingAndStoppingTheFlow() {
        delegateEndExpectation = self.expectation(description: "StopAndEmulateSkip")

        coachMarksController.start(in: .window(over: parentController))
        coachMarksController.stop(emulatingSkip: true)

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatSkippedIsFalseWhenStoppingTheFlow() {
        delegateEndExpectation = self.expectation(description: "StopAndDoNotEmulateSkip")

        coachMarksController.start(in: .window(over: parentController))
        coachMarksController.stop()

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatRootWindowIsExposedWhenUsingNewWindowContext() {
        coachMarksController.start(in: .window(over: parentController))
        XCTAssertNotNil(coachMarksController.rootWindow)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didEndShowingBySkipping skipped: Bool) {
        guard let delegateEndExpectation = self.delegateEndExpectation else {
            XCTFail("Undefined expectation")
            return
        }

        if delegateEndExpectation.description == "Detachment" {
            XCTAssertTrue(coachMarksController.overlay.overlayView.window == nil)
            delegateEndExpectation.fulfill()
        } else if delegateEndExpectation.description == "DidFinishShowing" {
            XCTAssertTrue(true)
            delegateEndExpectation.fulfill()
        } else if delegateEndExpectation.description == "DidFinishShowingBySkipping" {
            XCTAssertTrue(skipped)
            delegateEndExpectation.fulfill()
        } else if delegateEndExpectation.description == "StopAndEmulateSkip" {
            XCTAssertTrue(skipped)
            delegateEndExpectation.fulfill()
        } else if delegateEndExpectation.description == "StopAndDoNotEmulateSkip" {
            XCTAssertFalse(skipped)
            delegateEndExpectation.fulfill()
        } else {
            XCTFail("Invalid expectation")
        }
    }
}

internal class CoachMarkControllerMockedDataSource: CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        return CoachMark()
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: UIView & CoachMarkBodyView, arrowView: (UIView & CoachMarkArrowView)?) {
        return (CoachMarkBodyDefaultView(), nil)
    }
}
