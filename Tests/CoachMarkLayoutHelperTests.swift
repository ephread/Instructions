// CoachMarkLayoutHelperTests.swift
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
//
// TODO: More equality tests might be required
class CoachMarkLayoutHelperTests: XCTestCase {

    var layoutHelper = CoachMarkLayoutHelper()
    var parentView: UIView!
    var bodyView: CoachMarkBodyDefaultView!
    var arrowView: CoachMarkArrowDefaultView!
    
    override func setUp() {
        super.setUp()

        parentView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        bodyView = CoachMarkBodyDefaultView()
        arrowView = CoachMarkArrowDefaultView(orientation: .top)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    // We're not testing anything about constraints themselves (a visual check is better).
    // We're only testing that they are differents in the given cases and present.
    func testThatHorizontalConstraintArrayAreDifferentDependingOnParameters() {
        assert(constraints: constraints())
    }

    // We're not testing anything about constraints themselves (a visual check is better).
    // We're only testing that they are differents in the given cases and present.
    func testThatHorizontalConstraintArrayisEmptyIfCoachMarkViewParentDoesNotMatchParentView() {
        let coachMarkView = CoachMarkView(bodyView: self.bodyView, arrowView: self.arrowView,
                                          arrowOrientation: .bottom, arrowOffset: 0,
                                          coachMarkInnerLayoutHelper: CoachMarkInnerLayoutHelper())

        let constraints = layoutHelper.constraints(for: coachMarkView, coachMark: CoachMark(),
                                                   parentView: parentView)

        XCTAssertTrue(constraints.isEmpty)
    }

    func testThatConstraintsAreDifferentDependingOnLayoutDirection() {
        let constraintsLtr = constraints(using: .leftToRight)
        let constraintsRtl = constraints(using: .rightToLeft)

        assert(constraints: constraintsLtr)
        assert(constraints: constraintsRtl)

        for i in 0..<constraintsLtr.count {
            XCTAssertTrue(constraintsLtr[i] != constraintsRtl[i])
        }

    }

    private func assert(constraints constraintsToTest: [[NSLayoutConstraint]]) {
        XCTAssertFalse(constraintsToTest[0].isEmpty)
        XCTAssertFalse(constraintsToTest[1].isEmpty)
        XCTAssertFalse(constraintsToTest[2].isEmpty)
        XCTAssertFalse(constraintsToTest[3].isEmpty)

        XCTAssertTrue(constraintsToTest[0] != constraintsToTest[1])
        XCTAssertTrue(constraintsToTest[0] != constraintsToTest[2])
        XCTAssertTrue(constraintsToTest[0] != constraintsToTest[3])
        XCTAssertTrue(constraintsToTest[1] != constraintsToTest[2])
        XCTAssertTrue(constraintsToTest[1] != constraintsToTest[3])
        XCTAssertTrue(constraintsToTest[2] != constraintsToTest[3])
    }

    private func constraints(using layoutDirection: UIUserInterfaceLayoutDirection = .leftToRight) -> [[NSLayoutConstraint]] {
        var coachMark1 = CoachMark()

        coachMark1.cutoutPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 50, height: 50))
        coachMark1.pointOfInterest = CGPoint(x: 25, y: 25)

        let coachMarkView1 = CoachMarkView(bodyView: self.bodyView, arrowView: self.arrowView,
                                           arrowOrientation: .top, arrowOffset: 0,
                                           coachMarkInnerLayoutHelper: CoachMarkInnerLayoutHelper())

        parentView.addSubview(coachMarkView1)

        var coachMark2 = CoachMark()
        coachMark2.cutoutPath = UIBezierPath(rect: CGRect(x: 135, y: 150, width: 50, height: 50))
        coachMark2.pointOfInterest = CGPoint(x: 160, y: 175)

        let coachMarkView2 = CoachMarkView(bodyView: self.bodyView, arrowView: self.arrowView,
                                           arrowOrientation: .top, arrowOffset: 0,
                                           coachMarkInnerLayoutHelper: CoachMarkInnerLayoutHelper())

        parentView.addSubview(coachMarkView2)

        var coachMark3 = CoachMark()
        coachMark3.cutoutPath = UIBezierPath(rect: CGRect(x: 270, y: 300, width: 50, height: 50))
        coachMark3.pointOfInterest = CGPoint(x: 295, y: 325)

        let coachMarkView3 = CoachMarkView(bodyView: self.bodyView, arrowView: self.arrowView,
                                           arrowOrientation: .bottom, arrowOffset: 0,
                                           coachMarkInnerLayoutHelper: CoachMarkInnerLayoutHelper())

        parentView.addSubview(coachMarkView3)

        var coachMark4 = CoachMark()
        coachMark4.cutoutPath = UIBezierPath(rect: CGRect(x: 135, y: 400, width: 50, height: 50))

        let coachMarkView4 = CoachMarkView(bodyView: self.bodyView, arrowView: self.arrowView,
                                           arrowOrientation: .bottom, arrowOffset: 0,
                                           coachMarkInnerLayoutHelper: CoachMarkInnerLayoutHelper())

        parentView.addSubview(coachMarkView4)

        let constraints1 =
            layoutHelper.constraints(for: coachMarkView1, coachMark: coachMark1, parentView: parentView,
                                     layoutDirection: layoutDirection)

        let constraints2 =
            layoutHelper.constraints(for: coachMarkView2, coachMark: coachMark2, parentView: parentView,
                                     layoutDirection: layoutDirection)

        let constraints3 =
            layoutHelper.constraints(for: coachMarkView3, coachMark: coachMark3, parentView: parentView,
                                     layoutDirection: layoutDirection)

        let constraints4 =
            layoutHelper.constraints(for: coachMarkView4, coachMark: coachMark4, parentView: parentView,
                                     layoutDirection: layoutDirection)

        return [constraints1, constraints2, constraints3, constraints4]
    }
}
