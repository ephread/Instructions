// CoachMarkHelperTests.swift
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

class CoachMarkHelperTests: XCTestCase {

    let instructionsRootView = InstructionsRootView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    let flowManager = MockedFlowManager(coachMarksViewController: CoachMarksViewController())

    lazy var coachMarkHelper: CoachMarkHelper = {
        return CoachMarkHelper(instructionsRootView: self.instructionsRootView,
                               flowManager: self.flowManager)
    }()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testThatDefaultCoachMarkIsReturnedWhenViewIsNil() {

        let coachMark1 = coachMarkHelper.makeCoachMark()
        let coachMark2 = coachMarkHelper.makeCoachMark(for: nil)

        XCTAssertTrue(coachMark1 == CoachMark())
        XCTAssertTrue(coachMark2 == CoachMark())
    }

    func testThatReturnedCoachMarkContainsPointOfInterest() {
        let coachMark1 = coachMarkHelper.makeCoachMark(for: UIView(), pointOfInterest: CGPoint(x: 10, y: 20))
        var coachMark2 = CoachMark()

        coachMark2.pointOfInterest = CGPoint(x: 10, y: 20)

        XCTAssertTrue(coachMark1.pointOfInterest == coachMark2.pointOfInterest)
    }

    func testThatDefaultCutoutPathMakerIsUsed() {
        let frame = CGRect(x: 30, y: 30, width: 70, height: 20)
        let coachMark = coachMarkHelper.makeCoachMark(for: UIView(frame: frame))

        if let bezierPath = coachMark.cutoutPath {
            XCTAssertTrue(bezierPath.contains(frame.origin))
            XCTAssertTrue(bezierPath.contains(CGPoint(x: frame.origin.x + frame.size.width,
                                                      y: frame.origin.y)))
            XCTAssertTrue(bezierPath.contains(CGPoint(x: frame.origin.x,
                                                      y: frame.origin.y + frame.size.height)))
            XCTAssertTrue(bezierPath.contains(CGPoint(x: frame.origin.x + frame.size.width,
                                                      y: frame.origin.y + frame.size.height)))
        } else {
            XCTFail("Cutout Path is nil")
        }
    }

    func testThatCustomCutoutPathMakerIsUsed() {
        var control = false;
        let frame = CGRect(x: 30, y: 30, width: 70, height: 20)

        _ = coachMarkHelper.makeCoachMark(for: UIView(frame: frame)) { frame in
            control = true
            return UIBezierPath(rect: frame)
        }

        XCTAssertTrue(control)
    }

    func testThatTopArrowIsLoaded() {
        let views = coachMarkHelper.makeDefaultCoachViews(arrowOrientation: .top)
        let views2 = coachMarkHelper.makeDefaultCoachViews(withArrow: true,
                                                           arrowOrientation: .top,
                                                           hintText: "", nextText: nil)

        let image = UIImage(namedInInstructions: "arrow-top")

        XCTAssertTrue(views.arrowView?.image == image)
        XCTAssertTrue(views2.arrowView?.image == image)
    }

    func testThatTopArrowIsLoadedByDefault() {
        let views = coachMarkHelper.makeDefaultCoachViews()
        let views2 = coachMarkHelper.makeDefaultCoachViews(arrowOrientation: nil)
        let views3 = coachMarkHelper.makeDefaultCoachViews(withArrow: true,
                                                           arrowOrientation: nil,
                                                           hintText: "", nextText: nil)

        let image = UIImage(namedInInstructions: "arrow-top")

        XCTAssertTrue(views.arrowView?.image == image)
        XCTAssertTrue(views2.arrowView?.image == image)
        XCTAssertTrue(views3.arrowView?.image == image)
    }

    func testThatBottomArrowIsLoaded() {
        let views = coachMarkHelper.makeDefaultCoachViews(arrowOrientation: .bottom)
        let views2 = coachMarkHelper.makeDefaultCoachViews(withArrow: true,
                                                           arrowOrientation: .bottom,
                                                           hintText: "", nextText: nil)

        let image = UIImage(namedInInstructions: "arrow-bottom")

        XCTAssertTrue(views.arrowView?.image == image)
        XCTAssertTrue(views2.arrowView?.image == image)
    }

    func testThatCoachMarkViewHasNoArrow() {
        let views1 = coachMarkHelper.makeDefaultCoachViews(withArrow: false)
        let views2 = coachMarkHelper.makeDefaultCoachViews(withArrow: false, arrowOrientation: .bottom)
        let views3 = coachMarkHelper.makeDefaultCoachViews(withArrow: false,
                                                           arrowOrientation: .bottom,
                                                           hintText: "", nextText: nil)

        XCTAssertTrue(views1.arrowView == nil)
        XCTAssertTrue(views2.arrowView == nil)
        XCTAssertTrue(views3.arrowView == nil)
    }

    func testThatCoachMarkBodyHasNextText() {
        let views = coachMarkHelper.makeDefaultCoachViews()

        XCTAssertTrue(views.bodyView.nextLabel.superview != nil)
    }

    func testThatCoachMarkBodyDoesNotHaveNextText() {
        let views = coachMarkHelper.makeDefaultCoachViews(withNextText: false)

        XCTAssertTrue(views.bodyView.nextLabel.superview == nil)
    }

    func testThatCoachMarkBodyHasRightText() {
        let views = coachMarkHelper.makeDefaultCoachViews(hintText: "Hint", nextText: nil)
        let views2 = coachMarkHelper.makeDefaultCoachViews(hintText: "Hint", nextText: "Next")

        XCTAssertTrue(views.bodyView.hintLabel.text == "Hint")
        XCTAssertTrue(views.bodyView.nextLabel.text == nil)
        XCTAssertTrue(views.bodyView.nextLabel.superview == nil)

        XCTAssertTrue(views2.bodyView.hintLabel.text == "Hint")
        XCTAssertTrue(views2.bodyView.nextLabel.text == "Next")
        XCTAssertTrue(views2.bodyView.nextLabel.superview != nil)
    }

    func testThatUpdateDidNotOccur() {
        flowManager.paused = true
        flowManager.currentCoachMark = CoachMark()

        coachMarkHelper.updateCurrentCoachMark()

        XCTAssertTrue(flowManager.currentCoachMark == CoachMark())

        flowManager.paused = false
        flowManager.currentCoachMark = nil

        coachMarkHelper.updateCurrentCoachMark()

        XCTAssertTrue(flowManager.currentCoachMark == nil)

        flowManager.paused = false
        flowManager.currentCoachMark = CoachMark()

        coachMarkHelper.updateCurrentCoachMark()

        XCTAssertTrue(flowManager.currentCoachMark ==  CoachMark())
    }
}

class MockedFlowManager: FlowManager {
    private var _pause = false;

    override var paused: Bool {
        get {
            return _pause
        }

        set {
            _pause = newValue
        }
    }
}
