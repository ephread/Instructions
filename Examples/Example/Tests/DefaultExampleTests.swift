//
//  InstructionsExampleUITests.swift
//  InstructionsExampleUITests
//
//  Created by Frédéric on 30/05/2018.
//  Copyright © 2018 Ephread. All rights reserved.
//

import XCTest

class DefaultExampleTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testThatOverlayCoversAllInteractions() {
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Default"]/*[[".cells.staticTexts[\"Default\"]",".staticTexts[\"Default\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        if app.navigationBars["Profile"].buttons["Instructions"].isHittable {
            XCTFail("Back button is hittable.")
        }
    }

    func testTapOnBody() {
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Default"]/*[[".cells.staticTexts[\"Default\"]",".staticTexts[\"Default\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let coachMark = app.otherElements["AccessibilityIdentifiers.coachMarkBody"]
        _ = coachMark.waitForExistence(timeout: 5)

        coachMark.tap()
        coachMark.tap()
        coachMark.tap()
        coachMark.tap()
        coachMark.tap()

        app.navigationBars["Profile"].buttons["Instructions"].tap()
    }

    func testTapOnOverlay() {
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Default"]/*[[".cells.staticTexts[\"Default\"]",".staticTexts[\"Default\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let overlay = app.otherElements["AccessibilityIdentifiers.overlayView"]
        _ = overlay.waitForExistence(timeout: 5)

        overlay.tap()
        overlay.tap()
        overlay.tap()
        overlay.tap()
        overlay.tap()

        app.navigationBars["Profile"].buttons["Instructions"].tap()
    }

    func testTapOnSkip() {
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Default"]/*[[".cells.staticTexts[\"Default\"]",".staticTexts[\"Default\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let skipButton = app.buttons["AccessibilityIdentifiers.skipButton"]
        _ = skipButton.waitForExistence(timeout: 5)
        skipButton.tap()

        app.navigationBars["Profile"].buttons["Instructions"].tap()
    }

    func testMixedTaps() {
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Default"]/*[[".cells.staticTexts[\"Default\"]",".staticTexts[\"Default\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let overlay = app.otherElements["AccessibilityIdentifiers.overlayView"]
        let coachMark = app.otherElements["AccessibilityIdentifiers.coachMarkBody"]

        _ = overlay.waitForExistence(timeout: 5)
        _ = coachMark.waitForExistence(timeout: 5)

        coachMark.tap()
        coachMark.tap()
        overlay.tap()

        let skipButton = app.buttons["AccessibilityIdentifiers.skipButton"]
        skipButton.tap()

        app.navigationBars["Profile"].buttons["Instructions"].tap()
    }
}
