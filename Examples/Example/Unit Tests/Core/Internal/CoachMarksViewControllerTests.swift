// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class CoachMarksViewControllerTests: XCTestCase, CoachMarksControllerDelegate {

    let coachMarksController = CoachMarksViewController()
    let skipViewDisplayManager = SkipViewDisplayManager()
    let coachMarkDisplayManager =
        CoachMarkDisplayManager(coachMarkLayoutHelper: CoachMarkLayoutHelper())

    override func setUp() {
        super.setUp()
        coachMarksController.coachMarkDisplayManager = coachMarkDisplayManager
        coachMarksController.skipViewDisplayManager = skipViewDisplayManager
        coachMarksController.overlayManager = OverlayManager()
    }

    func testThatCustomStatusBarTakePrecedenceOverOverlayColor() {
        coachMarksController.overlayManager.backgroundColor = .white
        coachMarksController.customStatusBarStyle = .lightContent
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .lightContent)

        coachMarksController.overlayManager.backgroundColor = .black
        coachMarksController.customStatusBarStyle = .default
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .default)
    }

    func testThatCustomStatusBarTakePrecedenceOverOverlayBlur() {
        coachMarksController.overlayManager.blurEffectStyle = .dark
        coachMarksController.customStatusBarStyle = .default
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .default)

        coachMarksController.overlayManager.blurEffectStyle = .light
        coachMarksController.customStatusBarStyle = .lightContent
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .lightContent)

        coachMarksController.overlayManager.blurEffectStyle = .extraLight
        coachMarksController.customStatusBarStyle = .lightContent
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .lightContent)
    }

    func testThatStatusBarStyleDependsOnBlurStyle() {
        coachMarksController.overlayManager.blurEffectStyle = .dark
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .lightContent)

        coachMarksController.overlayManager.blurEffectStyle = .light
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .default)

        coachMarksController.overlayManager.blurEffectStyle = .extraLight
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .default)
    }

    func testThatStatusBarStyleDependsOnOverlayColor() {
        coachMarksController.overlayManager.backgroundColor = .black
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .lightContent)

        coachMarksController.overlayManager.backgroundColor = .white
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .default)

        coachMarksController.overlayManager.backgroundColor = .gray
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .default)
    }
}
