// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// A controller showcasing the different positions of the "Next Button"
internal class NextPositionViewController: ProfileViewController {
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coachMarksController.dataSource = self

        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)

        self.coachMarksController.skipView = skipView
    }

    override func startInstructions() {
        coachMarksController.start(in: .window(over: self))
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension NextPositionViewController: CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 6
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkAt index: Int
    ) -> CoachMark {
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
        case 5:
            return coachMarksController.helper.makeCoachMark(for: self.avatar) { (frame: CGRect) -> UIBezierPath in
                // This will create a circular cutoutPath, perfect for the circular avatar!
                return UIBezierPath(ovalIn: frame.insetBy(dx: -4, dy: -4))
            }
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {

        var hintText = ""
        var nextLabelPosition: CoachMarkNextLabelPosition = .trailing

        switch index {
        case 0:
            hintText = self.profileSectionText
        case 1:
            hintText = self.handleText
            nextLabelPosition = .leading
        case 2:
            hintText = self.emailText
            nextLabelPosition = .topLeading
        case 3:
            hintText = self.postsText
            nextLabelPosition = .topTrailing
        case 4:
            hintText = self.reputationText
            nextLabelPosition = .bottomTrailing
        case 5:
            hintText = self.avatarText
            nextLabelPosition = .bottomLeading
        default: break
        }

        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation,
            hintText: hintText,
            nextText: "Ok!",
            nextLabelPosition: nextLabelPosition
        )

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
