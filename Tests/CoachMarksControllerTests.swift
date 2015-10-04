//
//  CoachMarksController.swift
//  Instructions
//
//  Created by Frédéric Maquin on 10/10/15.
//  Copyright © 2015 Ephread. All rights reserved.
//

import XCTest
@testable import Instructions

class CoachMarksControllerTests: XCTestCase {

    let coachMarksController = CoachMarksController()
    let parentController = UIViewController()
    let mockedDataSource = CoachMarkControllerMockedDataSource()
    let mockedWindow = UIWindow()

    override func setUp() {
        super.setUp()
        
        self.coachMarksController.datasource = self.mockedDataSource
        self.mockedWindow.addSubview(self.parentController.view)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testThatCoachMarkControllerAttachItselfToParent() {
        self.coachMarksController.startOn(self.parentController)

        self.parentController.childViewControllers
        XCTAssertTrue(self.parentController.childViewControllers.contains(self.coachMarksController))
    }

    func testThatCoachMarkControllerDetachItselfFromParent() {
        let detachmentExpectation = self.expectationWithDescription("CoachMarkControllerDetachItselfFromParent")

        self.coachMarksController.startOn(self.parentController)
        self.coachMarksController.stop()

        Instructions.delay(coachMarksController.overlayFadeAnimationDuration) {
            self.parentController.childViewControllers
            XCTAssertFalse(self.parentController.childViewControllers.contains(self.coachMarksController))

            detachmentExpectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(coachMarksController.overlayFadeAnimationDuration + 1) { error in

            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }

    }
}

internal class CoachMarkControllerMockedDataSource : CoachMarksControllerDataSource {

    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 1
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        return CoachMark()
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        return (CoachMarkBodyDefaultView(), nil)
    }
}
