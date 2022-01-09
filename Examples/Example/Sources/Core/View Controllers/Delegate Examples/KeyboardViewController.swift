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
    var tutorialController = TutorialController()

    let avatarText = "That's your profile picture. You look gorgeous!"
    let inputText = "Please enter your name here"

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tutorialController.overlay.isUserInteractionEnabled = false
        tutorialController.dataSource = self
        tutorialController.delegate = self

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

        self.tutorialController.stop(immediately: true)
    }

    func startInstructions() {
        self.tutorialController.start(in: .window(over: self))
    }

    @objc func keyboardWillShow() {

    }

    @objc func keyboardWillHide() {

    }

    @objc func keyboardDidShow() {
        tutorialController.flow.resume()
    }

    @objc func keyboardDidHide() {

    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension KeyboardViewController: TutorialControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: TutorialController) -> Int {
        return 2
    }

    func coachMarksController(_ coachMarksController: TutorialController, coachMarkAt index: Int) -> CoachMarkConfiguration {
        switch index {
        case 0:
            return tutorialController.helper.makeCoachMark(for: self.avatar)
        case 1:
            return tutorialController.helper.makeCoachMark(for: self.textField)
        default:
            return tutorialController.helper.makeCoachMark()
        }
    }

    func coachMarksController(
        _ coachMarksController: TutorialController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMarkConfiguration
    ) -> (bodyView: (UIView & CoachMarkContentView), arrowView: (UIView & CoachMarkArrowView)?) {

        var coachViews: (bodyView: DefaultCoachMarkContentView, arrowView: DefaultCoachMarkPointerView?)

        switch index {
        case 1:
            coachViews = tutorialController.helper
                                             .makeDefaultCoachViews(withArrow: true,
                                                                    withNextText: false,
                                                                    arrowOrientation: .bottom)
            coachViews.bodyView.hintLabel.text = self.inputText
            coachViews.bodyView.isUserInteractionEnabled = false
        default:
            let orientation = coachMark.arrowOrientation
            coachViews = tutorialController.helper
                                             .makeDefaultCoachViews(withArrow: true,
                                                                    withNextText: false,
                                                                    arrowOrientation: orientation)
            coachViews.bodyView.hintLabel.text = self.avatarText
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}

// MARK: - Protocol Conformance | CoachMarksControllerDelegate
extension KeyboardViewController: TutorialControllerDelegate {
    func coachMarksController(_ coachMarksController: TutorialController,
                              willShow coachMark: inout CoachMarkConfiguration,
                              beforeChanging change: ConfigurationChange,
                              at index: Int) {
        if index == 1 {
            coachMark.arrowOrientation = .bottom
            if change == .nothing {
                textField.becomeFirstResponder()
                tutorialController.flow.pause()
            }
        }
    }

    func coachMarksController(_ coachMarksController: TutorialController,
                              didEndShowingBySkipping skipped: Bool) {
        textField.resignFirstResponder()
    }
}

// MARK: - Protocol Conformance | UITextFieldDelegate
extension KeyboardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tutorialController.flow.showNext()
        return true
    }
}
