//
//  InstructionsExampleUITests.swift
//  InstructionsExampleUITests
//
//  Created by Frédéric on 30/05/2018.
//  Copyright © 2018 Ephread. All rights reserved.
//

import XCTest

class TransitionExampleTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        XCUIApplication().launch()
    }

    func testTapThroughCutout() {
        let app = XCUIApplication()
        app.tables.staticTexts["Transitioning from code"].tap()
        
        let overlay = app.otherElements["AccessibilityIdentifiers.overlayView"]
        _ = overlay.waitForExistence(timeout: 5)

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
