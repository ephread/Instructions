// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.
import XCTest

class DefaultExampleTests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launchWithAnimationsDisabled()
    }

    func testTapOnBody() {
        let app = XCUIApplication()
        app.tables.staticTexts["Default"].tap()

        let coachMark = app.otherElements["AccessibilityIdentifiers.coachMarkBody"]
        _ = coachMark.waitForExistence(timeout: 10)

        coachMark.tap()
        coachMark.tap()
        coachMark.tap()
        coachMark.tap()
        coachMark.tap()

        app.navigationBars["Default"].buttons["Instructions"].tap()
    }

    func testTapOnOverlay() {
        let app = XCUIApplication()
        app.tables.staticTexts["Default"].tap()

        let overlay = app.otherElements["AccessibilityIdentifiers.overlayView"]
        _ = overlay.waitForExistence(timeout: 10)

        overlay.tap()
        overlay.tap()
        overlay.tap()
        overlay.tap()
        overlay.tap()

        app.navigationBars["Default"].buttons["Instructions"].tap()
    }

    func testTapOnSkip() {
        let app = XCUIApplication()
        app.tables.staticTexts["Default"].tap()

        let skipButton = app.buttons["AccessibilityIdentifiers.skipButton"]
        _ = skipButton.waitForExistence(timeout: 10)
        skipButton.tap()

        app.navigationBars["Default"].buttons["Instructions"].tap()
    }

    func testMixedTaps() {
        let app = XCUIApplication()
        app.tables.staticTexts["Default"].tap()

        let overlay = app.otherElements["AccessibilityIdentifiers.overlayView"]
        let coachMark = app.otherElements["AccessibilityIdentifiers.coachMarkBody"]

        _ = overlay.waitForExistence(timeout: 10)
        _ = coachMark.waitForExistence(timeout: 10)

        coachMark.tap()
        coachMark.tap()
        overlay.tap()

        let skipButton = app.buttons["AccessibilityIdentifiers.skipButton"]
        skipButton.tap()

        app.navigationBars["Default"].buttons["Instructions"].tap()
    }
}
