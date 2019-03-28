// DefaultExampleSnapshotTests.swift
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

@testable import Instructions
@testable import InstructionsExample
import FBSnapshotTestCase

class DefaultExampleSnapshotTests: BaseSnapshotTests,
                                   CoachMarksControllerDelegate {
    var storyboard: UIStoryboard!
    var navigationController: UINavigationController!
    var delegateEndExpectation: XCTestExpectation!

    var presentationContext: DefaultViewController.Context = .independantWindow

    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()

        storyboard = UIStoryboard(name: "Main", bundle: nil)
        fileNameOptions = [.device, .OS, .screenSize, .screenScale]

        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,
                                  forKey: "orientation")
        delegateEndExpectation = nil
    }

    func testFlowInIndependantWindow() {
        runFlowTester()
    }

    func testRotationInIndependantWindow() {
        runRotationTester()
    }

    func testFlowInWindow() {
        presentationContext = .controllerWindow
        runFlowTester()
    }

    func testRotationInWindow() {
        presentationContext = .controllerWindow
        runRotationTester()
    }

    func testFlowInController() {
        presentationContext = .controller
        runFlowTester()
    }

    func testRotationInController() {
        presentationContext = .controller
        runRotationTester()
    }

    // MARK: Helpers
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didShow coachMark: CoachMark,
                              afterChanging change: ConfigurationChange,
                              at index: Int) {
        if change == .statusBar { return }

        let snapshotView: UIView
        switch presentationContext {
        case .independantWindow:
            guard let window = instructionsWindow() else {
                return
            }

            snapshotView = window
        case .controllerWindow, .controller:
            guard let window = navigationController.view.window else {
                return
            }

            snapshotView = window
        }

        let orientation = UIDevice.current.orientation
        FBSnapshotVerifyView(snapshotView,
                             identifier: "_i\(index)_o\(orientation.rawValue)_\(presentationContext)")

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
    
    func setupController() {
        let controller =
            storyboard.instantiateViewController(withIdentifier: "DefaultViewController")
            as! DefaultViewController

        controller.snapshotDelegate = self
        controller.presentationContext = presentationContext

        navigationController.viewControllers.append(controller)
        window.rootViewController = navigationController

        _ = controller.view
        _ = navigationController.view

        window.makeKeyAndVisible()
    }

    func runRotationTester() {
        delegateEndExpectation = expectation(description: "DidShowWithRotation")
        setupController()
        waitForExpectations(timeout: 15) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func runFlowTester() {
        delegateEndExpectation = expectation(description: "DidShow")
        setupController()
        waitForExpectations(timeout: 15) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
