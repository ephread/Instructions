// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

/// This class serves as a base for all the other examples
internal class ProfileViewController: UIViewController,
                                      CoachMarksControllerDelegate {
    // MARK: - IBOutlet
    @IBOutlet weak var handleLabel: UILabel?
    @IBOutlet weak var emailLabel: UILabel?
    @IBOutlet weak var postsLabel: UILabel?
    @IBOutlet weak var reputationLabel: UILabel?
    @IBOutlet weak var avatar: UIImageView?

    // MARK: - Public properties
    var coachMarksController = CoachMarksController()

    let avatarText = "That's your profile picture. You look gorgeous!"
    let profileSectionText = """
                             You are in the profile section, where you can review \
                             all your informations.
                             """
    let handleText = "That, here, is your name. Sounds a bit generic, don't you think?"
    let emailText = "This is your email address. Nothing too fancy."
    let postsText = "Here, is the number of posts you made. You are just starting up!"
    let reputationText = "That's your reputation around here, that's actually quite good."

    let nextButtonText = "Ok!"

    // Used for Snapshot testing (i. e. has nothing to do with the example)
    weak var snapshotDelegate: CoachMarksControllerDelegate?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        coachMarksController.overlay.isUserInteractionEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startInstructions()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        coachMarksController.stop(immediately: true)
    }

    func startInstructions() {
        coachMarksController.start(in: .window(over: self))
    }

    // MARK: Protocol Conformance | CoachMarksControllerDelegate
    // Used for Snapshot testing (i. e. has nothing to do with the example)
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              configureOrnamentsOfOverlay overlay: UIView) {
        snapshotDelegate?.coachMarksController(coachMarksController,
                                               configureOrnamentsOfOverlay: overlay)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willShow coachMark: inout CoachMark,
                              beforeChanging change: ConfigurationChange,
                              at index: Int) {
        snapshotDelegate?.coachMarksController(coachMarksController, willShow: &coachMark,
                                               beforeChanging: change,
                                               at: index)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didShow coachMark: CoachMark,
                              afterChanging change: ConfigurationChange,
                              at index: Int) {
        snapshotDelegate?.coachMarksController(coachMarksController, didShow: coachMark,
                                               afterChanging: change,
                                               at: index)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willHide coachMark: CoachMark,
                              at index: Int) {
        snapshotDelegate?.coachMarksController(coachMarksController, willHide: coachMark,
                                               at: index)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didHide coachMark: CoachMark,
                              at index: Int) {
        snapshotDelegate?.coachMarksController(coachMarksController, didHide: coachMark,
                                               at: index)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didEndShowingBySkipping skipped: Bool) {
        snapshotDelegate?.coachMarksController(coachMarksController,
                                               didEndShowingBySkipping: skipped)
    }

    func shouldHandleOverlayTap(in coachMarksController: CoachMarksController,
                                at index: Int) -> Bool {
        return true
    }
}
