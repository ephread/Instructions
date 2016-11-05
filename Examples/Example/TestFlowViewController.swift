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
class TestFlowViewController: ProfileViewController {

    let text1 = "CoachMark 1"
    let text2 = "CoachMark 2"
    let text3 = "CoachMark 3"

    @IBOutlet var tapMeButton : UIButton!

    //mark: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coachMarksController?.dataSource = self
        self.coachMarksController?.delegate = self

        self.emailLabel?.layer.cornerRadius = 4.0
        self.postsLabel?.layer.cornerRadius = 4.0
        self.reputationLabel?.layer.cornerRadius = 4.0

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)

        self.coachMarksController?.skipView = skipView
        self.coachMarksController?.overlay.allowTap = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func performButtonTap(_ sender: AnyObject) {
        // The user tapped on the button, so let's carry on!
        //self.coachMarksController?.flow.showNext()

        self.coachMarksController?.stop(immediately: true)
        self.coachMarksController?.startOn(self)
    }
}

//mark: - Protocol Conformance | CoachMarksControllerDataSource
extension TestFlowViewController: CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        print("numberOfCoachMarksForCoachMarksController: \(index)")
        return 3
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        print("coachMarksForIndex: \(index)")
        switch(index) {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: self.navigationController?.navigationBar) { (frame: CGRect) -> UIBezierPath in
                return UIBezierPath(rect: frame)
            }
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.handleLabel)
        case 2:
            var coachMark = coachMarksController.helper.makeCoachMark(for: self.tapMeButton)
            coachMark.allowTouchInsideCutoutPath = true

            return coachMark
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        print("coachMarkViewsForIndex: \(index)")
        var coachViews: (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?)

        coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, withNextText: false, arrowOrientation: coachMark.arrowOrientation)

        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = self.text1
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = self.text2
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = self.text3
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        default: break
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}

//mark: - Protocol Conformance | CoachMarksControllerDelegate
extension TestFlowViewController: CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkWillLoadForIndex index: Int) -> Bool {
        print("coachMarkWillLoadForIndex: \(index)")
        return true
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkWillShow coachMark: inout CoachMark,
                                                      forIndex index: Int) {
        print("coachMarkWillShow forIndex: \(index)")
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkWillDisappear coachMark: CoachMark,
                                                     forIndex index: Int) {
        print("coachMarkWillDisappear forIndex: \(index)")
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didFinishShowingAndWasSkipped skipped: Bool) {
        print("didFinishShowingAndWasSkipped: \(skipped)")
    }
}
