// ProfileViewController.swift
//
// Copyright (c) 2015, 2016 Frédéric Maquin <fred@ephread.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Instructions

/// This class serves as a base for all the other examples
internal class ProfileViewController: UIViewController {
    //mark: - IBOutlet
    @IBOutlet var handleLabel: UILabel?
    @IBOutlet var emailLabel: UILabel?
    @IBOutlet var postsLabel: UILabel?
    @IBOutlet var reputationLabel: UILabel?
    @IBOutlet var avatar: UIImageView?

    //mark: - Public properties
    var coachMarksController: CoachMarksController?

    let avatarText = "That's your profile picture. You look gorgeous!"
    let profileSectionText = "You are in the profile section, where you can review all your informations."
    let handleText = "That, here, is your name. Sounds a bit generic, don't you think?"
    let emailText = "This is your email address. Nothing too fancy."
    let postsText = "Here, is the number of posts you made. You are just starting up!"
    let reputationText = "That's your reputation around here, that's actually quite good."

    let nextButtonText = "Ok!"

    //mark: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.coachMarksController = CoachMarksController()
        self.coachMarksController?.overlay.allowTap = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startInstructions()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.coachMarksController?.stop(immediately: true)
    }

    func startInstructions() {
        self.coachMarksController?.startOn(self)
    }


}
