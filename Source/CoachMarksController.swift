// CoachMarksController.swift
//
// Copyright (c) 2015, 2016 Frédéric Maquin <fred@ephread.com>,
//                          Daniel Basedow <daniel.basedow@gmail.com>,
//                          Esteban Soto <esteban.soto.dev@gmail.com>,
//                          Ogan Topkaya <>
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

//MARK: Main Class
/// Handles a set of coach marks, and display them successively.
public class CoachMarksController {
    //MARK: Public properties
    /// Implement the data source protocol and supply
    /// the coach marks to display.
    public weak var dataSource: CoachMarksControllerDataSource?

    /// Implement the delegate protocol, which methods will
    /// be called at various points.
    public weak var delegate: CoachMarksControllerDelegate?

    private(set) public lazy var overlay: OverlayView = {
        let overlayView = OverlayView()
        overlayView.delegate = self

        return overlayView
    }()

    /// Provides methods easing the process of creating cutout paths.
    private(set) public lazy var helper: CoachMarkHelper! = {
        let instructionsTopView = self.coachMarksViewController.instructionsRootView
        return CoachMarkHelper(instructionsRootView: instructionsTopView,
                               flowManager: self.flow)
    }()

    private(set) public lazy var flow: FlowManager = {
        let flowManager = FlowManager(coachMarksViewController: self.coachMarksViewController)
        flowManager.dataSource = self
        flowManager.delegate = self

        self.coachMarksViewController.delegate = flowManager

        return flowManager
    }()

    //MARK: Private properties
    private lazy var coachMarksViewController: CoachMarksViewController = {
        let coachMarkController = CoachMarksViewController()
        coachMarkController.coachMarkDisplayManager = self.buildCoachMarkDisplayManager()
        coachMarkController.skipViewDisplayManager = self.buildSkipViewDisplayManager()

        coachMarkController.overlayView = self.overlay
        coachMarkController.instructionsRootView = InstructionsRootView()

        return coachMarkController
    }()

    //MARK: Lifecycle
    public init() { }
}

//MARK: Forwarded Properties
public extension CoachMarksController {
    var skipView: CoachMarkSkipView? {
        get { return coachMarksViewController.skipView }
        set { coachMarksViewController.skipView = newValue }
    }
}

public extension CoachMarksController {
    //MARK: Public methods
    /// Start displaying the coach marks.
    ///
    /// - Parameter parentViewController: View Controller to which attach self.
    public func startOn(parentViewController: UIViewController) {
        guard let dataSource = self.dataSource else {
            print("startOn: Snap! You didn't setup any datasource, the" +
                  "coach mark manager won't do anything.")
            return
        }

        // If coach marks are currently being displayed, calling `start()` doesn't do anything.
        if flow.started { return }

        let numberOfCoachMarks = dataSource.numberOfCoachMarksForCoachMarksController(self)
        if numberOfCoachMarks <= 0 {
            print("startOn: the dataSource returned an invalid value for " +
                  "numberOfCoachMarksForCoachMarksController(_:)")
            return
        }

        coachMarksViewController.attachToViewController(parentViewController)
        flow.startFlow(withNumberOfCoachMarks: numberOfCoachMarks)
    }

    public func stop(immediately immediately: Bool = false) {
        if immediately {
            flow.stopFlow(immediately: true, userDidSkip: false, shouldCallDelegate: false)
        } else {
            flow.stopFlow()
        }
    }
}

extension CoachMarksController: OverlayViewDelegate {
    func didReceivedSingleTap() {
        flow.showNextCoachMark()
    }
}

private extension CoachMarksController {
    private func buildCoachMarkDisplayManager() -> CoachMarkDisplayManager {
        let coachMarkDisplayManager =
            CoachMarkDisplayManager(coachMarkLayoutHelper: CoachMarkLayoutHelper())
        coachMarkDisplayManager.dataSource = self

        return coachMarkDisplayManager
    }

    private func buildSkipViewDisplayManager() -> SkipViewDisplayManager {
        let skipViewDisplayManager = SkipViewDisplayManager()
        skipViewDisplayManager.dataSource = self

        return skipViewDisplayManager
    }
}
