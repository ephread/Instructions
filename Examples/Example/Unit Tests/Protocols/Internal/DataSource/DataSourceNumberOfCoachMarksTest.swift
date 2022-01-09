// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class DataSourceNumberOfCoachMarksTest: DataSourceBaseTest,
                                        TutorialControllerDataSource {

    var delegateEndExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
        tutorialController.dataSource = self
    }

    override func tearDown() {
        super.tearDown()
        delegateEndExpectation = nil
    }

    func testNumberOfCoachMarksIsCalled() {
        delegateEndExpectation = self.expectation(description: "numberOfCoachMarks")
        tutorialController.start(in: .newWindow(over: parentController))

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func numberOfCoachMarks(for coachMarksController: TutorialController) -> Int {
        guard let delegateEndExpectation = self.delegateEndExpectation else {
            XCTFail("Undefined expectation")
            return 0
        }

        if delegateEndExpectation.description == "numberOfCoachMarks" {
            delegateEndExpectation.fulfill()
        }

        return 4
    }

    func coachMarksController(_ coachMarksController: TutorialController,
                              coachMarkAt index: Int) -> CoachMarkConfiguration {
        return CoachMarkConfiguration()
    }

    func coachMarksController(
        _ coachMarksController: TutorialController,
        coachMarkViewsAt index: Int, madeFrom coachMark: CoachMarkConfiguration
    ) -> (bodyView: (UIView & CoachMarkContentView), arrowView: (UIView & CoachMarkArrowView)?) {
            return (bodyView: CoachMarkBodyDefaultView(), arrowView: nil)
    }

    func coachMarksController(_ coachMarksController: TutorialController,
                              constraintsForSkipView skipView: UIView,
                              inParent parentView: UIView) -> [NSLayoutConstraint]? {
        return nil
    }
}
