// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

// Since we are not going to test static constraints definitions
// this tests will only make sure that the constraints returned are
// not empty.
class CoachMarkInnerLayoutHelperTests: XCTestCase {

    let layoutHelper = CoachMarkInnerLayoutHelper()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testThatVerticalConstraintArrayIsNotEmpty() {
        let parent = UIView()
        let body = UIView()
        parent.addSubview(body)

        let constraints =
            layoutHelper.verticalConstraints(for: (bodyView: UIView(), arrowView: UIView()),
                                             in: UIView(),
                                             withProperties: (orientation: .bottom,
                                                              verticalArrowOffset: 0))

        XCTAssertFalse(constraints.isEmpty)
    }

    func testThatVerticalConstraintArraysAreDifferentDependingOnParameters() {
        let parent = UIView()
        let body = UIView()
        parent.addSubview(body)

        let constraints1 =
            layoutHelper.verticalConstraints(for: (bodyView: UIView(), arrowView: UIView()),
                                             in: UIView(),
                                             withProperties: (orientation: .bottom,
                                                              verticalArrowOffset: 0))

        let constraints2 =
            layoutHelper.verticalConstraints(for: (bodyView: UIView(), arrowView: UIView()),
                                             in: UIView(),
                                             withProperties: (orientation: .top,
                                                              verticalArrowOffset: 0))

        XCTAssertFalse(constraints1 == constraints2)
    }

//    func testThatHorizontalArrowConstraintsAreReturned() {
//        let constraint =
//            layoutHelper.horizontalArrowConstraints(for: (bodyView: UIView(), arrowView: UIView()),
//                                                    withPosition: .center,
//                                                    horizontalOffset: 0)
//
//        XCTAssertTrue(constraint != nil)
//    }
}
