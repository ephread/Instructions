// DelegatetViewController.swift
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

// This class show off the oportunities provided by the delegate mechanism.
internal class DelegateViewController: ProfileViewController {

    //MARK: - IBOutlet
    @IBOutlet var profileBackgroundView: UIView?
    @IBOutlet var avatarVerticalPositionConstraint: NSLayoutConstraint?

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coachMarksController?.delegate = self
        self.coachMarksController?.dataSource = self

        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0
    }
}

//MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension DelegateViewController: CoachMarksControllerDataSource {
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 5
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.coachMarkForView(self.avatar) { (frame: CGRect) -> UIBezierPath in
                return UIBezierPath(ovalInRect: CGRectInset(frame, -4, -4))
            }
        case 1:
            return coachMarksController.coachMarkForView(self.handleLabel)
        case 2:
            return coachMarksController.coachMarkForView(self.emailLabel)
        case 3:
            return coachMarksController.coachMarkForView(self.postsLabel)
        case 4:
            return coachMarksController.coachMarkForView(self.reputationLabel)
        default:
            return coachMarksController.coachMarkForView()
        }
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)

        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = self.avatarText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = self.handleText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = self.emailText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 3:
            coachViews.bodyView.hintLabel.text = self.postsText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 4:
            coachViews.bodyView.hintLabel.text = self.reputationText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        default: break
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}

//MARK: - Protocol Conformance | CoachMarksControllerDelegate
extension DelegateViewController: CoachMarksControllerDelegate {
    func coachMarksController(coachMarksController: CoachMarksController, inout coachMarkWillShow coachMark: CoachMark, forIndex index: Int) {
        if index == 0 {
            // We'll need to play an animation before showing up the coach mark.
            // To be able to play the animation and then show the coach mark and not stall
            // the UI (i. e. keep the asynchronicity), we'll pause the controller.
            coachMarksController.pause()

            // Then we run the animation.
            self.avatarVerticalPositionConstraint?.constant = 30
            self.view.needsUpdateConstraints()

            UIView.animateWithDuration(1, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }, completion: { (finished: Bool) -> Void in

                    // Once the animation is completed, we update the coach mark,
                    // and start the display again.
                    coachMarksController.updateCurrentCoachMarkForView(self.avatar, pointOfInterest: nil) {
                        (frame: CGRect) -> UIBezierPath in
                        return UIBezierPath(ovalInRect: CGRectInset(frame, -4, -4))
                    }

                    coachMarksController.resume()
            })
        }
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillDisappear coachMark: CoachMark, forIndex index: Int) {
        if index == 1 {
            self.avatarVerticalPositionConstraint?.constant = 0
            self.view.needsUpdateConstraints()

            UIView.animateWithDuration(1, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }

    func didFinishShowingFromCoachMarksController(coachMarksController: CoachMarksController) {
        // If implemented, will fall back to the extension method,
        // thus warning that this method should not be used anymore.
    }

    func coachMarksController(coachMarksController: CoachMarksController, didFinishShowingAndWasSkipped skipped: Bool) {
        let newColor: UIColor

        if skipped {
            newColor = UIColor(red: 144.0/255.0, green: 26.0/255.0, blue: 146.0/255.0, alpha: 1.0)
        } else {
            newColor = UIColor(red: 244.0/255.0, green: 126.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        }

        UIView.animateWithDuration(1, animations: { () -> Void in
            self.profileBackgroundView?.backgroundColor = newColor
        })
    }
}