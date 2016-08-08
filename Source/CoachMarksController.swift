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
    /// An object implementing the data source protocol and supplying
    /// the coach marks to display.
    public weak var dataSource: CoachMarksControllerDataSource?

    /// An object implementing the delegate data source protocol,
    /// which methods will be called at various points.
    public weak var delegate: CoachMarksControllerDelegate?

    public lazy var helper: CoachMarkHelper! = {
        return CoachMarkHelper(instructionsRootView: self.instructionsRootView,
                               flowManager: self.flowManager)
    }()

    //MARK: Private properties
    private lazy var coachMarksViewController: CoachMarksViewController = {
        let coachMarkController = CoachMarksViewController()
        coachMarkController.coachMarkDisplayManager = self.coachMarkDisplayManager
        coachMarkController.skipViewDisplayManager = self.skipViewDisplayManager

        coachMarkController.overlayView = OverlayView()
        coachMarkController.overlayView.delegate = self
        coachMarkController.instructionsRootView = self.instructionsRootView

        return coachMarkController
    }()

    private lazy var coachMarkDisplayManager: CoachMarkDisplayManager = {
        let coachMarkDisplayManager =
            CoachMarkDisplayManager(coachMarkLayoutHelper: CoachMarkLayoutHelper())
        coachMarkDisplayManager.dataSource = self

        return coachMarkDisplayManager
    }()

    private lazy var flowManager: FlowManager = {
        let flowManager = FlowManager(coachMarksViewController: self.coachMarksViewController)
        flowManager.dataSource = self
        flowManager.delegate = self

        self.coachMarksViewController.delegate = flowManager

        return flowManager
    }()

    private lazy var skipViewDisplayManager: SkipViewDisplayManager? = {
        let skipViewDisplayManager = SkipViewDisplayManager()
        skipViewDisplayManager.dataSource = self

        return skipViewDisplayManager
    }()

    private let instructionsRootView = InstructionsRootView()

    public init() { }
}

public extension CoachMarksController {
    var started: Bool {
        return flowManager.started
    }

    var paused: Bool {
        return flowManager.paused
    }

    var skipView: CoachMarkSkipView? {
        get {
            return coachMarksViewController.skipView
        }

        set {
            coachMarksViewController.skipView = newValue
        }
    }

    var overlayFrame: CGRect {
        return coachMarksViewController.instructionsRootView.frame
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
        if flowManager.started { return }

        let numberOfCoachMarks = dataSource.numberOfCoachMarksForCoachMarksController(self)
        if numberOfCoachMarks <= 0 {
            print("startOn: the dataSource returned an invalid value for " +
                  "numberOfCoachMarksForCoachMarksController(_:)")
            return
        }

        coachMarksViewController.attachToViewController(parentViewController)
        flowManager.startFlow(withNumberOfCoachMarks: numberOfCoachMarks)
    }

    public func stop(immediately immediately: Bool = false) {
        if immediately {
            flowManager.stopFlow(immediately: true, userDidSkip: false, shouldCallDelegate: false)
        } else {
            flowManager.stopFlow()
        }
    }

    /// Pause the display.
    /// This method is expected to be used by the delegate to
    /// top the display, perform animation and resume display with `play()`
    public func pause() {
        flowManager.pause()
    }

    /// Resume the display.
    /// If the display wasn't paused earlier, this method won't do anything.
    public func resume() {
        flowManager.resume()
    }

    /// Show the next specified Coach Mark.
    ///
    /// - Parameter numberOfCoachMarksToSkip: the number of coach marks
    ///                                       to skip.
    public func showNext(numberOfCoachMarksToSkip numberToSkip: Int = 0) {
        flowManager.showNext(numberOfCoachMarksToSkip: numberToSkip)
    }
}

//MARK: - OverlayView related
public extension CoachMarksController {
    /// Overlay fade animation duration
    var overlayFadeAnimationDuration: NSTimeInterval {
        get {
            return coachMarksViewController.overlayFadeAnimationDuration
        }

        set {
            coachMarksViewController.overlayFadeAnimationDuration = newValue
        }
    }

    /// Background color of the overlay.
    var overlayBackgroundColor: UIColor {
        get {
            return coachMarksViewController.overlayView.overlayColor
        }

        set {
            coachMarksViewController.overlayView.overlayColor = newValue
        }
    }

    /// Blur effect style for the overlay view. Keeping this property
    /// `nil` will disable the effect. This property
    /// is mutually exclusive with `overlayBackgroundColor`.
    var overlayBlurEffectStyle: UIBlurEffectStyle? {
        get {
            return coachMarksViewController.overlayView.blurEffectStyle
        }

        set {
            coachMarksViewController.overlayView.blurEffectStyle = newValue
        }
    }

    /// `true` to let the overlay catch tap event and forward them to the
    /// CoachMarkController, `false` otherwise.
    ///
    /// After receiving a tap event, the controller will show the next coach mark.
    ///
    /// You can disable the tap on a case-by-case basis, see CoachMark.disableOverlayTap
    var allowOverlayTap: Bool {
        get {
            return coachMarksViewController.overlayView.allowOverlayTap
        }

        set {
            coachMarksViewController.overlayView.allowOverlayTap = newValue
        }
    }
}

extension CoachMarksController: OverlayViewDelegate {
    func didReceivedSingleTap() {
        flowManager.showNextCoachMark()
    }
}
