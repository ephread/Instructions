// CoachMarkTests.swift
//
// Copyright (c) 2015, 2016 Frédéric Maquin <fred@ephread.com>
//                          Esteban Soto <esteban.soto.dev@gmail.com>
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
        
        self.coachMarksController.dataSource = self.mockedDataSource
        self.coachMarksController.delegate = self

        self.mockedWindow.addSubview(self.parentController.view)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testThatCoachMarkControllerAttachItselfToParent() {
        self.coachMarksController.startOn(self.parentController)

        let contains =
            isCoachMarkViewControllerAttached(self.parentController.childViewControllers)

        XCTAssertTrue(contains)
    }

    func testThatDidFinishShowingIsCalled() {
        self.delegateEndExpectation = self.expectation(description: "DidFinishShowing")

        self.coachMarksController.startOn(self.parentController)
        self.coachMarksController.stop()

        self.waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatCoachMarkControllerDetachItselfFromParent() {
        self.delegateEndExpectation = self.expectation(description: "Detachment")

        self.coachMarksController.startOn(self.parentController)
        self.coachMarksController.stop()

        self.waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, didFinishShowingAndWasSkipped skipped: Bool) {
        guard let delegateEndExpectation = self.delegateEndExpectation else {
            XCTFail()
            return
        }

        if (delegateEndExpectation.description == "Detachment") {
            let contains =
                isCoachMarkViewControllerAttached(self.parentController.childViewControllers)

            XCTAssertFalse(contains)

            delegateEndExpectation.fulfill()
        } else if (delegateEndExpectation.description == "DidFinishShowing") {
            XCTAssertTrue(true)
            delegateEndExpectation.fulfill()
        } else {
            XCTFail()
        }
    }

    fileprivate func isCoachMarkViewControllerAttached(_ controller: [UIViewController])
    -> Bool {
        var contains = false

        for controller in controller {
            contains = controller is CoachMarksViewController
            if contains { break }
        }

        return contains
    }
}

internal class CoachMarkControllerMockedDataSource : CoachMarksControllerDataSource {

    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return CoachMark()
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        return (CoachMarkBodyDefaultView(), nil)
    }
}

internal class CoachMarkControllerMockedDataSourceUsingConstructorWithoutButton : CoachMarkControllerMockedDataSource {
    override func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        return (CoachMarkBodyDefaultView(hintText: "hint", nextText: nil), nil)
    }
}

internal class CoachMarkControllerMockedDataSourceUsingConstructorWithButton : CoachMarkControllerMockedDataSource {
    override func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        return (CoachMarkBodyDefaultView(hintText: "hint", nextText: "next"), nil)
    }
}
