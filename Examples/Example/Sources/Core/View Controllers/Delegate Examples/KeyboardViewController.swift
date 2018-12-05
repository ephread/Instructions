// KeyboardViewController.swift
//
// Copyright (c) 2017 Frédéric Maquin <fred@ephread.com>
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
internal class KeyboardViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var textField: UITextField!

    // MARK: - Public properties
    var coachMarksController = CoachMarksController()

    let avatarText = "That's your profile picture. You look gorgeous!"
    let inputText = "Please enter your name here"

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        coachMarksController.overlay.allowTap = false
        coachMarksController.dataSource = self
        coachMarksController.delegate = self

        textField.delegate = self

        textField.returnKeyType = UIReturnKeyType.done;

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startInstructions()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.coachMarksController.stop(immediately: true)
    }

    func startInstructions() {
        self.coachMarksController.start(in: .window(over: self))
    }

    @objc func keyboardWillShow() {

    }

    @objc func keyboardWillHide() {

    }

    @objc func keyboardDidShow() {
        coachMarksController.flow.resume()
    }

    @objc func keyboardDidHide() {

    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension KeyboardViewController: CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: self.avatar)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.textField)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        var coachViews: (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?)

        switch(index) {
        case 1:
            coachViews = coachMarksController.helper
                                             .makeDefaultCoachViews(withArrow: true,
                                                                    withNextText: false,
                                                                    arrowOrientation: .bottom)
            coachViews.bodyView.hintLabel.text = self.inputText
            coachViews.bodyView.isUserInteractionEnabled = false
        default:
            let orientation = coachMark.arrowOrientation
            coachViews = coachMarksController.helper
                                             .makeDefaultCoachViews(withArrow: true,
                                                                    withNextText: false,
                                                                    arrowOrientation: orientation)
            coachViews.bodyView.hintLabel.text = self.avatarText
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDelegate
extension KeyboardViewController: CoachMarksControllerDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willShow coachMark: inout CoachMark,
                              beforeChanging change: ConfigurationChange,
                              at index: Int) {
        if index == 1 {
            coachMark.arrowOrientation = .bottom
            if change == .nothing {
                textField.becomeFirstResponder()
                coachMarksController.flow.pause()
            }
        }
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didEndShowingBySkipping skipped: Bool) {
        textField.resignFirstResponder()
    }
}

// MARK: - Protocol Conformance | UITextFieldDelegate
extension KeyboardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        coachMarksController.flow.showNext()
        return true
    }
}
