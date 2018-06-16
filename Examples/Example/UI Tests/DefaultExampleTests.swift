// DefaultExampleTests.swift
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

class DefaultExampleTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
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
