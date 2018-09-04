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

class CoachMarksControllerTests: XCTestCase, CoachMarksControllerDelegate {

    let coachMarksController = CoachMarksController()
    let parentController = UIViewController()
    let mockedDataSource = CoachMarkControllerMockedDataSource()
    let mockedWindow = UIWindow()

    var delegateEndExpectation: XCTestExpectation? = nil

    override func setUp() {
        super.setUp()
        
        coachMarksController.dataSource = self.mockedDataSource
        coachMarksController.delegate = self

        mockedWindow.addSubview(self.parentController.view)
    }

    func testThatDidFinishShowingIsCalled() {
        delegateEndExpectation = self.expectation(description: "DidFinishShowing")

        coachMarksController.start(in: .window(over: parentController))
        coachMarksController.stop()

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatCoachMarkControllerAttachItselfToParent() {
        coachMarksController.start(in: .window(over: parentController))

        let attached = (coachMarksController.overlay.overlayView.window != nil &&
                        coachMarksController.overlay.overlayView.window != mockedWindow)

        XCTAssertTrue(attached)
    }

    func testThatCoachMarkControllerDetachItselfFromParent() {
        delegateEndExpectation = self.expectation(description: "Detachment")

        coachMarksController.start(in: .window(over: parentController))
        coachMarksController.stop()

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatCoachMarkStoppedBySkipping() {
        delegateEndExpectation = self.expectation(description: "DidFinishShowingBySkipping")

        let skipView = CoachMarkSkipDefaultView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        coachMarksController.skipView = skipView

        coachMarksController.start(in: .window(over: parentController))

        skipView.skipControl?.sendActions(for: .touchUpInside)

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }


    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didEndShowingBySkipping skipped: Bool) {
        guard let delegateEndExpectation = self.delegateEndExpectation else {
            XCTFail()
            return
        }

        if (delegateEndExpectation.description == "Detachment") {
            XCTAssertTrue(coachMarksController.overlay.overlayView.window == nil)

            delegateEndExpectation.fulfill()
        } else if (delegateEndExpectation.description == "DidFinishShowing") {
            XCTAssertTrue(true)
            delegateEndExpectation.fulfill()
        } else if (delegateEndExpectation.description == "DidFinishShowingBySkipping") {
            XCTAssertTrue(skipped)
            delegateEndExpectation.fulfill()
        } else {
            XCTFail()
        }
    }
}

internal class CoachMarkControllerMockedDataSource : CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        return CoachMark()
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        return (CoachMarkBodyDefaultView(), nil)
    }
}

internal class CoachMarkControllerMockedDataSourceUsingConstructorWithoutButton : CoachMarkControllerMockedDataSource {
    override func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        return (CoachMarkBodyDefaultView(hintText: "hint", nextText: nil), nil)
    }
}

internal class CoachMarkControllerMockedDataSourceUsingConstructorWithButton :
               CoachMarkControllerMockedDataSource {
    override func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        return (CoachMarkBodyDefaultView(hintText: "hint", nextText: "next"), nil)
    }
}
