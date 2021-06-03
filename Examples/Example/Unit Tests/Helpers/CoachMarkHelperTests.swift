// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class CoachMarkHelperTests: XCTestCase {
    // MARK: - Properties
    private let defaultScreenSize = CGRect(x: 0, y: 0, width: 320, height: 480)

    private let flowManager = {
        MockedFlowManager(coachMarksViewController: CoachMarksViewController())
    }()

    private let cutoutMaker: (CGRect) -> UIBezierPath = { frame in
        UIBezierPath(rect: frame)
    }

    private lazy var instructionsRootView = InstructionsRootView(frame: defaultScreenSize)

    private lazy var coachMarkHelper: CoachMarkHelper = {
        return CoachMarkHelper(instructionsRootView: self.instructionsRootView,
                               flowManager: self.flowManager)
    }()

    // MARK: - Overridden Methods
    override func tearDown() {
        super.tearDown()
        instructionsRootView.removeFromSuperview()
        instructionsRootView.subviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - 'Update Logic' Tests
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
        var control = false
        let frame = CGRect(x: 30, y: 30, width: 70, height: 20)

        _ = coachMarkHelper.makeCoachMark(for: UIView(frame: frame)) { frame in
            control = true
            return UIBezierPath(rect: frame)
        }

        XCTAssertTrue(control)
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

        XCTAssertTrue(views.bodyView.nextLabel.isHidden)
    }

    func testThatCoachMarkBodyHasRightText() {
        let views = coachMarkHelper.makeDefaultCoachViews(hintText: "Hint", nextText: nil)
        let views2 = coachMarkHelper.makeDefaultCoachViews(hintText: "Hint", nextText: "Next")

        XCTAssertTrue(views.bodyView.hintLabel.text == "Hint")
        XCTAssertTrue(views.bodyView.nextLabel.text == nil)
        XCTAssertTrue(views.bodyView.nextLabel.isHidden)

        XCTAssertTrue(views2.bodyView.hintLabel.text == "Hint")
        XCTAssertTrue(views2.bodyView.nextLabel.text == "Next")
        XCTAssertFalse(views2.bodyView.nextLabel.isHidden)
    }

    // MARK: - 'Coordinate Conversion' Tests
    func testThatCoordinatesAreConvertedProperlyWithInstructionsWindow() {
        let instructionsWindow = InstructionsRootView(frame: defaultScreenSize)
        let anchorWindow = InstructionsRootView(frame: defaultScreenSize)

        let anchorSuperview = UIView(frame: CGRect(x: 70, y: 90, width: 100, height: 100))
        let anchorView = UIView(frame: CGRect(x: 30, y: 40, width: 50, height: 50))
        let anchorPointOfInterest = CGPoint(x: 55, y: 65)

        let updatedAnchorSuperview = UIView(frame: CGRect(x: 90, y: 25, width: 50, height: 50))
        let updatedFrame = CGRect(x: 20, y: 70, width: 20, height: 300)

        anchorWindow.addSubview(anchorSuperview)
        anchorWindow.addSubview(updatedAnchorSuperview)
        anchorSuperview.addSubview(anchorView)
        instructionsWindow.addSubview(instructionsRootView)

        let coachMark = coachMarkHelper.makeCoachMark(for: anchorView,
                                                      cutoutPathMaker: cutoutMaker)

        var coachMark2 = coachMarkHelper.makeCoachMark(forFrame: anchorView.frame,
                                                       pointOfInterest: anchorPointOfInterest,
                                                       in: anchorSuperview,
                                                       cutoutPathMaker: cutoutMaker)

        guard let cutoutPath = coachMark.cutoutPath else {
            XCTFail("The cutout path is nil.")
            return
        }

        guard let cutoutPath2 = coachMark2.cutoutPath else {
            XCTFail("The cutout path is nil.")
            return
        }

        guard let pointOfInterest2 = coachMark2.pointOfInterest else {
            XCTFail("The cutout path is nil.")
            return
        }

        XCTAssertEqual(cutoutPath.bounds, CGRect(x: 100, y: 130, width: 50, height: 50))
        XCTAssertEqual(cutoutPath2.bounds, CGRect(x: 100, y: 130, width: 50, height: 50))
        XCTAssertEqual(pointOfInterest2, CGPoint(x: 125, y: 155))

        coachMarkHelper.update(coachMark: &coachMark2,
                               usingFrame: updatedFrame,
                               pointOfInterest: nil,
                               superview: updatedAnchorSuperview,
                               cutoutPathMaker: cutoutMaker)

        guard let updatedCutoutPath2 = coachMark2.cutoutPath else {
            XCTFail("The cutout path is nil.")
            return
        }

        guard let updatedPointOfInterest2 = coachMark2.pointOfInterest else {
            XCTFail("The cutout path is nil.")
            return
        }

        XCTAssertEqual(updatedCutoutPath2.bounds, CGRect(x: 110, y: 95, width: 20, height: 300))
        XCTAssertEqual(updatedPointOfInterest2, CGPoint(x: 125, y: 155))
    }

    func testThatCoordinatesAreConvertedProperlyWithInstructionsWindowOfArbitrarySize() {
        let instructionsWindow = InstructionsRootView(frame: CGRect(x: 20, y: 20,
                                                                    width: 220, height: 340))

        let anchorWindow = InstructionsRootView(frame: defaultScreenSize)

        let anchorSuperview = UIView(frame: CGRect(x: 70, y: 90, width: 100, height: 100))
        let anchorView = UIView(frame: CGRect(x: 30, y: 40, width: 50, height: 50))
        let anchorPointOfInterest = CGPoint(x: 55, y: 65)

        let updatedAnchorSuperview = UIView(frame: CGRect(x: 90, y: 25, width: 50, height: 50))
        let updatedFrame = CGRect(x: 20, y: 70, width: 20, height: 300)

        anchorWindow.addSubview(anchorSuperview)
        anchorWindow.addSubview(updatedAnchorSuperview)
        anchorSuperview.addSubview(anchorView)
        instructionsWindow.addSubview(instructionsRootView)

        let coachMark = coachMarkHelper.makeCoachMark(for: anchorView,
                                                      cutoutPathMaker: cutoutMaker)

        var coachMark2 = coachMarkHelper.makeCoachMark(forFrame: anchorView.frame,
                                                       pointOfInterest: anchorPointOfInterest,
                                                       in: anchorSuperview,
                                                       cutoutPathMaker: cutoutMaker)

        guard let cutoutPath = coachMark.cutoutPath else {
            XCTFail("The cutout path is nil.")
            return
        }

        guard let cutoutPath2 = coachMark2.cutoutPath else {
            XCTFail("The cutout path is nil.")
            return
        }

        guard let pointOfInterest2 = coachMark2.pointOfInterest else {
            XCTFail("The cutout path is nil.")
            return
        }

        XCTAssertEqual(cutoutPath.bounds, CGRect(x: 80, y: 110, width: 50, height: 50))
        XCTAssertEqual(cutoutPath2.bounds, CGRect(x: 80, y: 110, width: 50, height: 50))
        XCTAssertEqual(pointOfInterest2, CGPoint(x: 105, y: 135))

        coachMarkHelper.update(coachMark: &coachMark2,
                               usingFrame: updatedFrame,
                               pointOfInterest: nil,
                               superview: updatedAnchorSuperview,
                               cutoutPathMaker: cutoutMaker)

        guard let updatedCutoutPath2 = coachMark2.cutoutPath else {
            XCTFail("The cutout path is nil.")
            return
        }

        guard let updatedPointOfInterest2 = coachMark2.pointOfInterest else {
            XCTFail("The cutout path is nil.")
            return
        }

        XCTAssertEqual(updatedCutoutPath2.bounds, CGRect(x: 90, y: 75, width: 20, height: 300))
        XCTAssertEqual(updatedPointOfInterest2, CGPoint(x: 105, y: 135))
    }

    // MARK: - 'Flow' Tests
    func testThatUpdateDidNotOccur() {
        flowManager.isPaused = true
        flowManager.currentCoachMark = CoachMark()

        coachMarkHelper.updateCurrentCoachMark()

        XCTAssertTrue(flowManager.currentCoachMark == CoachMark())

        flowManager.isPaused = false
        flowManager.currentCoachMark = nil

        coachMarkHelper.updateCurrentCoachMark()

        XCTAssertTrue(flowManager.currentCoachMark == nil)

        flowManager.isPaused = false
        flowManager.currentCoachMark = CoachMark()

        coachMarkHelper.updateCurrentCoachMark()

        XCTAssertTrue(flowManager.currentCoachMark ==  CoachMark())
    }
}

class MockedFlowManager: FlowManager {
    private var _pause = false

    override var isPaused: Bool {
        get {
            return _pause
        }

        set {
            _pause = newValue
        }
    }
}
