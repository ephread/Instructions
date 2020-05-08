// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// This class mix different kind of coach marks together.
internal class MixedCoachMarksViewsViewController: ProfileViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var answersLabel: UILabel?

    // MARK: - Private properties
    fileprivate let swipeImage = UIImage(named: "swipe")

    fileprivate let answersText = "That's the number of answers you gave."

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coachMarksController.dataSource = self

        self.coachMarksController.overlay.color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension MixedCoachMarksViewsViewController: CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 5
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {

        var coachMark : CoachMark

        switch(index) {
        case 0:
            coachMark = coachMarksController.helper.makeCoachMark(for: self.handleLabel)
        case 1:
            coachMark = coachMarksController.helper.makeCoachMark(for: self.emailLabel)
        case 2:
            coachMark = coachMarksController.helper.makeCoachMark(for: self.postsLabel)
        case 3:
            coachMark = coachMarksController.helper.makeCoachMark(for: self.answersLabel)
        case 4:
            coachMark = coachMarksController.helper.makeCoachMark(for: self.reputationLabel)
        default:
            coachMark = coachMarksController.helper.makeCoachMark()
        }

        coachMark.gapBetweenCoachMarkAndCutoutPath = 6.0

        return coachMark
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {

        var bodyView: UIView & CoachMarkBodyView
        var arrowView: (UIView & CoachMarkArrowView)?

        switch(index) {
        case 0:
            let coachMarkBodyView = CustomCoachMarkBodyView()
            var coachMarkArrowView: CustomCoachMarkArrowView? = nil

            coachMarkBodyView.hintLabel.text = self.handleText
            coachMarkBodyView.nextButton.setTitle(self.nextButtonText, for: .normal)

            var width: CGFloat = 0.0

            if let handleLabel = self.handleLabel {
                width = handleLabel.bounds.width
            }

            if let arrowOrientation = coachMark.arrowOrientation {
                coachMarkArrowView = CustomCoachMarkArrowView(orientation: arrowOrientation)

                coachMarkArrowView!.plate.addConstraint(NSLayoutConstraint(item: coachMarkArrowView!.plate, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
            }

            bodyView = coachMarkBodyView
            arrowView = coachMarkArrowView
        case 1:
            let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)

            coachViews.bodyView.hintLabel.text = self.emailText
            coachViews.bodyView.nextLabel.text = self.nextButtonText

            bodyView = coachViews.bodyView
            arrowView = coachViews.arrowView
        case 2:
            let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: self.postsText, nextText: self.nextButtonText)

            bodyView = coachViews.bodyView
            arrowView = coachViews.arrowView
        case 3:
            let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: self.answersText, nextText: nil)

            bodyView = coachViews.bodyView
            arrowView = coachViews.arrowView
        case 4:
            let coachMarkBodyView = TransparentCoachMarkBodyView()
            var coachMarkArrowView: TransparentCoachMarkArrowView? = nil

            coachMarkBodyView.hintLabel.text = self.handleText

            if let arrowOrientation = coachMark.arrowOrientation {
                coachMarkArrowView = TransparentCoachMarkArrowView(orientation: arrowOrientation)
            }

            bodyView = coachMarkBodyView
            arrowView = coachMarkArrowView
        default:
            let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
            
            bodyView = coachViews.bodyView
            arrowView = coachViews.arrowView
        }
        
        return (bodyView: bodyView, arrowView: arrowView)
    }
}
