import UIKit
import Instructions

class ViewController: UIViewController, CoachMarksControllerDataSource {

    @IBOutlet var rectangleView: UIView?

    let coachMarksController = CoachMarksController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.coachMarksController.dataSource = self

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", forState: .Normal)

        self.coachMarksController.skipView = skipView
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.coachMarksController.startOn(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfCoachMarksForCoachMarksController(coachMarkController: CoachMarksController)
        -> Int {
            return 1
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex: Int)
        -> CoachMark {
            return coachMarksController.coachMarkForView(rectangleView)
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark)
        -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
            let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)

            coachViews.bodyView.hintLabel.text = "Hello! I'm a Coach Mark!"
            coachViews.bodyView.nextLabel.text = "Ok!"

            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}
