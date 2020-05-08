// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

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

        XCUIDevice.shared.orientation = .portrait
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

        let orientation = XCUIDevice.shared.orientation
        FBSnapshotVerifyView(snapshotView,
                             identifier: "_i\(index)_o\(orientation.rawValue)_\(presentationContext)")

        if delegateEndExpectation.description == "DidShowWithRotation",
           index == 2, orientation == .portrait {
            XCUIDevice.shared.orientation = .landscapeRight
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
                as! DefaultViewController // swiftlint:disable:this force_cast

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
