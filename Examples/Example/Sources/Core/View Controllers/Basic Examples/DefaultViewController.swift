// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// That's the default controller, using every defaults made available by Instructions.
// It can't get any simpler.
internal class DefaultViewController: ProfileViewController,
                                      CoachMarksControllerDataSource {
    var windowLevel: UIWindow.Level?
    var presentationContext: Context = .independentWindow
    var useInvisibleOverlay: Bool = false

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self

        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)

        self.coachMarksController.skipView = skipView

        if useInvisibleOverlay {
            self.coachMarksController.overlay.areTouchEventsForwarded = true
            self.coachMarksController.overlay.backgroundColor = .clear
        }
    }

    override func startInstructions() {
        if presentationContext == .controllerWindow {
            self.coachMarksController.start(in: .currentWindow(of: self))
        } else if presentationContext == .controller {
            self.coachMarksController.start(in: .viewController(self))
        } else {
            if let windowLevel = windowLevel {
                self.coachMarksController.start(in: .newWindow(over: self, at: windowLevel))
            } else {
                self.coachMarksController.start(in: .window(over: self))
            }
        }
    }

    enum Context {
        case independentWindow, controllerWindow, controller
    }

    // MARK: - Protocol Conformance | CoachMarksControllerDataSource
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 5
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0:
            return coachMarksController.helper.makeCoachMark(
                for: self.navigationController?.navigationBar,
                cutoutPathMaker: { (frame: CGRect) -> UIBezierPath in
                    // This will make a cutoutPath matching the shape of
                    // the component (no padding, no rounded corners).
                    return UIBezierPath(rect: frame)
                }
            )
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.handleLabel)
        case 2:
            return coachMarksController.helper.makeCoachMark(for: self.emailLabel)
        case 3:
            return coachMarksController.helper.makeCoachMark(for: self.postsLabel)
        case 4:
            return coachMarksController.helper.makeCoachMark(for: self.reputationLabel)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {

        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )

        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = self.profileSectionText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = self.handleText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = self.emailText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 3:
            coachViews.bodyView.hintLabel.text = self.postsText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 4:
            coachViews.bodyView.hintLabel.text = self.reputationText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        default: break
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

    // MARK: Protocol Conformance - CoachMarkControllerDelegate
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willLoadCoachMarkAt index: Int) -> Bool {
        if index == 0 && presentationContext == .controller {
            return false
        }

        return true
    }
}
