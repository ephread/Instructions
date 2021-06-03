// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import XCTest

class CustomExampleTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launchWithAnimationsDisabled()
    }

    func testTapOnNextButton() {
        let app = XCUIApplication()
        app.tables.staticTexts["Custom"].tap()

        let nextButton = app.buttons["AccessibilityIdentifiers.next"]
        _ = nextButton.waitForExistence(timeout: 10)

        nextButton.tap()
        nextButton.tap()
        nextButton.tap()
        nextButton.tap()
        nextButton.tap()

        app.navigationBars["Custom"].buttons["Instructions"].tap()
    }
}
