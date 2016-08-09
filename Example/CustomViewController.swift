// CustomViewsViewController.swift
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

// Will display custom coach marks.
internal class CustomViewsViewController: ProfileViewController {

    //MARK: - IBOutlet
    @IBOutlet var allView: UIView?

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coachMarksController?.dataSource = self

        self.coachMarksController?.overlayBackgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", forState: .Normal)
        skipView.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        skipView.setBackgroundImage(nil, forState: .Normal)
        skipView.setBackgroundImage(nil, forState: .Highlighted)
        skipView.layer.cornerRadius = 0
        skipView.backgroundColor = UIColor.darkGrayColor()

        self.coachMarksController?.skipView = skipView
    }
}

//MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension CustomViewsViewController: CoachMarksControllerDataSource {
    //MARK: - Protocol Conformance | CoachMarksControllerDataSource
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 5
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {

        // This will create cutout path matching perfectly the given view.
        // No padding!
        let flatBezierPathBlock = { (frame: CGRect) -> UIBezierPath in
            return UIBezierPath(rect: frame)
        }

        var coachMark : CoachMark

        switch(index) {
        case 0:
            coachMark = coachMarksController.coachMarkForView(self.avatar) { (frame: CGRect) -> UIBezierPath in
                // This will create a circular cutoutPath, perfect for the circular avatar!
                return UIBezierPath(ovalInRect: CGRectInset(frame, -4, -4))
            }
        case 1:
            coachMark = coachMarksController.coachMarkForView(self.handleLabel)
            coachMark.arrowOrientation = .Top
        case 2:
            coachMark = coachMarksController.coachMarkForView(self.allView, pointOfInterest: self.emailLabel?.center, bezierPathBlock: flatBezierPathBlock)
        case 3:
            coachMark = coachMarksController.coachMarkForView(self.allView, pointOfInterest: self.postsLabel?.center, bezierPathBlock: flatBezierPathBlock)
        case 4:
            coachMark = coachMarksController.coachMarkForView(self.allView, pointOfInterest: self.reputationLabel?.center, bezierPathBlock: flatBezierPathBlock)
        default:
            coachMark = coachMarksController.coachMarkForView()
        }

        coachMark.gapBetweenCoachMarkAndCutoutPath = 6.0

        return coachMark
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        let coachMarkBodyView = CustomCoachMarkBodyView()
        var coachMarkArrowView: CustomCoachMarkArrowView? = nil

        var width: CGFloat = 0.0

        switch(index) {
        case 0:
            coachMarkBodyView.hintLabel.text = self.avatarText
            coachMarkBodyView.nextButton.setTitle(self.nextButtonText, forState: .Normal)

            if let avatar = self.avatar {
                width = avatar.bounds.width
            }
        case 1:
            coachMarkBodyView.hintLabel.text = self.handleText
            coachMarkBodyView.nextButton.setTitle(self.nextButtonText, forState: .Normal)

            if let handleLabel = self.handleLabel {
                width = handleLabel.bounds.width
            }
        case 2:
            coachMarkBodyView.hintLabel.text = self.emailText
            coachMarkBodyView.nextButton.setTitle(self.nextButtonText, forState: .Normal)

            if let emailLabel = self.emailLabel {
                width = emailLabel.bounds.width
            }
        case 3:
            coachMarkBodyView.hintLabel.text = self.postsText
            coachMarkBodyView.nextButton.setTitle(self.nextButtonText, forState: .Normal)

            if let postsLabel = self.postsLabel {
                width = postsLabel.bounds.width
            }
        case 4:
            coachMarkBodyView.hintLabel.text = self.reputationText
            coachMarkBodyView.nextButton.setTitle(self.nextButtonText, forState: .Normal)

            if let reputationLabel = self.reputationLabel {
                width = reputationLabel.bounds.width
            }
        default: break
        }

        // We create an arrow only if an orientation is provided (i. e., a cutoutPath is provided).
        // For that custom coachmark, we'll need to update a bit the arrow, so it'll look like
        // it fits the width of the view.
        if let arrowOrientation = coachMark.arrowOrientation {
            coachMarkArrowView = CustomCoachMarkArrowView(orientation: arrowOrientation)

            // If the view is larger than 1/3 of the overlay width, we'll shrink a bit the width
            // of the arrow.
            let oneThirdOfWidth = coachMarksController.overlay.frame.size.width / 3
            let adjustedWidth = width >= oneThirdOfWidth ? width - 2 * coachMark.horizontalMargin : width

            coachMarkArrowView!.plate.addConstraint(NSLayoutConstraint(item: coachMarkArrowView!.plate, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: adjustedWidth))
        }

        return (bodyView: coachMarkBodyView, arrowView: coachMarkArrowView)
    }

    func coachMarksController(coachMarksController: CoachMarksController, constraintsForSkipView skipView: UIView, inParentView parentView: UIView) -> [NSLayoutConstraint]? {

        var constraints: [NSLayoutConstraint] = []
        var topMargin: CGFloat = 0.0

        if !UIApplication.sharedApplication().statusBarHidden {
            topMargin = UIApplication.sharedApplication().statusBarFrame.size.height
        }

        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|[skipView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["skipView": skipView]))

        if UIApplication.sharedApplication().statusBarHidden {
            constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|[skipView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["skipView": skipView]))
        } else {
            constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|-topMargin-[skipView(==44)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["topMargin": topMargin],
                views: ["skipView": skipView]))
        }
        
        return constraints
    }
}