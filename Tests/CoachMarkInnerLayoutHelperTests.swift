// CoachMarkInnerLayoutHelperTests.swift
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

    func testThatHorizontalConstraintArrayIsEmptyWhenSuperviewDoesNotExist() {
        let constraints =
            layoutHelper.horizontalConstraints(forBody: UIView())

        XCTAssertTrue(constraints.isEmpty)
    }

    func testThatHorizontalConstraintArrayIsNotEmptyWhenSuperviewExists() {
        let parent = UIView()
        let body = UIView()
        parent.addSubview(body)

        let constraints =
            layoutHelper.horizontalConstraints(forBody: body)

        XCTAssertFalse(constraints.isEmpty)
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

    func testThatVerticalConstraintArraysAreDifferentsDependingOnParameters() {
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

//    func testThathorizontalArrowConstraintsAreReturned() {
//        let constraint =
//            layoutHelper.horizontalArrowConstraints(for: (bodyView: UIView(), arrowView: UIView()),
//                                                    withPosition: .center,
//                                                    horizontalOffset: 0)
//
//        XCTAssertTrue(constraint != nil)
//    }
}
