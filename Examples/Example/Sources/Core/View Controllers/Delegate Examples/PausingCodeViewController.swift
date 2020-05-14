// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// A controller showcasing the ability to pause the flow, do something else on the screen
// and start it again.
internal class PausingCodeViewController: ProfileViewController {

    let text1 = "That's a beautiful navigation bar."
    let text2 = "We're going to pause the flow. Use this button to start it again."
    let text2HideNothing = """
                           We're going to pause the flow, without hiding anything (which means \
                           that the UI will be blocked). Use the skip button to get out.
                           """
    let text2HideOverlay = """
                           We're going to pause the flow, hiding the overlay (while \
                           keeping the UI blocked). Use the skip button to get out.
                           """
    let text3 = "Good job, that's all folks!"

    var pauseStyle: PauseStyle = .hideNothing

    @IBOutlet var tapMeButton: UIButton!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        coachMarksController.dataSource = self
        coachMarksController.delegate = self

        emailLabel?.layer.cornerRadius = 4.0
        postsLabel?.layer.cornerRadius = 4.0
        reputationLabel?.layer.cornerRadius = 4.0

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)

        coachMarksController.skipView = skipView
        coachMarksController.overlay.isUserInteractionEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func performButtonTap(_ sender: AnyObject) {
        // The user tapped on the button, so let's carry on!
        coachMarksController.flow.resume()
    }

    // MARK: - Protocol Conformance | CoachMarksControllerDelegate
    override func coachMarksController(_ coachMarksController: CoachMarksController,
                                       willShow coachMark: inout CoachMark,
                                       beforeChanging change: ConfigurationChange,
                                       at index: Int) {
        if index == 2 && change == .nothing {
            coachMarksController.flow.pause(and: pauseStyle)
        }
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension PausingCodeViewController: CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 3
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        let controller = coachMarksController

        switch index {
        case 0:
            let navigationBar = navigationController?.navigationBar
            return controller.helper.makeCoachMark(for: navigationBar) { (frame) -> UIBezierPath in
                // This will make a cutoutPath matching the shape of
                // the component (no padding, no rounded corners).
                return UIBezierPath(rect: frame)
            }
        case 1:
            return controller.helper.makeCoachMark(for: tapMeButton)
        case 2:
            return controller.helper.makeCoachMark(for: postsLabel)

        default: return CoachMark()
        }
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {

        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true, withNextText: true, arrowOrientation: coachMark.arrowOrientation
        )

        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = text1
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 1:
            switch pauseStyle {
            case .hideInstructions:
                coachViews.bodyView.hintLabel.text = text2
            case .hideOverlay:
                coachViews.bodyView.hintLabel.text = text2HideOverlay
            case .hideNothing:
                coachViews.bodyView.hintLabel.text = text2HideNothing
            }

            coachViews.bodyView.nextLabel.text = nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = text3
            coachViews.bodyView.nextLabel.text = nextButtonText
        default: break
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
