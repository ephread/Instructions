// FlowManager.swift
//
// Copyright (c) 2016 Frédéric Maquin <fred@ephread.com>
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

public class FlowManager {
    //mark: Internal Properties
    /// `true` if coach marks are curently being displayed, `false` otherwise.
    public var started: Bool {
        return currentIndex > -1
    }

    /// Sometimes, the chain of coach mark display can be paused
    /// to let animations be performed. `true` to pause the execution,
    /// `false` otherwise.
    private(set) open var paused = false

    internal unowned let coachMarksViewController: CoachMarksViewController
    internal weak var dataSource: CoachMarksControllerProxyDataSource?

    /// An object implementing the delegate data source protocol,
    /// which methods will be called at various points.
    internal weak var delegate: CoachMarksControllerProxyDelegate?

    /// Reference to the currently displayed coach mark, supplied by the `datasource`.
    internal var currentCoachMark: CoachMark?

    /// The total number of coach marks, supplied by the `datasource`.
    private var numberOfCoachMarks = 0

    /// Since changing size calls asynchronous completion blocks,
    /// we might end up firing multiple times the methods adding coach
    /// marks to the view. To prevent that from happening we use the guard
    /// property.
    ///
    /// Everything is normally happening on the main thread, atomicity should
    /// not be a problem. Plus, a size change is a very long process compared to
    /// subview addition.
    ///
    /// This property will be checked multiple time during the process of
    /// showing coach marks and can abort the normal flow. This, it's also
    /// used to prevent the normal flow when calling `stop(imediately:)`.
    ///
    /// `true` when the controller is performing a size change, `false` otherwise.
    private var disableFlow = false

    /// This property is much like `disableFlow`, except it's used only to
    /// prevent a coach mark from being shown multiple times (in case the user
    /// is tapping too fast.
    ///
    /// `true` if a new coach mark can be shown, `false` otherwise.
    private var canShowCoachMark = true

    /// The index (in `coachMarks`) of the coach mark being currently displayed.
    private var currentIndex = -1

    init(coachMarksViewController: CoachMarksViewController) {
        self.coachMarksViewController = coachMarksViewController
    }

    internal func startFlow(withNumberOfCoachMarks numberOfCoachMarks: Int) {
        disableFlow = false

        self.numberOfCoachMarks = numberOfCoachMarks

        coachMarksViewController.prepareToShowCoachMarks {
            self.showNextCoachMark()
        }
    }

    func resume() {
        if started && paused {
            paused = false
            createAndShowCoachMark(false)
        }
    }

    func pause() {
        paused = true
    }

    internal func reset() {
        currentIndex = -1
        paused = false
        canShowCoachMark = true
        //disableFlow will be set by startFlow, to enable quick stop.
    }

    /// Stop displaying the coach marks and perform some cleanup.
    ///
    /// - Parameter immediately: `true` to hide immediately with no animation
    ///                          `false` otherwise.
    /// - Parameter userDidSkip: `true` when the user canceled the flow, `false` otherwise.
    /// - Parameter shouldCallDelegate: `true` to notify the delegate that the flow
    ///                                 was stop.
    internal func stopFlow(immediately: Bool = false, userDidSkip skipped: Bool = false,
                           shouldCallDelegate: Bool = true ) {
        reset()

        let animationBlock = { () -> Void in
            self.coachMarksViewController.overlayView.alpha = 0.0
            self.coachMarksViewController.skipView?.asView?.alpha = 0.0
            self.coachMarksViewController.currentCoachMarkView?.alpha = 0.0
        }

        let completionBlock = {(finished: Bool) -> Void in
            self.coachMarksViewController.detachFromParentViewController()
            if shouldCallDelegate { self.delegate?.didFinishShowingAndWasSkipped(skipped) }
        }

        if immediately {
            disableFlow = true
            animationBlock()
            completionBlock(true)
        } else {
            UIView.animate(withDuration: coachMarksViewController.overlayView.fadeAnimationDuration,
                                       animations: animationBlock, completion: completionBlock)
        }
    }

    internal func showNextCoachMark(hidePrevious: Bool = true) {
        if disableFlow || paused || !canShowCoachMark { return }

        canShowCoachMark = false
        currentIndex += 1

        if currentIndex == 0 {
            createAndShowCoachMark()
            return
        }

        if let currentCoachMark = currentCoachMark {
            delegate?.coachMarkWillDisappear(currentCoachMark, at: currentIndex - 1)
        }

        if hidePrevious {
            guard let currentCoachMark = currentCoachMark else { return }

            coachMarksViewController.hide(coachMark: currentCoachMark) {
                self.showOrStop()
            }
        } else {
            showOrStop()
        }
    }

    internal func showOrStop() {
        if self.currentIndex < self.numberOfCoachMarks {
            self.createAndShowCoachMark()
        } else {
            self.stopFlow()
        }
    }

    /// Ask the datasource, create the coach mark and display it. Also
    /// notifies the delegate. When this method is called during a size change,
    /// the delegate is not notified.
    ///
    /// - Parameter shouldCallDelegate: `true` to call delegate methods, `false` otherwise.
    internal func createAndShowCoachMark(_ shouldCallDelegate: Bool = true) {
        if disableFlow { return }

        // Retrieves the current coach mark structure from the datasource.
        // It can't be nil, that's why we'll force unwrap it everywhere.
        currentCoachMark = self.dataSource!.coachMark(at: currentIndex)

        // The coach mark will soon show, we notify the delegate, so it
        // can perform some things and, if required, update the coach mark structure.
        if shouldCallDelegate {
            self.delegate?.coachMarkWillShow(&currentCoachMark!, at: currentIndex)
        }

        // The delegate might have paused the flow, he check whether or not it's
        // the case.
        if !self.paused {
            if coachMarksViewController.instructionsRootView.bounds.isEmpty {
                print("The overlay view added to the window has empty bounds, " +
                      "Instructions will stop.")
                self.stopFlow()
                return
            }

            coachMarksViewController.show(coachMark: &currentCoachMark!, at: currentIndex) {
                self.canShowCoachMark = true
            }
        }
    }

    /// Show the next specified Coach Mark.
    ///
    /// - Parameter numberOfCoachMarksToSkip: the number of coach marks
    ///                                       to skip.
    open func showNext(numberOfCoachMarksToSkip numberToSkip: Int = 0) {
        if !self.started || !canShowCoachMark { return }

        if numberToSkip < 0 {
            print("showNext: The specified number of coach marks to skip" +
                  "was negative, nothing to do.")
            return
        }

        currentIndex += numberToSkip

        showNextCoachMark(hidePrevious: true)
    }
}

extension FlowManager: CoachMarksViewControllerDelegate {
    func didTap(coachMarkView: CoachMarkView?) {
        showNextCoachMark()
    }

    func didTap(skipView: CoachMarkSkipView?) {
        stopFlow()
    }

    func willTransition() {
        coachMarksViewController.prepareForSizeTransition()
        coachMarksViewController.hide(coachMark: currentCoachMark!, animated: false)
    }

    func didTransition() {
        coachMarksViewController.restoreAfterSizeTransitionDidComplete()
        createAndShowCoachMark()
    }
}
