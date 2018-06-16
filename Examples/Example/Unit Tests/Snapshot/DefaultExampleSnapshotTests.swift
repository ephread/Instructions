//
//  DefaultExampleSnapshotTests.swift
//  InstructionsExampleUITests
//
//  Created by Frédéric on 16/06/2018.
//  Copyright © 2018 Ephread. All rights reserved.
//

@testable import Instructions
@testable import Instructions_Example
import FBSnapshotTestCase

class DefaultExampleSnapshotTests: FBSnapshotTestCase, CoachMarksControllerDelegate {
    var window: UIWindow!
    var storyboard: UIStoryboard!
    var navigationController: UINavigationController!
    var delegateEndExpectation: XCTestExpectation!

    override func setUp() {
        super.setUp()

        window = UIWindow()
        window.frame = UIScreen.main.bounds

        navigationController = UINavigationController()

        storyboard = UIStoryboard(name: "Main", bundle: nil)

        recordMode = true
    }

    func testDefaultFlow() {
        delegateEndExpectation = self.expectation(description: "DidShow")

        setupController()

        waitForExpectations(timeout: 15) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testDefaultFlowWithRotation() {
        delegateEndExpectation = self.expectation(description: "DidShowWithRotation")

        setupController()

        waitForExpectations(timeout: 15) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didShow coachMark: CoachMark,
                              afterSizeTransition: Bool,
                              at index: Int) {
        guard let window = instructionsWindow() else {
            return
        }

        let orientation = UIDevice.current.orientation
        FBSnapshotVerifyView(window,
                             identifier: "_index\(index)_orientation\(orientation.rawValue)")


        if delegateEndExpectation.description == "DidShowWithRotation",
           index == 2, orientation == .portrait {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue,
                                      forKey: "orientation")
        } else {
            coachMarksController.flow.showNext()
        }
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didEndShowingBySkipping skipped: Bool) {
        if let window = instructionsWindow() {
            if window.isHidden {
                delegateEndExpectation.fulfill()
            }
        } else {
            delegateEndExpectation.fulfill()
        }
    }

    private func instructionsWindow() -> UIWindow? {
        let windows = UIApplication.shared.windows

        return windows.filter {
            $0.accessibilityIdentifier == "AccessibilityIdentifiers.window"
        }.first
    }

    private func setupController() {
        let controller =
            storyboard.instantiateViewController(withIdentifier: "DefaultViewController")
                as! DefaultViewController

        controller.snapshotDelegate = self

        navigationController.viewControllers.append(controller)
        window.rootViewController = navigationController

        _ = controller.view
        _ = navigationController.view

        window.isHidden = false
    }
}
