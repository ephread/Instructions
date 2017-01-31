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

class DataSourceNumberOfCoachMarksTest: DataSourceBaseTest,
                                        CoachMarksControllerDataSource {

    var delegateEndExpectation: XCTestExpectation? = nil

    override func setUp() {
        super.setUp()

        self.coachMarksController.dataSource = self
    }

    func testNumberOfCoachMarksIsCalled() {
        self.delegateEndExpectation = self.expectation(description: "numberOfCoachMarks")

        self.coachMarksController.startOn(self.parentController)

        self.waitForExpectations(timeout: 2) { error in
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
