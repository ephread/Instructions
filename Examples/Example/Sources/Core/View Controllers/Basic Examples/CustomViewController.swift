// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// Will display custom coach marks.
internal class CustomViewsViewController: ProfileViewController {

    // MARK: - IBOutlet
    @IBOutlet var allView: UIView?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coachMarksController.dataSource = self

        self.coachMarksController.overlay.color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)

        let skipView = CoachMarkSkipDefaultView()
        skipView.isStyledByInstructions = false
        skipView.setTitle("Skip", for: .normal)
        skipView.setTitleColor(UIColor.white, for: .normal)
        skipView.setBackgroundImage(nil, for: .normal)
        skipView.setBackgroundImage(nil, for: .highlighted)
        skipView.layer.cornerRadius = 0
        skipView.backgroundColor = UIColor.darkGray

        self.coachMarksController.skipView = skipView
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension CustomViewsViewController: CoachMarksControllerDataSource {
    // MARK: - Protocol Conformance | CoachMarksControllerDataSource
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 5
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {

        // This will create cutout path matching perfectly the given view.
        // No padding!
        let flatCutoutPathMaker = { (frame: CGRect) -> UIBezierPath in
            return UIBezierPath(rect: frame)
        }

        var coachMark : CoachMark

        switch(index) {
        case 0:
            coachMark = coachMarksController.helper.makeCoachMark(for: self.avatar) { (frame: CGRect) -> UIBezierPath in
                // This will create a circular cutoutPath, perfect for the circular avatar!
                return UIBezierPath(ovalIn: frame.insetBy(dx: -4, dy: -4))
            }
        case 1:
            coachMark = coachMarksController.helper.makeCoachMark(for: self.handleLabel)
            coachMark.arrowOrientation = .top
        case 2:
            coachMark = coachMarksController.helper.makeCoachMark(for: self.allView, pointOfInterest: self.emailLabel?.center, cutoutPathMaker: flatCutoutPathMaker)
        case 3:
            coachMark = coachMarksController.helper.makeCoachMark(for: self.allView, pointOfInterest: self.postsLabel?.center, cutoutPathMaker: flatCutoutPathMaker)
        case 4:
            coachMark = coachMarksController.helper.makeCoachMark(for: self.allView, pointOfInterest: self.reputationLabel?.center, cutoutPathMaker: flatCutoutPathMaker)
        default:
            coachMark = coachMarksController.helper.makeCoachMark()
        }

        coachMark.gapBetweenCoachMarkAndCutoutPath = 6.0

        return coachMark
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        let coachMarkBodyView = CustomCoachMarkBodyView()
        var coachMarkArrowView: CustomCoachMarkArrowView? = nil

        var width: CGFloat = 0.0

        switch(index) {
        case 0:
            coachMarkBodyView.hintLabel.text = self.avatarText
            coachMarkBodyView.nextButton.setTitle(self.nextButtonText, for: .normal)

            if let avatar = self.avatar {
                width = avatar.bounds.width
            }
        case 1:
            coachMarkBodyView.hintLabel.text = self.handleText
            coachMarkBodyView.nextButton.setTitle(self.nextButtonText, for: .normal)

            if let handleLabel = self.handleLabel {
                width = handleLabel.bounds.width
            }
        case 2:
            coachMarkBodyView.hintLabel.text = self.emailText
            coachMarkBodyView.nextButton.setTitle(self.nextButtonText, for: .normal)

            if let emailLabel = self.emailLabel {
                width = emailLabel.bounds.width
            }
        case 3:
            coachMarkBodyView.hintLabel.text = self.postsText
            coachMarkBodyView.nextButton.setTitle(self.nextButtonText, for: .normal)

            if let postsLabel = self.postsLabel {
                width = postsLabel.bounds.width
            }
        case 4:
            coachMarkBodyView.hintLabel.text = self.reputationText
            coachMarkBodyView.nextButton.setTitle(self.nextButtonText, for: .normal)

            if let reputationLabel = self.reputationLabel {
                width = reputationLabel.bounds.width
            }
        default: break
        }

        // We create an arrow only if an orientation is provided (i. e., a cutoutPath is provided).
        // For that custom coachmark, we'll need to update a bit the arrow, so it'll look like
        // it fits the width of the view.
        if let arrowOrientation = coachMark.arrowOrientation {
            coachMarkArrowView = CustomCoachMarkArrowView(orientation: arrowOrientation)

            // If the view is larger than 1/3 of the overlay width, we'll shrink a bit the width
            // of the arrow.
            let oneThirdOfWidth = self.view.window!.frame.size.width / 3
            let adjustedWidth = width >= oneThirdOfWidth ? width - 2 * coachMark.horizontalMargin : width

            coachMarkArrowView!.plate.addConstraint(NSLayoutConstraint(item: coachMarkArrowView!.plate, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: adjustedWidth))
        }

        return (bodyView: coachMarkBodyView, arrowView: coachMarkArrowView)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, constraintsForSkipView skipView: UIView, inParent parentView: UIView) -> [NSLayoutConstraint]? {

        var constraints: [NSLayoutConstraint] = []
        var topMargin: CGFloat = 0.0

        if !UIApplication.shared.isStatusBarHidden {
            topMargin = UIApplication.shared.statusBarFrame.size.height
        }

        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[skipView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["skipView": skipView]))

        if UIApplication.shared.isStatusBarHidden {
            constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[skipView]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["skipView": skipView]))
        } else {
            constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-topMargin-[skipView(==44)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["topMargin": topMargin],
                                                    views: ["skipView": skipView]))
        }

        return constraints
    }
}
