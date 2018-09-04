// PausingViewController.swift
//
// Copyright (c) 2018 Frédéric Maquin <fred@ephread.com>
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

// A controller showcasing the ability to pause the flow, do something else on the screen
// and start it again.
internal class PausingCodeViewController: ProfileViewController {

    let text1 = "That's a beautiful navigation bar."
    let text2 = "We're going to pause the flow. Use this button to start it again."
    let text2Alternate = "We're going to pause the flow, without hiding anything. " +
                         "Use the skip button to get out."
    let text3 = "Good job, that's all folks!"

    var pauseStyle: PauseStyle = .hideNothing

    @IBOutlet var tapMeButton : UIButton!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        coachMarksController.dataSource = self
        coachMarksController.delegate = self

        emailLabel?.layer.cornerRadius = 4.0
        postsLabel?.layer.cornerRadius = 4.0
        reputationLabel?.layer.cornerRadius = 4.0

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)

        coachMarksController.skipView = skipView
        coachMarksController.overlay.allowTap = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func performButtonTap(_ sender: AnyObject) {
        // The user tapped on the button, so let's carry on!
        coachMarksController.flow.resume()
    }

    // MARK: - Protocol Conformance | CoachMarksControllerDelegate
    override func coachMarksController(_ coachMarksController: CoachMarksController,
                                       willShow coachMark: inout CoachMark,
                                       beforeChanging change: ConfigurationChange,
                                       at index: Int) {
        if index == 2 && change == .nothing {
            coachMarksController.flow.pause(and: pauseStyle)
        }
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension PausingCodeViewController: CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 3
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        let controller = coachMarksController

        switch(index) {
        case 0:
            let navigationBar = navigationController?.navigationBar
            return controller.helper.makeCoachMark(for: navigationBar) { (frame) -> UIBezierPath in
                // This will make a cutoutPath matching the shape of
                // the component (no padding, no rounded corners).
                return UIBezierPath(rect: frame)
            }
        case 1:
            return controller.helper.makeCoachMark(for: tapMeButton)
        case 2:
            return controller.helper.makeCoachMark(for: postsLabel)

        default: return CoachMark()
        }
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark)
    -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true, withNextText: true, arrowOrientation: coachMark.arrowOrientation
        )

        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = text1
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 1:
            if pauseStyle == .hideInstructions {
                coachViews.bodyView.hintLabel.text = text2
            } else {
                coachViews.bodyView.hintLabel.text = text2Alternate
            }

            coachViews.bodyView.nextLabel.text = nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = text3
            coachViews.bodyView.nextLabel.text = nextButtonText
        default: break
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
