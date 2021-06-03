// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class DataSourceCoachMarkAtTest: DataSourceBaseTest,
                                 CoachMarksControllerDataSource,
                                 CoachMarksControllerDelegate {

    var delegateEndExpectation: XCTestExpectation?
    var numberOfTimesCoachMarkAtWasCalled = 0
    var numberOfTimesCoachMarkViewsAtWasCalled = 0
    var numberOfTimesConstraintsForSkipViewWasCalled = 0

    override func setUp() {
        super.setUp()

        coachMarksController.dataSource = self
        coachMarksController.delegate = self
    }

    override func tearDown() {
        super.tearDown()
        delegateEndExpectation = nil
    }

    func testThatCoachMarkAtIsCalledAtLeastTheNumberOfExpectedTimes() {
        delegateEndExpectation = self.expectation(description: "CoachMarkAt")
        coachMarksController.start(in: .window(over: parentController))

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatCoachMarkViewsAtIsCalledAtLeastTheNumberOfExpectedTimes() {
        delegateEndExpectation = self.expectation(description: "CoachMarkViewsAt")
        coachMarksController.start(in: .window(over: parentController))

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatConstraintsForSkipViewIsCalledAtLeastTheNumberOfExpectedTimes() {
        delegateEndExpectation = self.expectation(description: "ConstraintsForSkipView")
        coachMarksController.start(in: .window(over: parentController))

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 4
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        numberOfTimesCoachMarkAtWasCalled += 1

        return CoachMark()
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
            numberOfTimesCoachMarkViewsAtWasCalled += 1
            return (bodyView: CoachMarkBodyDefaultView(), arrowView: nil)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              constraintsForSkipView skipView: UIView,
                              inParent parentView: UIView) -> [NSLayoutConstraint]? {
        numberOfTimesConstraintsForSkipViewWasCalled += 1
        return nil
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didShow coachMark: CoachMark,
                              afterChanging change: ConfigurationChange,
                              at index: Int) {
        if change == .nothing {
            coachMarksController.flow.showNext()
        }
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingBySkipping skipped: Bool) {
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
