// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class DataSourceNumberOfCoachMarksTest: DataSourceBaseTest,
                                        CoachMarksControllerDataSource {

    var delegateEndExpectation: XCTestExpectation? = nil

    override func setUp() {
        super.setUp()
        coachMarksController.dataSource = self
    }

    func testNumberOfCoachMarksIsCalled() {
        delegateEndExpectation = self.expectation(description: "numberOfCoachMarks")
        coachMarksController.start(in: .window(over: parentController))

        waitForExpectations(timeout: 2) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }


    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        guard let delegateEndExpectation = self.delegateEndExpectation else {
            XCTFail()
            return 0
        }

        if (delegateEndExpectation.description == "numberOfCoachMarks") {
            delegateEndExpectation.fulfill()
        }

        return 4
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        return CoachMark()
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark)
        -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
            return (bodyView: CoachMarkBodyDefaultView(), arrowView: nil)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              constraintsForSkipView skipView: UIView,
                              inParent parentView: UIView) -> [NSLayoutConstraint]? {
        return nil
    }
}
