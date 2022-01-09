// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// This class mix different kind of coach marks together.
internal class MixedCoachMarksViewsViewController: ProfileViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var answersLabel: UILabel!

    // MARK: - Private properties
    private let swipeImage = UIImage(named: "swipe")

    private let answersText = "That's the number of answers you gave."

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tutorialController.dataSource = self
        self.tutorialController.overlay.backgroundColor = UIColor(red: 0.2,
                                                                  green: 0.2,
                                                                  blue: 0.2,
                                                                  alpha: 0.5)
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension MixedCoachMarksViewsViewController: TutorialControllerDataSource {
    func numberOfCoachMarks(in tutorialController: TutorialController) -> Int {
        return 5
    }

    func tutorialController(_ tutorialController: TutorialController,
                            configurationForCoachMarkAt index: Int) -> CoachMarkConfiguration {
        var coachMark: CoachMarkConfiguration

        switch index {
        case 0:
            coachMark = tutorialController.helper.makeCoachMark(for: handleLabel)
        case 1:
            coachMark = tutorialController.helper.makeCoachMark(for: emailLabel)
        case 2:
            coachMark = tutorialController.helper.makeCoachMark(for: postsLabel)
        case 3:
            // A frame rectangle can also be passed.
            coachMark = tutorialController.helper.makeCoachMark(forFrame: answersLabel.frame,
                                                                  in: answersLabel.superview)
        case 4:
            coachMark = tutorialController.helper.makeCoachMark(for: reputationLabel)
        default:
            coachMark = tutorialController.helper.makeCoachMark()
        }

        coachMark.marginBetweenCoachMarkAndCutoutPath = 6.0

        return coachMark
    }

    func tutorialController(
        _ tutorialController: TutorialController,
        compoundViewFor configuration: CoachMarkConfiguration,
        at index: Int
    ) -> CoachMarkViewComponents {
        var bodyView: CoachMarkContent
        var arrowView: CoachMarkPointer?

        switch index {
        case 0: (bodyView, arrowView) = createViews0(from: coachMark)
        case 1: (bodyView, arrowView) = createViews1(from: coachMark)
        case 2: (bodyView, arrowView) = createViews2(from: coachMark)
        case 3: (bodyView, arrowView) = createViews3(from: coachMark)
        case 4: (bodyView, arrowView) = createViews4(from: coachMark)
        default: (bodyView, arrowView) = createDefaultViews(from: coachMark)
        }

        return (bodyView: bodyView, arrowView: arrowView)
    }

    // MARK: - Private Helpers
    private func createViews0(
        from coachMark: CoachMarkConfiguration
    ) -> CoachMarkViewComponents {
        let contentView = CustomCoachMarkContentView()
        var pointerView: CustomCoachMarkPointerView?

        contentView.hintLabel.text = self.handleText
        contentView.nextButton.setTitle(self.nextButtonText, for: .normal)

        var width: CGFloat = 0.0

        if let handleLabel = self.handleLabel {
            width = handleLabel.bounds.width
        }

        switch coachMark.position {
        case .above, .below:
            let view = CustomCoachMarkPointerView(position: coachMark.position)
            view.plate.widthAnchor.constraint(equalToConstant: width).isActive = true

            coachMarkArrowView = view
        default: break
        }

        return CoachMarkViewComponents
    }

    private func createViews1(
        from coachMark: CoachMarkConfiguration
    ) -> CoachMarkViewComponents {
        let components = tutorialController.helper.makeDefaultViews(
            showPointer: true,
            position: coachMark.position
        )

        components.contentView.hintLabel.text = self.emailText
        components.contentView.nextLabel.text = self.nextButtonText

        return (coachViews.bodyView, coachViews.arrowView)
    }

    private func createViews2(
        from coachMark: CoachMarkConfiguration
    ) -> (bodyView: CoachMarkContent, arrowView: CoachMarkPointer?) {
        let coachViews = tutorialController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation,
            hintText: self.postsText,
            nextText: self.nextButtonText
        )

        coachViews.bodyView.background.cornerRadius = 20
        coachViews.bodyView.background.innerColor = innerColor
        coachViews.bodyView.background.borderColor = borderColor
        coachViews.bodyView.background.highlightedInnerColor = highlightedInnerColor
        coachViews.bodyView.background.highlightedBorderColor = highlightedBorderColor
        coachViews.bodyView.hintLabel.textColor = .white
        coachViews.bodyView.nextLabel.textColor = .white
        coachViews.bodyView.separator.backgroundColor = .white

        coachViews.arrowView?.background.innerColor = innerColor
        coachViews.arrowView?.background.borderColor = borderColor
        coachViews.arrowView?.background.highlightedInnerColor = highlightedInnerColor
        coachViews.arrowView?.background.highlightedBorderColor = highlightedBorderColor

        return (coachViews.bodyView, coachViews.arrowView)
    }

    private func createViews3(
        from coachMark: CoachMarkConfiguration
    ) -> (bodyView: CoachMarkContent, arrowView: CoachMarkPointer?) {
        let coachViews = tutorialController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation,
            hintText: self.answersText,
            nextText: nil
        )

        return (coachViews.bodyView, coachViews.arrowView)
    }

    private func createViews4(
        from coachMark: CoachMarkConfiguration
    ) -> (bodyView: CoachMarkContent, arrowView: CoachMarkPointer?) {
        let coachMarkBodyView = TransparentCoachMarkContentView()
        var coachMarkArrowView: TransparentCoachMarkArrowView?

        coachMarkBodyView.hintLabel.text = self.reputationText

        if let arrowOrientation = coachMark.arrowOrientation {
            coachMarkArrowView = TransparentCoachMarkArrowView(orientation: arrowOrientation)
        }

        return (coachMarkBodyView, coachMarkArrowView)
    }

    private func createDefaultViews(
        from coachMark: CoachMarkConfiguration
    ) -> (bodyView: CoachMarkContent, arrowView: CoachMarkPointer?) {
        let coachViews = tutorialController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )

        return (coachViews.bodyView, coachViews.arrowView)
    }
}

private extension MixedCoachMarksViewsViewController {
    var borderColor: UIColor {
        return UIColor { (traits) -> UIColor in
            if traits.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
            } else {
                return #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            }
        }
    }

    var highlightedBorderColor: UIColor {
        let defaultColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)

        return UIColor { (traits) -> UIColor in
            if traits.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            } else {
                return defaultColor
            }
        }
    }

    var innerColor: UIColor {
        let defaultColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)

        return UIColor { (traits) -> UIColor in
            if traits.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            } else {
                return defaultColor
            }
        }
    }

    var highlightedInnerColor: UIColor {
        let defaultColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return UIColor { (traits) -> UIColor in
            if traits.userInterfaceStyle == .dark {
                return #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            } else {
                return defaultColor
            }
        }
    }
}
