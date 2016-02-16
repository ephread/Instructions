// TransitionFromCodeViewController.swift
//
// Copyright (c) 2016 Frédéric Maquin <fred@ephread.com>
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

// That's the default controller, using every defaults made available by Instructions.
// It can't get any simpler.
internal class TransitionFromCodeViewController: ProfileViewController, CoachMarksControllerDataSource, CoachMarksControllerDelegate {

    let text1 = "(1) That's the first coach mark."
    let text2 = "(2) Second coeahmark no one will see."
    let text3 = "(3) We skipped the second one. Now, please tap on this button to continue!"
    let text4 = "(4) So we skipped the next two and are finally hitting the fourth one!"
    let text5 = "(5) And now we jumped to the last (fifth) one…"
    let text6 = "(6) The ability to overwrite the natural flow should be used scarcely, prefer ordering the coach mark in your dataSource."

    @IBOutlet var tapMeButton : UIButton!

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coachMarksController?.dataSource = self
        self.coachMarksController?.delegate = self

        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", forState: .Normal)

        self.coachMarksController?.skipView = skipView
        self.coachMarksController?.allowOverlayTap = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    //MARK: - Protocol Conformance | CoachMarksControllerDataSource
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 6
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.coachMarkForView(self.navigationController?.navigationBar) { (frame: CGRect) -> UIBezierPath in
                // This will make a cutoutPath matching the shape of
                // the component (no padding, no rounded corners).
                return UIBezierPath(rect: frame)
            }
        case 1:
            return coachMarksController.coachMarkForView(self.handleLabel)
        case 2:
            var coachMark = coachMarksController.coachMarkForView(self.tapMeButton)
            coachMark.disableOverlayTap = true
            return coachMark
        case 3:
            return coachMarksController.coachMarkForView(self.emailLabel)
        case 4:
            return coachMarksController.coachMarkForView(self.postsLabel)
        case 5:
            return coachMarksController.coachMarkForView(self.reputationLabel)
        default:
            return coachMarksController.coachMarkForView()
        }
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        var coachViews: (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?)

        switch(index) {
        case 2:
            coachViews = coachMarksController.defaultCoachViewsWithArrow(true, withNextText: false, arrowOrientation: coachMark.arrowOrientation)
            coachViews.bodyView.userInteractionEnabled = false
        default:
            coachViews = coachMarksController.defaultCoachViewsWithArrow(true, withNextText: true, arrowOrientation: coachMark.arrowOrientation)
        }

        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = self.text1
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = self.text2
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = self.text3
        case 3:
            coachViews.bodyView.hintLabel.text = self.text4
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 4:
            coachViews.bodyView.hintLabel.text = self.text5
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 5:
            coachViews.bodyView.hintLabel.text = self.text6
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        default: break
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillLoadForIndex index: Int) -> Bool {
        switch(index) {
        case 1:
            return false
        default:
            return true
        }
    }

    @IBAction func performButtonTap(sender: AnyObject) {
        self.coachMarksController?.showNext()
    }
}

func delay(delay: Double, block: ()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), block)
}
