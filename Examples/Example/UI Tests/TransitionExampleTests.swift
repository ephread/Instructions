// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest

class TransitionExampleTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        XCUIApplication().launchWithAnimationsDisabled()
        XCUIDevice.shared.orientation = .portrait
    }

    func testTapThroughCutout() {
        let app = XCUIApplication()
        app.tables.staticTexts["Transitioning from code"].tap()

        let overlay = app.otherElements["AccessibilityIdentifiers.overlayView"]
        _ = overlay.waitForExistence(timeout: 5)

        let defaultCoordinates = app.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.1))

        defaultCoordinates.tap()
        defaultCoordinates.tap()

        // One extra tap, to make sure touch is disabled at this point.
        defaultCoordinates.tap()

        let cutoutCoordinates = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        cutoutCoordinates.tap()

        defaultCoordinates.tap()
        defaultCoordinates.tap()
        defaultCoordinates.tap()

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
