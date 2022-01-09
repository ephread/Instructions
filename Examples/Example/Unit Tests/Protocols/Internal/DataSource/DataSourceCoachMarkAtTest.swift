// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class DataSourceCoachMarkAtTest: DataSourceBaseTest,
                                 TutorialControllerDataSource,
                                 TutorialControllerDelegate {

    var delegateEndExpectation: XCTestExpectation?
    var numberOfTimesCoachMarkAtWasCalled = 0
    var numberOfTimesCoachMarkViewsAtWasCalled = 0
    var numberOfTimesConstraintsForSkipViewWasCalled = 0

    override func setUp() {
        super.setUp()

        tutorialController.dataSource = self
        tutorialController.delegate = self
    }

    override func tearDown() {
        super.tearDown()
        delegateEndExpectation = nil
    }

    func testThatCoachMarkAtIsCalledAtLeastTheNumberOfExpectedTimes() {
        delegateEndExpectation = self.expectation(description: "CoachMarkAt")
        tutorialController.start(in: .newWindow(over: parentController))

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatCoachMarkViewsAtIsCalledAtLeastTheNumberOfExpectedTimes() {
        delegateEndExpectation = self.expectation(description: "CoachMarkViewsAt")
        tutorialController.start(in: .newWindow(over: parentController))

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatConstraintsForSkipViewIsCalledAtLeastTheNumberOfExpectedTimes() {
        delegateEndExpectation = self.expectation(description: "ConstraintsForSkipView")
        tutorialController.start(in: .newWindow(over: parentController))

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func numberOfCoachMarks(for coachMarksController: TutorialController) -> Int {
        return 4
    }

    func coachMarksController(_ coachMarksController: TutorialController,
                              coachMarkAt index: Int) -> CoachMarkConfiguration {
        numberOfTimesCoachMarkAtWasCalled += 1

        return CoachMarkConfiguration()
    }

    func coachMarksController(
        _ coachMarksController: TutorialController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMarkConfiguration
    ) -> (bodyView: (UIView & CoachMarkContentView), arrowView: (UIView & CoachMarkArrowView)?) {
            numberOfTimesCoachMarkViewsAtWasCalled += 1
            return (bodyView: CoachMarkBodyDefaultView(), arrowView: nil)
    }

    func coachMarksController(_ coachMarksController: TutorialController,
                              constraintsForSkipView skipView: UIView,
                              inParent parentView: UIView) -> [NSLayoutConstraint]? {
        numberOfTimesConstraintsForSkipViewWasCalled += 1
        return nil
    }

    func coachMarksController(_ coachMarksController: TutorialController,
                              didShow coachMark: CoachMarkConfiguration,
                              afterChanging change: ConfigurationChange,
                              at index: Int) {
        if change == .nothing {
            tutorialController.flow.showNext()
        }
    }

    func coachMarksController(_ coachMarksController: TutorialController, didEndShowingBySkipping skipped: Bool) {
        guard let delegateEndExpectation = self.delegateEndExpectation else {
            XCTFail("Undefined expectation")
            return
        }

        if delegateEndExpectation.description == "CoachMarkAt" {
            if numberOfTimesCoachMarkAtWasCalled >= 4 {
                delegateEndExpectation.fulfill()
                return
            }
        } else if delegateEndExpectation.description == "CoachMarkViewsAt" {
            if numberOfTimesCoachMarkViewsAtWasCalled >= 4 {
                delegateEndExpectation.fulfill()
                return
            }
        } else if delegateEndExpectation.description == "ConstraintsForSkipView" {
            if numberOfTimesCoachMarkViewsAtWasCalled >= 1 {
                delegateEndExpectation.fulfill()
                return
            }
        }

        XCTFail("Unfulfilled expectation")
    }
}
