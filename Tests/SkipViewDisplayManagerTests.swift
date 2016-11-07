// SkipViewDisplayManagerTests.swift
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

class SkipViewDisplayManagerTests: XCTestCase {
    let skipViewDisplayManager = SkipViewDisplayManager()
    let dataSource = MockedDataSource()
    let constraintsDataSource = ConstraintsMockedDataSource()
    
    var delegateEndExpectation: XCTestExpectation? = nil

    override func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
        skipViewDisplayManager.dataSource = dataSource
    }

    func testThatSkipViewWasHidden() {
        let skipView = CoachMarkSkipDefaultView()
        skipView.alpha = 1.0;

        skipViewDisplayManager.hide(skipView: skipView)
        XCTAssertEqual(skipView.alpha, 0.0)

        skipView.alpha = 1.0;

        skipViewDisplayManager.hide(skipView: skipView, duration: 2)
        XCTAssertEqual(skipView.alpha, 0.0)
    }

    func testThatSkipViewWithNoParentCannotBeShown() {
        let skipView = CoachMarkSkipDefaultView()
        skipView.alpha = 0.0;

        skipViewDisplayManager.show(skipView: skipView)
        XCTAssertEqual(skipView.alpha, 0.0)

        skipView.alpha = 0.0;

        skipViewDisplayManager.show(skipView: skipView, duration: 2)
        XCTAssertEqual(skipView.alpha, 0.0)
    }

    func testThatSkipViewWithParentCanBeShown() {
        let parentView = UIView()
        let skipView = CoachMarkSkipDefaultView()
        parentView.addSubview(skipView)

        skipView.alpha = 0.0;

        skipViewDisplayManager.show(skipView: skipView)
        XCTAssertEqual(skipView.alpha, 1.0)

        skipView.alpha = 0.0;

        skipViewDisplayManager.show(skipView: skipView, duration: 2)
        XCTAssertEqual(skipView.alpha, 1.0)
    }

    func testThatDefaultConstraintAreApplied() {
        let parentView = UIView()
        let skipView = CoachMarkSkipDefaultView()
        parentView.addSubview(skipView)

        XCTAssertTrue(parentView.constraints.isEmpty)

        skipViewDisplayManager.show(skipView: skipView)

        XCTAssertFalse(parentView.constraints.isEmpty)
    }

    func testThatConstraintIsApplied() {
        let parentView = UIView()
        let skipView = CoachMarkSkipDefaultView()
        parentView.addSubview(skipView)
        skipViewDisplayManager.dataSource = constraintsDataSource

        XCTAssertTrue(parentView.constraints.isEmpty)

        skipViewDisplayManager.show(skipView: skipView)

        XCTAssertFalse(parentView.constraints.contains(makeConstraint(skipView: skipView, inParent: parentView)))
    }

    func testThatDefaultConstraintIsAppliedIfDataSourceIsNil() {
        let parentView = UIView()
        let skipView = CoachMarkSkipDefaultView()
        parentView.addSubview(skipView)
        skipViewDisplayManager.dataSource = nil

        XCTAssertTrue(parentView.constraints.isEmpty)

        skipViewDisplayManager.show(skipView: skipView)

        XCTAssertFalse(parentView.constraints.isEmpty)
    }

    func testThatSkipViewIsNotUpdated() {
        let skipView = CoachMarkSkipDefaultView()
        skipViewDisplayManager.update(skipView: skipView, withConstraints: nil)

        XCTAssertTrue(true)
    }
}

class MockedDataSource: CoachMarksControllerProxyDataSource {
    func numberOfCoachMarks() -> Int {
        return 0
    }

    func coachMark(at index: Int) -> CoachMark {
        return CoachMark()
    }

    func coachMarkViews(at index: Int, madeFrom coachMark: CoachMark)
        -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        return (bodyView: CoachMarkBodyDefaultView(), arrowView: nil)
    }

    func constraintsForSkipView(_ skipView: UIView,
                                inParent parentView: UIView) -> [NSLayoutConstraint]? {
        return nil
    }
}

class ConstraintsMockedDataSource: MockedDataSource {
    override func constraintsForSkipView(_ skipView: UIView,
                                inParent parentView: UIView) -> [NSLayoutConstraint]? {
        return [makeConstraint(skipView: skipView, inParent: parentView)]
    }
}

private func makeConstraint(skipView: UIView, inParent parentView: UIView) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: skipView, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: 0)
}
