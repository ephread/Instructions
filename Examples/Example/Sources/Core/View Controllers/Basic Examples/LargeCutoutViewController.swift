// LargeCutoutViewController.swift
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

/// This class serves as a base for all the other examples
internal class LargeCutoutViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var halfInvisibleOverlay: UIView!

    // MARK: - Public properties
    var coachMarksController = CoachMarksController()

    let tableViewText = "That's a gorgeous table view in which all your content sits." +
                        "Don't be afraid to scroll!"
    let halfTableViewText = "That's half a tableView for testing."

    let nextButtonText = "Ok!"

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Default")

        self.coachMarksController.overlay.allowTap = true
        self.coachMarksController.dataSource = self

        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", for: .normal)

        self.coachMarksController.skipView = skipView
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
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension LargeCutoutViewController: CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkAt index: Int
    ) -> CoachMark {
        switch(index) {
        case 0:
            let pathMaker = { (frame: CGRect) -> UIBezierPath in
                return UIBezierPath(rect: frame)
            }

            var coachMark = coachMarksController.helper.makeCoachMark(for: tableView,
                                                                      cutoutPathMaker: pathMaker)
            coachMark.displayOverCutoutPath = true

            return coachMark
        case 1:
            var coachMark = coachMarksController.helper.makeCoachMark(for: halfInvisibleOverlay)
            coachMark.displayOverCutoutPath = true

            return coachMark
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }

    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true, arrowOrientation: coachMark.arrowOrientation
        )

        switch(index) {
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
