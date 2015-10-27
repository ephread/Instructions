// InstructionsManager.swift
//
// Copyright (c) 2015 Frédéric Maquin <fred@ephread.com>
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
@objc public class InstructionsManager: NSObject,
                                        CoachMarksControllerDataSource {
    //MARK: - Public properties
    weak var handleLabel: UILabel!
    weak var emailLabel: UILabel!
    weak var postsLabel: UILabel!
    weak var reputationLabel: UILabel!

    unowned let viewController: UIViewController

    //MARK: - Private properties
    private var coachMarksController: CoachMarksController?

    let handleText = "That, here, is your name. Sounds a bit generic, don't you think?"
    let emailText = "This is your email address. Nothing too fancy."
    let postsText = "Here, is the number of posts you made. You are just starting up!"
    let reputationText = "That's your reputation around here, that's actually quite good."

    let nextButtonText = "Ok!"

    init(parentViewController viewController: UIViewController) {
        self.viewController = viewController
    }

    func startTour() {
        self.coachMarksController = CoachMarksController()
        self.coachMarksController?.allowOverlayTap = true
        self.coachMarksController?.datasource = self

        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0

        self.coachMarksController?.startOn(viewController)
    }

    //MARK: - Protocol Conformance | CoachMarksControllerDataSource
    public func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 4
    }

    public func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.coachMarkForView(self.handleLabel)
        case 1:
            return coachMarksController.coachMarkForView(self.emailLabel)
        case 2:
            return coachMarksController.coachMarkForView(self.postsLabel)
        case 3:
            return coachMarksController.coachMarkForView(self.reputationLabel)
        default:
            return coachMarksController.coachMarkForView()
        }
    }

    public func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)

        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = self.handleText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = self.emailText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = self.postsText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 3:
            coachViews.bodyView.hintLabel.text = self.reputationText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        default: break
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
