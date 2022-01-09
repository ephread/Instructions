// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest
@testable import Instructions

class CoachMarksViewControllerTests: XCTestCase, TutorialControllerDelegate {

    let tutorialController = CoachMarksViewController()
    let skipViewDisplayManager = SkippingManager()
    let coachMarkDisplayManager =
        CoachMarkDisplayManager(coachMarkLayoutHelper: CoachMarkLayoutHelper())

    override func setUp() {
        super.setUp()
        tutorialController.coachMarkDisplayManager = coachMarkDisplayManager
        tutorialController.skipViewDisplayManager = skipViewDisplayManager
        tutorialController.overlayManager = OverlayManager()
    }

    func testThatCustomStatusBarTakePrecedenceOverOverlayColor() {
        tutorialController.overlayManager.backgroundColor = .white
        tutorialController.customStatusBarStyle = .lightContent
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .lightContent)

        tutorialController.overlayManager.backgroundColor = .black
        tutorialController.customStatusBarStyle = .default
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .default)
    }

    func testThatCustomStatusBarTakePrecedenceOverOverlayBlur() {
        tutorialController.overlayManager.blurEffectStyle = .dark
        tutorialController.customStatusBarStyle = .default
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .default)

        tutorialController.overlayManager.blurEffectStyle = .light
        tutorialController.customStatusBarStyle = .lightContent
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .lightContent)

        tutorialController.overlayManager.blurEffectStyle = .extraLight
        tutorialController.customStatusBarStyle = .lightContent
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .lightContent)
    }

    func testThatStatusBarStyleDependsOnBlurStyle() {
        tutorialController.overlayManager.blurEffectStyle = .dark
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .lightContent)

        tutorialController.overlayManager.blurEffectStyle = .light
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .default)

        tutorialController.overlayManager.blurEffectStyle = .extraLight
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .default)
    }

    func testThatStatusBarStyleDependsOnOverlayColor() {
        tutorialController.overlayManager.backgroundColor = .black
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .lightContent)

        tutorialController.overlayManager.backgroundColor = .white
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .default)

        tutorialController.overlayManager.backgroundColor = .gray
        XCTAssertEqual(tutorialController.preferredStatusBarStyle, .default)
    }
}
