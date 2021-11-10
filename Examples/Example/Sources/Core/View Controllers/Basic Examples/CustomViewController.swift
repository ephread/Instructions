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

        self.coachMarksController.overlay.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)

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

        var coachMark: CoachMark

        switch index {
        case 0:
            coachMark = coachMarksController.helper.makeCoachMark(for: self.avatar) { (frame: CGRect) -> UIBezierPath in
                // This will create a circular cutoutPath, perfect for the circular avatar!
                return UIBezierPath(ovalIn: frame.insetBy(dx: -4, dy: -4))
            }
        case 1:
            coachMark = coachMarksController.helper.makeCoachMark(for: self.handleLabel)
            coachMark.arrowOrientation = .top
        case 2:
            coachMark = coachMarksController.helper.makeCoachMark(
                for: self.allView,
                pointOfInterest: self.emailLabel?.center,
                cutoutPathMaker: flatCutoutPathMaker
            )
        case 3:
            coachMark = coachMarksController.helper.makeCoachMark(
                for: self.allView,
                pointOfInterest: self.postsLabel?.center,
                cutoutPathMaker: flatCutoutPathMaker
            )
        case 4:
            coachMark = coachMarksController.helper.makeCoachMark(
                for: self.allView,
                pointOfInterest: self.reputationLabel?.center,
                cutoutPathMaker: flatCutoutPathMaker
            )
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

        let coachMarkBodyView = CustomCoachMarkBodyView()
        var coachMarkArrowView: CustomCoachMarkArrowView?

        var width: CGFloat = 0.0

        switch index {
        case 0: configure(view0: coachMarkBodyView, andUpdateWidth: &width)
        case 1: configure(view1: coachMarkBodyView, andUpdateWidth: &width)
        case 2: configure(view2: coachMarkBodyView, andUpdateWidth: &width)
        case 3: configure(view3: coachMarkBodyView, andUpdateWidth: &width)
        case 4: configure(view4: coachMarkBodyView, andUpdateWidth: &width)
        default: break
        }

        // We create an arrow only if an orientation is provided (i. e., a cutoutPath is provided).
        // For that custom coachmark, we'll need to update a bit the arrow, so it'll look like
        // it fits the width of the view.
        if let arrowOrientation = coachMark.arrowOrientation {
            let view = CustomCoachMarkArrowView(orientation: arrowOrientation)

            // If the view is larger than 1/3 of the overlay width, we'll shrink a bit the width
            // of the arrow.
            let oneThirdOfWidth = self.view.window!.frame.size.width / 3
            let adjustedWidth = width >= oneThirdOfWidth
                                    ? width - 2 * coachMark.horizontalMargin
                                    : width

            view.plate.widthAnchor.constraint(equalToConstant: adjustedWidth).isActive = true
            coachMarkArrowView = view
        }

        return (bodyView: coachMarkBodyView, arrowView: coachMarkArrowView)
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        constraintsForSkipView skipView: UIView,
        inParent parentView: UIView
    ) -> [NSLayoutConstraint]? {

        var constraints: [NSLayoutConstraint] = []
        var topMargin: CGFloat = 0.0

        if #available(iOS 13.0, *) {
            let statusBarManager = view.window?.windowScene?.statusBarManager

            if let statusBarManager = statusBarManager, !statusBarManager.isStatusBarHidden {
                topMargin = statusBarManager.statusBarFrame.size.height
            }
        } else {
            if !UIApplication.shared.isStatusBarHidden {
                topMargin = UIApplication.shared.statusBarFrame.size.height
            }
        }

        constraints.append(contentsOf: [
            skipView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            skipView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])

        if #available(iOS 13.0, *) {
            let statusBarManager = view.window?.windowScene?.statusBarManager

            if let statusBarManager = statusBarManager, statusBarManager.isStatusBarHidden {
                constraints.append(contentsOf: [
                    skipView.topAnchor.constraint(equalTo: parentView.topAnchor),
                    skipView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
                ])
            }
        } else if UIApplication.shared.isStatusBarHidden {
            constraints.append(contentsOf: [
                skipView.topAnchor.constraint(equalTo: parentView.topAnchor),
                skipView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
            ])
        } else {
            constraints.append(contentsOf: [
                skipView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: topMargin),
                skipView.heightAnchor.constraint(equalToConstant: 44)
            ])
        }

        return constraints
    }

    // MARK: - Private Helpers
    private func configure(view0 view: CustomCoachMarkBodyView,
                           andUpdateWidth width: inout CGFloat) {
        view.hintLabel.text = self.avatarText
        view.nextButton.setTitle(self.nextButtonText, for: .normal)

        if let avatar = self.avatar {
            width = avatar.bounds.width
        }
    }

    private func configure(view1 view: CustomCoachMarkBodyView,
                           andUpdateWidth width: inout CGFloat) {
        view.hintLabel.text = self.handleText
        view.nextButton.setTitle(self.nextButtonText, for: .normal)

        if let handleLabel = self.handleLabel {
            width = handleLabel.bounds.width
        }
    }

    private func configure(view2 view: CustomCoachMarkBodyView,
                           andUpdateWidth width: inout CGFloat) {
        view.hintLabel.text = self.emailText
        view.nextButton.setTitle(self.nextButtonText, for: .normal)

        if let emailLabel = self.emailLabel {
            width = emailLabel.bounds.width
        }
    }

    private func configure(view3 view: CustomCoachMarkBodyView,
                           andUpdateWidth width: inout CGFloat) {
        view.hintLabel.text = self.postsText
        view.nextButton.setTitle(self.nextButtonText, for: .normal)

        if let postsLabel = self.postsLabel {
            width = postsLabel.bounds.width
        }
    }

    private func configure(view4 view: CustomCoachMarkBodyView,
                           andUpdateWidth width: inout CGFloat) {
        view.hintLabel.text = self.reputationText
        view.nextButton.setTitle(self.nextButtonText, for: .normal)

        if let reputationLabel = self.reputationLabel {
            width = reputationLabel.bounds.width
        }
    }

}
