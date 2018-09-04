// DataSourceBaseTest.swift
//
// Copyright (c) 2016 Frédéric Maquin <fred@ephread.com>
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

class DataSourceCoachMarkAtTest: DataSourceBaseTest,
                                 CoachMarksControllerDataSource,
                                 CoachMarksControllerDelegate {

    var delegateEndExpectation: XCTestExpectation? = nil
    var numberOfTimesCoachMarkAtWasCalled = 0
    var numberOfTimesCoachMarkViewsAtWasCalled = 0
    var numberOfTimesConstraintsForSkipViewWasCalled = 0

    override func setUp() {
        super.setUp()

        coachMarksController.dataSource = self
        coachMarksController.delegate = self
    }

    func testThatCoachMarkAtIsCalledAtLeastTheNumberOfExpectedTimes() {
        delegateEndExpectation = self.expectation(description: "CoachMarkAt")
        coachMarksController.start(in: .window(over: parentController))

        waitForExpectations(timeout: 2) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatCoachMarkViewsAtIsCalledAtLeastTheNumberOfExpectedTimes() {
        delegateEndExpectation = self.expectation(description: "CoachMarkViewsAt")
        coachMarksController.start(in: .window(over: parentController))

        waitForExpectations(timeout: 2) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatConstraintsForSkipViewIsCalledAtLeastTheNumberOfExpectedTimes() {
        delegateEndExpectation = self.expectation(description: "ConstraintsForSkipView")
        coachMarksController.start(in: .window(over: parentController))

        waitForExpectations(timeout: 2) { error in
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

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark)
    -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
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
            XCTFail()
            return
        }

        if (delegateEndExpectation.description == "CoachMarkAt") {
            if numberOfTimesCoachMarkAtWasCalled >= 4 {
                delegateEndExpectation.fulfill()
            } else {
                XCTFail()
            }
        } else if (delegateEndExpectation.description == "CoachMarkViewsAt") {
            if numberOfTimesCoachMarkViewsAtWasCalled >= 4 {
                delegateEndExpectation.fulfill()
            } else {
                XCTFail()
            }
        } else if (delegateEndExpectation.description == "ConstraintsForSkipView") {
            if numberOfTimesCoachMarkViewsAtWasCalled >= 1 {
                delegateEndExpectation.fulfill()
            } else {
                XCTFail()
            }
        }
    }
}
