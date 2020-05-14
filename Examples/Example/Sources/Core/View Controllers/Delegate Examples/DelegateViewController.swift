// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// MARK: - Main Controller
// This class is an example of what can be achieved with the delegate methods.
class DelegateViewController: ProfileViewController, CoachMarksControllerDataSource {

    // MARK: IBOutlets
    @IBOutlet var avatarVerticalPositionConstraint: NSLayoutConstraint?

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        coachMarksController.delegate = self
        coachMarksController.animationDelegate = self
        coachMarksController.dataSource = self

        emailLabel?.layer.cornerRadius = 4.0
        postsLabel?.layer.cornerRadius = 4.0
        reputationLabel?.layer.cornerRadius = 4.0

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)

        coachMarksController.skipView = skipView
    }

    // MARK: - Protocol Conformance | CoachMarksControllerDataSource
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 5
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0:
            let cutoutPathMaker = { (frame: CGRect) -> UIBezierPath in
                return UIBezierPath(ovalIn: frame.insetBy(dx: -4, dy: -4))
            }

            return coachMarksController.helper.makeCoachMark(for: avatar,
                                                             cutoutPathMaker: cutoutPathMaker)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: handleLabel)
        case 2:
            return coachMarksController.helper.makeCoachMark(for: emailLabel)
        case 3:
            return coachMarksController.helper.makeCoachMark(for: postsLabel)
        case 4:
            return coachMarksController.helper.makeCoachMark(for: reputationLabel)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark
    ) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {

        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )

        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = avatarText
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = handleText
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = emailText
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 3:
            coachViews.bodyView.hintLabel.text = postsText
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 4:
            coachViews.bodyView.hintLabel.text = reputationText
            coachViews.bodyView.nextLabel.text = nextButtonText
        default: break
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

    // MARK: - Protocol Conformance | CoachMarksControllerDelegate
    override func coachMarksController(_ coachMarksController: CoachMarksController,
                                       configureOrnamentsOfOverlay overlay: UIView) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(label)

        label.text = "OVERLAY"
        label.alpha = 0.5
        label.font = label.font.withSize(60.0)

        label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: overlay.topAnchor, constant: 100).isActive = true
    }

    override func coachMarksController(_ coachMarksController: CoachMarksController,
                                       willShow coachMark: inout CoachMark,
                                       beforeChanging change: ConfigurationChange, at index: Int) {
        if index == 0 && change == .nothing {
            // We'll need to play an animation before showing up the coach mark.
            // To be able to play the animation and then show the coach mark and not stall
            // the UI (i. e. keep the asynchronicity), we'll pause the controller.
            coachMarksController.flow.pause()

            // Then we run the animation.
            avatarVerticalPositionConstraint?.constant = 30
            view.needsUpdateConstraints()

            UIView.animate(withDuration: 1, animations: { () -> Void in
                self.view.layoutIfNeeded()
            }, completion: { _ -> Void in
                let maker = { (frame: CGRect) -> UIBezierPath in
                    return UIBezierPath(ovalIn: frame.insetBy(dx: -4, dy: -4))
                }
                // Once the animation is completed, we update the coach mark,
                // and start the display again.
                coachMarksController.helper.updateCurrentCoachMark(
                    usingView: self.avatar,
                    pointOfInterest: nil,
                    cutoutPathMaker: maker
                )

                coachMarksController.flow.resume()
            })
        }
    }

    override func coachMarksController(_ coachMarksController: CoachMarksController,
                                       willHide coachMark: CoachMark, at index: Int) {
        if index == 1 {
            avatarVerticalPositionConstraint?.constant = 0
            view.needsUpdateConstraints()

            UIView.animate(withDuration: 1, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }

    override func coachMarksController(_ coachMarksController: CoachMarksController,
                                       didEndShowingBySkipping skipped: Bool) {
        let newColor: UIColor = skipped ? .systemPurple : .systemOrange

        UIView.animate(withDuration: 1, animations: { () -> Void in
            self.view.backgroundColor = newColor
        })
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerAnimationDelegate
extension DelegateViewController: CoachMarksControllerAnimationDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              fetchAppearanceTransitionOfCoachMark coachMarkView: UIView,
                              at index: Int,
                              using manager: CoachMarkTransitionManager) {
        manager.parameters.options = [.beginFromCurrentState]
        manager.animate(.regular, animations: { _ in
            coachMarkView.transform = .identity
            coachMarkView.alpha = 1
        }, fromInitialState: {
            coachMarkView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            coachMarkView.alpha = 0
        })
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              fetchDisappearanceTransitionOfCoachMark coachMarkView: UIView,
                              at index: Int,
                              using manager: CoachMarkTransitionManager) {
        manager.parameters.keyframeOptions = [.beginFromCurrentState]
        manager.animate(.keyframe, animations: { _ in
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                coachMarkView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                coachMarkView.alpha = 0
            })
        })
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              fetchIdleAnimationOfCoachMark coachMarkView: UIView,
                              at index: Int,
                              using manager: CoachMarkAnimationManager) {
        manager.parameters.options = [.repeat, .autoreverse, .allowUserInteraction]
        manager.parameters.duration = 0.7

        manager.animate(.regular, animations: { context in
            let offset: CGFloat = context.coachMark.arrowOrientation == .top ? 10 : -10
            coachMarkView.transform = CGAffineTransform(translationX: 0, y: offset)
        })
    }
}
