// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

/// This class serves as a base for all the other examples
internal class LargeCutoutViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var halfInvisibleOverlay: UIView!

    // MARK: - Public properties
    var tutorialController = TutorialController()

    let tableViewText = """
                        That's a gorgeous table view in which all your content sits. \
                        Don't be afraid to scroll!
                        """
    let halfTableViewText = "That's half a tableView for testing."

    let nextButtonText = "Ok!"

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Default")

        self.tutorialController.overlay.isUserInteractionEnabled = true
        self.tutorialController.dataSource = self

        let skipView = DefaultCoachMarkSkipperView()
        skipView.setTitle("Skip", for: .normal)

        self.tutorialController.skipView = skipView
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
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension LargeCutoutViewController: TutorialControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: TutorialController) -> Int {
        return 2
    }

    func coachMarksController(
        _ coachMarksController: TutorialController,
        coachMarkAt index: Int
    ) -> CoachMarkConfiguration {
        switch index {
        case 0:
            let pathMaker = { (frame: CGRect) -> UIBezierPath in
                return UIBezierPath(rect: frame)
            }

            var coachMark = tutorialController.helper.makeCoachMark(for: tableView,
                                                                      cutoutPathMaker: pathMaker)
            coachMark.isDisplayedOverCutoutPath = true

            return coachMark
        case 1:
            var coachMark = tutorialController.helper.makeCoachMark(for: halfInvisibleOverlay)
            coachMark.isDisplayedOverCutoutPath = true

            return coachMark
        default:
            return tutorialController.helper.makeCoachMark()
        }
    }

    func coachMarksController(
        _ coachMarksController: TutorialController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMarkConfiguration
    ) -> (bodyView: (UIView & CoachMarkContentView), arrowView: (UIView & CoachMarkArrowView)?) {

        let coachViews = tutorialController.helper.makeDefaultCoachViews(
            withArrow: true, arrowOrientation: coachMark.arrowOrientation
        )

        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = self.tableViewText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = self.halfTableViewText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        default: break
        }

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}

extension LargeCutoutViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default")!
        cell.textLabel?.text = "Cell"

        return cell
    }
}
