// KeyboardViewController.swift
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
import InstructionsAppExtensions // <-- If you're using Carthage or managing frameworks manually.
//import Instructions <-- If you're using CocoaPods.

class KeyboardViewController: UIInputViewController, CoachMarksControllerDataSource {

    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var secondButton: UIButton!

    var keyboardView: UIView!
    var coachMarksController: CoachMarksController?

    override func updateViewConstraints() {
        super.updateViewConstraints()

        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadInterface()

        self.nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)

        self.coachMarksController = CoachMarksController()
        self.coachMarksController?.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)

        self.coachMarksController?.skipView = skipView

        self.coachMarksController?.startOn(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }

    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2;
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: self.nextKeyboardButton)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.secondButton)
        default:
            return CoachMark()
        }
    }


    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)

        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = "Tap here to change the keyboard."
            coachViews.bodyView.nextLabel.text = "Next"
        case 1:
            coachViews.bodyView.hintLabel.text = "Button that does nothing."
            coachViews.bodyView.nextLabel.text = "Finish"
        default: break
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

    private func loadInterface() {
        // load the nib file
        let nib = UINib(nibName: "Keyboard", bundle: nil)
        // instantiate the view
        keyboardView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        // add the interface to the main view
        view.addSubview(keyboardView)

        keyboardView.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[keyboardView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["keyboardView" : keyboardView]))

        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[keyboardView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["keyboardView" : keyboardView]))
    }
}
