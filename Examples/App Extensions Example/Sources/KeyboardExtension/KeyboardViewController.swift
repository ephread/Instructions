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

class KeyboardViewController: UIInputViewController,
                              CoachMarksControllerDataSource,
                              CoachMarksControllerDelegate {

    @IBOutlet weak var nextKeyboardButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var footBallKey: UIButton!
    @IBOutlet weak var basketBallKey: UIButton!

    @IBOutlet weak var textField: UITextField!

    var keyboardView: UIView!
    var coachMarksController: CoachMarksController?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadInterface()

        self.nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)

        self.coachMarksController = CoachMarksController()
        self.coachMarksController?.dataSource = self
        self.coachMarksController?.delegate = self

        //self.coachMarksController?.overlay.blurEffectStyle = .light
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)

        self.coachMarksController?.skipView = skipView

        self.coachMarksController?.start(on: self)
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
        return 4;
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: self.nextKeyboardButton)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.continueButton)
        case 2:
            return coachMarksController.helper.makeCoachMark(for: self.footBallKey)
        case 3:
            return coachMarksController.helper.makeCoachMark(for: self.basketBallKey)
        default:
            return CoachMark()
        }
    }


    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)

        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = "Tap here to change the keyboard."
            coachViews.bodyView.nextLabel.text = "Next"
        case 1:
            coachViews.bodyView.hintLabel.text = "Touch this button to continue the flow"
            coachViews.bodyView.nextLabel.text = "Ok!"
        case 2:
            coachViews.bodyView.hintLabel.text = "Football?"
            coachViews.bodyView.nextLabel.text = "Next"
        case 3:
            coachViews.bodyView.hintLabel.text = "Basketball?"
            coachViews.bodyView.nextLabel.text = "Finish"
        default: break
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, willShow coachMark: inout CoachMark, afterSizeTransition: Bool, at index: Int) {
        if index == 2 && !afterSizeTransition {
            coachMarksController.flow.pause(and: .hideInstructions)
        }
    }

    private func loadInterface() {
        // load the nib file
        let nib = UINib(nibName: "Keyboard", bundle: nil)
        // instantiate the view
        keyboardView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        // add the interface to the main view
        view.addSubview(keyboardView)
        keyboardView.fillSuperview()
    }

    @IBAction func resumeFlow() {
        coachMarksController?.flow.resume()
    }
}

extension UIView {
    func fillSuperview() {
        guard let superview = superview else { return }

        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
}
