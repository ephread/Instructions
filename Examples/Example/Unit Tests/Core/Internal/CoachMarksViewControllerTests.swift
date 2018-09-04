// CoachMarkTests.swift
//
// Copyright (c) 2015-2018 Frédéric Maquin <fred@ephread.com>
//                         Esteban Soto <esteban.soto.dev@gmail.com>
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
@testable import Instructions

class CoachMarksViewControllerTests: XCTestCase, CoachMarksControllerDelegate {

    let coachMarksController = CoachMarksViewController()
    let skipViewDisplayManager = SkipViewDisplayManager()
    let coachMarkDisplayManager =
        CoachMarkDisplayManager(coachMarkLayoutHelper: CoachMarkLayoutHelper())

    override func setUp() {
        super.setUp()
        coachMarksController.coachMarkDisplayManager = coachMarkDisplayManager
        coachMarksController.skipViewDisplayManager = skipViewDisplayManager
        coachMarksController.overlayManager = OverlayManager()
    }

    func testThatCustomStatusBarTakePrecedenceOverOverlayColor() {
        coachMarksController.overlayManager.color = .white
        coachMarksController.customStatusBarStyle = .lightContent
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .lightContent)

        coachMarksController.overlayManager.color = .black
        coachMarksController.customStatusBarStyle = .default
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .default)
    }


    func testThatCustomStatusBarTakePrecedenceOverOverlayBlur() {
        coachMarksController.overlayManager.blurEffectStyle = .dark
        coachMarksController.customStatusBarStyle = .default
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .default)

        coachMarksController.overlayManager.blurEffectStyle = .light
        coachMarksController.customStatusBarStyle = .lightContent
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .lightContent)

        coachMarksController.overlayManager.blurEffectStyle = .extraLight
        coachMarksController.customStatusBarStyle = .lightContent
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .lightContent)
    }

    func testThatStatusBarStyleDependsOnBlurStyle() {
        coachMarksController.overlayManager.blurEffectStyle = .dark
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .lightContent)

        coachMarksController.overlayManager.blurEffectStyle = .light
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .default)

        coachMarksController.overlayManager.blurEffectStyle = .extraLight
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .default)
    }

    func testThatStatusBarStyleDependsOnOverlayColor() {
        coachMarksController.overlayManager.color = .black
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .lightContent)

        coachMarksController.overlayManager.color = .white
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .default)

        coachMarksController.overlayManager.color = .gray
        XCTAssertEqual(coachMarksController.preferredStatusBarStyle, .default)
    }
}
