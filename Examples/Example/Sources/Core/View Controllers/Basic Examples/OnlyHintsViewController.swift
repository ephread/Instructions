// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// That's the default controller, using every defaults made available by Instructions.
// It can't get any simpler.
internal class OnlyHintViewController: ProfileViewController {
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tutorialController.dataSource = self

        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0

        let skipView = DefaultCoachMarkSkipperView()
        skipView.setTitle("Skip", for: .normal)

        self.tutorialController.skipView = skipView
    }

    override func startInstructions() {
        tutorialController.start(in: .window(over: self))
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension OnlyHintViewController: TutorialControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: TutorialController) -> Int {
        return 5
    }

    func coachMarksController(_ coachMarksController: TutorialController, coachMarkAt index: Int) -> CoachMarkConfiguration {
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

    func coachMarksController(
        _ coachMarksController: TutorialController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMarkConfiguration
    ) -> (bodyView: (UIView & CoachMarkContentView), arrowView: (UIView & CoachMarkArrowView)?) {

        var hintText = ""

        switch index {
        case 0:
            hintText = self.profileSectionText
        case 1:
            hintText = self.handleText
        case 2:
            hintText = self.emailText
        case 3:
            hintText = self.postsText
        case 4:
            hintText = self.reputationText
        default: break
        }

        let coachViews = tutorialController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation,
            hintText: hintText,
            nextText: nil
        )

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
