// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

/// This class serves as a base for all the other examples
internal class ProfileViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var handleLabel: UILabel?
    @IBOutlet weak var emailLabel: UILabel?
    @IBOutlet weak var postsLabel: UILabel?
    @IBOutlet weak var reputationLabel: UILabel?
    @IBOutlet weak var avatar: UIImageView?

    // MARK: - Public properties
    var tutorialController = TutorialController()

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

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorialController.overlay.isUserInteractionEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startInstructions()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tutorialController.stop(immediately: true)
    }

    // MARK: - Methods
    func startInstructions() {
        tutorialController.start(in: .newWindow(over: self))
    }
}
