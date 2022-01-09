// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class CoachMarksControllerTests: XCTestCase, TutorialControllerDelegate {

    let tutorialController = TutorialController()
    let parentController = UIViewController()
    let mockedDataSource = CoachMarkControllerMockedDataSource()
    let mockedWindow = UIWindow()

    var delegateEndExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()

        tutorialController.dataSource = self.mockedDataSource
        tutorialController.delegate = self

        mockedWindow.addSubview(self.parentController.view)
    }

    override func tearDown() {
        super.tearDown()
        delegateEndExpectation = nil
    }

    func testThatDidFinishShowingIsCalled() {
        delegateEndExpectation = self.expectation(description: "DidFinishShowing")

        tutorialController.start(in: .newWindow(over: parentController))
        tutorialController.stop()

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatCoachMarkControllerAttachItselfToParent() {
        tutorialController.start(in: .newWindow(over: parentController))

        let attached = (tutorialController.overlay.overlayView.window != nil &&
                        tutorialController.overlay.overlayView.window != mockedWindow)

        XCTAssertTrue(attached)
    }

    func testThatCoachMarkControllerDetachItselfFromParent() {
        delegateEndExpectation = self.expectation(description: "Detachment")

        tutorialController.start(in: .newWindow(over: parentController))
        tutorialController.stop()

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatCoachMarkStoppedBySkipping() {
        delegateEndExpectation = self.expectation(description: "DidFinishShowingBySkipping")

        let skipView = DefaultCoachMarkSkipperView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        tutorialController.skipView = skipView

        tutorialController.start(in: .newWindow(over: parentController))

        skipView.skipControl?.sendActions(for: .touchUpInside)

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func coachMarksController(_ coachMarksController: TutorialController,
                              didEndShowingBySkipping skipped: Bool) {
        guard let delegateEndExpectation = self.delegateEndExpectation else {
            XCTFail("Undefined expectation")
            return
        }

        if delegateEndExpectation.description == "Detachment" {
            XCTAssertTrue(tutorialController.overlay.overlayView.window == nil)
            delegateEndExpectation.fulfill()
        } else if delegateEndExpectation.description == "DidFinishShowing" {
            XCTAssertTrue(true)
            delegateEndExpectation.fulfill()
        } else if delegateEndExpectation.description == "DidFinishShowingBySkipping" {
            XCTAssertTrue(skipped)
            delegateEndExpectation.fulfill()
        } else {
            XCTFail("Invalid expectation")
        }
    }
}

internal class CoachMarkControllerMockedDataSource: TutorialControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: TutorialController) -> Int {
        return 1
    }

    func coachMarksController(_ coachMarksController: TutorialController,
                              coachMarkAt index: Int) -> CoachMarkConfiguration {
        return CoachMarkConfiguration()
    }

    func coachMarksController(
        _ coachMarksController: TutorialController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMarkConfiguration
    ) -> (bodyView: UIView & CoachMarkContentView, arrowView: (UIView & CoachMarkArrowView)?) {
        return (CoachMarkBodyDefaultView(), nil)
    }
}
