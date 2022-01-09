// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

class ViewController: UIViewController, TutorialControllerDataSource {

    @IBOutlet var rectangleView: UIView?

    let tutorialController = TutorialController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tutorialController.dataSource = self

        let skipView = DefaultCoachMarkSkipperView()
        skipView.setTitle("Skip", for: .normal)

        self.tutorialController.skipView = skipView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.tutorialController.start(in: .newWindow(over: self,
                                                       at: UIWindow.Level.statusBar + 1))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfCoachMarks(for coachMarkController: TutorialController)
        -> Int {
            return 1
    }

    func coachMarksController(_ coachMarksController: TutorialController, coachMarkAt: Int)
        -> CoachMarkConfiguration {
            return tutorialController.helper.makeCoachMark(for: rectangleView)
    }

    func coachMarksController(
        _ coachMarksController: TutorialController,
        coachMarkViewsAt: Int,
        madeFrom coachMark: CoachMarkConfiguration
    ) -> (bodyView: (UIView & CoachMarkContentView), arrowView: (UIView & CoachMarkArrowView)?) {
        let coachViews = tutorialController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )

        coachViews.bodyView.hintLabel.text = "Hello! I'm a Coach Mark!"
        coachViews.bodyView.nextLabel.text = "Ok!"

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
