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

//mark: Main Class
/// Handles a set of coach marks, and display them successively.
public class CoachMarksController {
    //mark: Public properties
    /// Implement the data source protocol and supply
    /// the coach marks to display.
    public weak var dataSource: CoachMarksControllerDataSource?

    /// Implement the delegate protocol, which methods will
    /// be called at various points.
    public weak var delegate: CoachMarksControllerDelegate?

    /// Hide the UI.
    fileprivate(set) public lazy var overlay: OverlayView = {
        let overlayView = OverlayView()
        overlayView.delegate = self

        return overlayView
    }()

    /// Provide cutout path related helpers.
    fileprivate(set) public lazy var helper: CoachMarkHelper! = {
        let instructionsTopView = self.coachMarksViewController.instructionsRootView
        return CoachMarkHelper(instructionsRootView: instructionsTopView!,
                               flowManager: self.flow)
    }()

    /// Handles the flow of coachmarks.
    fileprivate(set) public lazy var flow: FlowManager = {
        let flowManager = FlowManager(coachMarksViewController: self.coachMarksViewController)
        flowManager.dataSource = self
        flowManager.delegate = self

        self.coachMarksViewController.delegate = flowManager

        return flowManager
    }()

    //mark: Private properties
    /// Handle the UI part
    fileprivate lazy var coachMarksViewController: CoachMarksViewController = {
        let coachMarkController = CoachMarksViewController()
        coachMarkController.coachMarkDisplayManager = self.buildCoachMarkDisplayManager()
        coachMarkController.skipViewDisplayManager = self.buildSkipViewDisplayManager()

        coachMarkController.overlayView = self.overlay
        coachMarkController.instructionsRootView = InstructionsRootView()

        return coachMarkController
    }()

    //mark: Lifecycle
    public init() { }
}

//mark: - Forwarded Properties
public extension CoachMarksController {
    /// Control or control wrapper used to skip the flow.
    var skipView: CoachMarkSkipView? {
        get { return coachMarksViewController.skipView }
        set { coachMarksViewController.skipView = newValue }
    }
}

//mark: - Flow management
public extension CoachMarksController {
    /// Start displaying the coach marks.
    ///
    /// - Parameter parentViewController: View Controller to which attach self.
    public func startOn(_ parentViewController: UIViewController) {
        guard let dataSource = self.dataSource else {
            print("startOn: snap! you didn't setup any datasource, the" +
                  "coach mark manager won't do anything.")
            return
        }

        // If coach marks are currently being displayed, calling `start()` doesn't do anything.
        if flow.started { return }

        let numberOfCoachMarks = dataSource.numberOfCoachMarks(for: self)
        if numberOfCoachMarks <= 0 {
            print("startOn: the dataSource returned an invalid value for " +
                  "numberOfCoachMarksForCoachMarksController(_:)")
            return
        }

        coachMarksViewController.attachTo(parentViewController)
        flow.startFlow(withNumberOfCoachMarks: numberOfCoachMarks)
    }

    /// Stop the flow of coach marks. Don't forget to call this method in viewDidDisappear or
    /// viewWillDisappear.
    ///
    /// - Parameter immediately: `true` to stop immediately, without animations.
    public func stop(immediately: Bool = false) {
        if immediately {
            flow.stopFlow(immediately: true, userDidSkip: false, shouldCallDelegate: false)
        } else {
            flow.stopFlow()
        }
    }

    /// Pause the display.
    /// This method is expected to be used by the delegate to
    /// stop the display, perform animation and resume display with `resume()`
    func pause() {
        flow.pause()
    }

    /// Resume the display.
    /// If the display wasn't paused earlier, this method won't do anything.
    func resume() {
        flow.resume()
    }
}

//mark: - Protocol Conformance | OverlayViewDelegate
extension CoachMarksController: OverlayViewDelegate {
    func didReceivedSingleTap() {
        flow.showNextCoachMark()
    }
}

//mark: - Private builders
private extension CoachMarksController {
    func buildCoachMarkDisplayManager() -> CoachMarkDisplayManager {
        let coachMarkDisplayManager =
            CoachMarkDisplayManager(coachMarkLayoutHelper: CoachMarkLayoutHelper())
        coachMarkDisplayManager.dataSource = self

        return coachMarkDisplayManager
    }

    func buildSkipViewDisplayManager() -> SkipViewDisplayManager {
        let skipViewDisplayManager = SkipViewDisplayManager()
        skipViewDisplayManager.dataSource = self

        return skipViewDisplayManager
    }
}
