// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// That's the default controller, using every defaults made available by Instructions.
// It can't get any simpler.
internal class TransitionFromCodeViewController: ProfileViewController {

    let text1 = "(1) That's the first coach mark."
    let text2 = "(2) Second coach mark no one will see."
    let text3 = """
                (3) We skipped the second one (look at how we did it in the code). \
                Now, please tap on this button to continue!
                """
    let text4 = "(4) We are finally hitting the fourth one!"
    let text5 = "(5) And now the fifth one!"
    let text6 = "(6) This instruction is the last one."

    @IBOutlet var tapMeButton: UIButton!

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
        self.coachMarksController.overlay.isUserInteractionEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func performButtonTap(_ sender: AnyObject) {
        // The user tapped on the button, so let's carry on!
        self.coachMarksController.flow.showNext()
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension TransitionFromCodeViewController: CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 6
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
            var coachMark = coachMarksController.helper.makeCoachMark(for: self.tapMeButton)
            // Since we've allowed the user to tap on the overlay to show the
            // next coach mark, we'll disable this ability for the current
            // coach mark to force the user to perform the appropriate action.
            coachMark.isOverlayInteractionEnabled = false

            // We'll also enable the ability to touch what's inside
            // the cutoutPath.
            coachMark.isUserInteractionEnabledInsideCutoutPath = true
            return coachMark
        case 3:
            return coachMarksController.helper.makeCoachMark(for: self.emailLabel)
        case 4:
            return coachMarksController.helper.makeCoachMark(for: self.postsLabel)
        case 5:
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
        var coachViews: (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?)

        // For the coach mark at index 2, we disable the ability to tap on the
        // coach mark to get to the next one, forcing the user to perform
        // the appropriate action.
        switch index {
        case 2:
            coachViews = coachMarksController.helper.makeDefaultCoachViews(
                withArrow: true,
                withNextText: false,
                arrowOrientation: coachMark.arrowOrientation
            )
            coachViews.bodyView.isUserInteractionEnabled = false
        default:
            coachViews = coachMarksController.helper.makeDefaultCoachViews(
                withArrow: true,
                withNextText: true,
                arrowOrientation: coachMark.arrowOrientation
            )
        }

        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = self.text1
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = self.text2
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = self.text3
        case 3:
            coachViews.bodyView.hintLabel.text = self.text4
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 4:
            coachViews.bodyView.hintLabel.text = self.text5
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 5:
            coachViews.bodyView.hintLabel.text = self.text6
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        default: break
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

    // MARK: - Protocol Conformance | CoachMarksControllerDelegate
    func coachMarksController(_ coachMarksController: CoachMarksController, willLoadCoachMarkAt index: Int) -> Bool {
        switch index {
        case 1:
            // Skipping the second coach mark.
            return false
        default:
            return true
        }
    }
}
