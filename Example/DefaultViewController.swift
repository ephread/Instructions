// DefaultViewController.swift
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

// That's the default controller, using every defaults made available by Instructions.
// It can't get any simpler.
internal class DefaultViewController: ProfileViewController, CoachMarksControllerDataSource {
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coachMarksController?.datasource = self

        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", forState: .Normal)

        self.coachMarksController?.skipView = skipView
    }

    //MARK: - Protocol Conformance | CoachMarksControllerDataSource
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 5
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
            coachViews.bodyView.hintLabel.text = self.profileSectionText
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
