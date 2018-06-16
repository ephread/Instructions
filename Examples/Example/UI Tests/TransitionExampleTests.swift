// TransitionExampleTests.swift
//
// Copyright (c) 2018 Frédéric Maquin <fred@ephread.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
