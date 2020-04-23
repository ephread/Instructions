// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest

class TransitionExampleTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        XCUIApplication().launchWithAnimationsDisabled()
    }

    func testTapThroughCutout() {
        let app = XCUIApplication()
        app.tables.staticTexts["Transitioning from code"].tap()
        
        let overlay = app.otherElements["AccessibilityIdentifiers.overlayView"]
        _ = overlay.waitForExistence(timeout: 5)

        overlay.tap()
        overlay.tap()

        let vector = CGVector(dx: 0.5, dy: 0.5)
        let coordinate = overlay.coordinate(withNormalizedOffset: vector)
        coordinate.tap()

        overlay.tap()
        overlay.tap()
        overlay.tap()

        app.navigationBars["Transition From Code"].buttons["Instructions"].tap()
    }

    func testTapThroughOverlay() {
        let app = XCUIApplication()
        app.tables.staticTexts["Transitioning from code"].tap()

        let overlay = app.otherElements["AccessibilityIdentifiers.overlayView"]
        _ = overlay.waitForExistence(timeout: 5)

        overlay.tap()

        let vector = CGVector(dx: 0.8, dy: 0.8)
        let coordinate = overlay.coordinate(withNormalizedOffset: vector)
        coordinate.tap()

        overlay.tap()
        overlay.tap()

        if app.navigationBars["Transition From Code"].buttons["Instructions"].isHittable {
            XCTFail("Back button should not be hittable.")
        }
    }
}
