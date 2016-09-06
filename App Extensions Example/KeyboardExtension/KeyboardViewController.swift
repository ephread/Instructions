//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Frédéric Maquin on 15/02/16.
//  Copyright © 2016 Ephread. All rights reserved.
//

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

        self.nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), forControlEvents: .TouchUpInside)

        self.coachMarksController = CoachMarksController()
        self.coachMarksController?.dataSource = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", forState: .Normal)

        self.coachMarksController?.skipView = skipView

        self.coachMarksController?.startOn(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }

    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 2;
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.coachMarkForView(self.nextKeyboardButton)
        case 1:
            return coachMarksController.coachMarkForView(self.secondButton)
        default:
            return CoachMark()
        }
    }


    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)

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
        keyboardView = nib.instantiateWithOwner(self, options: nil)[0] as! UIView

        // add the interface to the main view
        view.addSubview(keyboardView)

        keyboardView.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[keyboardView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["keyboardView" : keyboardView]))

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[keyboardView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["keyboardView" : keyboardView]))
    }
}
