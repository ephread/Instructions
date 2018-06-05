//
//  InstructionsExampleUITests.swift
//  InstructionsExampleUITests
//
//  Created by Frédéric on 30/05/2018.
//  Copyright © 2018 Ephread. All rights reserved.
//

import XCTest

class CustomExampleTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testTapOnNextButton() {
        let app = XCUIApplication()
        app.tables.staticTexts["Custom"].tap()

        let nextButton = app.buttons["AccessibilityIdentifiers.next"]
        _ = nextButton.waitForExistence(timeout: 5)

        nextButton.tap()
        nextButton.tap()
        nextButton.tap()
        nextButton.tap()
        nextButton.tap()

        app.navigationBars["Custom"].buttons["Instructions"].tap()
    }
}
