// Copyright (c) 2017-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

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

        coachMarksController.overlay.isUserInteractionEnabled = false
        coachMarksController.dataSource = self
        coachMarksController.delegate = self

        textField.delegate = self

        textField.returnKeyType = UIReturnKeyType.done

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
        switch index {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: self.avatar)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.textField)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {

        var coachViews: (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?)

        switch index {
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
