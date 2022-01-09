// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class SkipViewDisplayManagerTests: XCTestCase {
    let skipViewDisplayManager = SkippingManager()
    let dataSource = MockedDataSource()
    let constraintsDataSource = ConstraintsMockedDataSource()

    var delegateEndExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
        skipViewDisplayManager.dataSource = dataSource
    }

    override func tearDown() {
        super.tearDown()
        delegateEndExpectation = nil
    }

    func testThatSkipViewWasHidden() {
        let skipView = DefaultCoachMarkSkipperView()
        skipView.alpha = 1.0

        skipViewDisplayManager.hide(skipView: skipView)
        XCTAssertEqual(skipView.alpha, 0.0)

        skipView.alpha = 1.0

        skipViewDisplayManager.hide(skipView: skipView, duration: 2)
        XCTAssertEqual(skipView.alpha, 0.0)
    }

    func testThatSkipViewWithNoParentCannotBeShown() {
        let skipView = DefaultCoachMarkSkipperView()
        skipView.alpha = 0.0

        skipViewDisplayManager.show(skipView: skipView)
        XCTAssertEqual(skipView.alpha, 0.0)

        skipView.alpha = 0.0

        skipViewDisplayManager.show(skipView: skipView, duration: 2)
        XCTAssertEqual(skipView.alpha, 0.0)
    }

    func testThatSkipViewWithParentCanBeShown() {
        let parentView = UIView()
        let skipView = DefaultCoachMarkSkipperView()
        parentView.addSubview(skipView)

        skipView.alpha = 0.0

        skipViewDisplayManager.show(skipView: skipView)
        XCTAssertEqual(skipView.alpha, 1.0)

        skipView.alpha = 0.0

        skipViewDisplayManager.show(skipView: skipView, duration: 2)
        XCTAssertEqual(skipView.alpha, 1.0)
    }

    func testThatDefaultConstraintAreApplied() {
        let parentView = UIView()
        let skipView = DefaultCoachMarkSkipperView()
        parentView.addSubview(skipView)

        XCTAssertTrue(parentView.constraints.isEmpty)

        skipViewDisplayManager.show(skipView: skipView)

        XCTAssertFalse(parentView.constraints.isEmpty)
    }

    func testThatConstraintIsApplied() {
        let parentView = UIView()
        let skipView = DefaultCoachMarkSkipperView()
        parentView.addSubview(skipView)
        skipViewDisplayManager.dataSource = constraintsDataSource

        XCTAssertTrue(parentView.constraints.isEmpty)

        skipViewDisplayManager.show(skipView: skipView)

        XCTAssertFalse(parentView.constraints.contains(makeConstraint(skipView: skipView, inParent: parentView)))
    }

    func testThatDefaultConstraintIsAppliedIfDataSourceIsNil() {
        let parentView = UIView()
        let skipView = DefaultCoachMarkSkipperView()
        parentView.addSubview(skipView)
        skipViewDisplayManager.dataSource = nil

        XCTAssertTrue(parentView.constraints.isEmpty)

        skipViewDisplayManager.show(skipView: skipView)

        XCTAssertFalse(parentView.constraints.isEmpty)
    }

    func testThatSkipViewIsNotUpdated() {
        let skipView = DefaultCoachMarkSkipperView()
        skipViewDisplayManager.update(skipView: skipView, withConstraints: nil)

        XCTAssertTrue(true)
    }
}

class MockedDataSource: TutorialControllerProxyDataSource {
    func numberOfCoachMarks() -> Int {
        return 0
    }

    func coachMark(at index: Int) -> CoachMarkConfiguration {
        return CoachMarkConfiguration()
    }

    func coachMarkViews(
        at index: Int,
        madeFrom coachMark: CoachMarkConfiguration
    ) -> (bodyView: (UIView & CoachMarkContentView), arrowView: (UIView & CoachMarkArrowView)?) {
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
    return skipView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
}
