// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// That's the default controller, using every defaults made available by Instructions.
// It can't get any simpler.
internal class DefaultViewController: ProfileViewController,
                                      TutorialControllerDataSource,
                                      TutorialControllerDelegate {
    var windowLevel: UIWindow.Level?
    var presentationContext: Context = .independentWindow
    var useInvisibleOverlay: Bool = false

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tutorialController.dataSource = self
        self.tutorialController.delegate = self

        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0

        let skipView = DefaultCoachMarkSkipperView()
        skipView.setTitle("Skip", for: .normal)

        self.tutorialController.skipper.view = skipView

        if useInvisibleOverlay {
            self.tutorialController.overlay.areTouchEventsForwarded = true
            self.tutorialController.overlay.backgroundColor = .clear
        }
    }

    override func startInstructions() {
        if presentationContext == .controllerWindow {
            self.tutorialController.start(in: .currentWindow(of: self))
        } else if presentationContext == .controller {
            self.tutorialController.start(in: .viewController(self))
        } else {
            if let windowLevel = windowLevel {
                self.tutorialController.start(in: .newWindow(over: self, at: windowLevel))
            } else {
                self.tutorialController.start(in: .newWindow(over: self))
            }
        }
    }

    enum Context {
        case independentWindow, controllerWindow, controller
    }

    // MARK: - Protocol Conformance | CoachMarksControllerDataSource
    func numberOfCoachMarks(in tutorialController: TutorialController) -> Int {
        return 5
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        configurationForCoachMarkAt index: Int
    ) -> CoachMarkConfiguration {
        switch index {
        case 0:
            return tutorialController.helper.makeCoachMark(
                for: self.navigationController?.navigationBar,
                cutoutPathMaker: { (frame: CGRect) -> UIBezierPath in
                    // This will make a cutoutPath matching the shape of
                    // the component (no padding, no rounded corners).
                    return UIBezierPath(rect: frame)
                }
            )
        case 1:
            return tutorialController.helper.makeCoachMark(for: self.handleLabel)
        case 2:
            return tutorialController.helper.makeCoachMark(for: self.emailLabel)
        case 3:
            return tutorialController.helper.makeCoachMark(for: self.postsLabel)
        case 4:
            return tutorialController.helper.makeCoachMark(for: self.reputationLabel)
        default:
            return tutorialController.helper.makeCoachMark()
        }
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        compoundViewFor configuration: ComputedCoachMarkConfiguration,
        at index: Int
    ) -> CoachMarkViewComponents {
        let components = tutorialController.helper.makeDefaultViews(
            showPointer: true,
            position: configuration.position
        )

        switch index {
        case 0:
            components.contentView.hintLabel.text = self.profileSectionText
            components.contentView.nextLabel.text = self.nextButtonText
        case 1:
            components.contentView.hintLabel.text = self.handleText
            components.contentView.nextLabel.text = self.nextButtonText
        case 2:
            components.contentView.hintLabel.text = self.emailText
            components.contentView.nextLabel.text = self.nextButtonText
        case 3:
            components.contentView.hintLabel.text = self.postsText
            components.contentView.nextLabel.text = self.nextButtonText
        case 4:
            components.contentView.hintLabel.text = self.reputationText
            components.contentView.nextLabel.text = self.nextButtonText
        default: break
        }

        return components
    }

    // MARK: Protocol Conformance - CoachMarkControllerDelegate
    func tutorialController(
        _ tutorialController: TutorialController,
        shouldLoadConfigurationForCoachMarkAt index: Int
    ) -> Bool {
        if index == 0 && presentationContext == .controller {
            return false
        }

        return true
    }
}
