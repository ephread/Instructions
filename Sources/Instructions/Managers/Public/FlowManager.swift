// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

public class FlowManager {
    // MARK: - Internal Properties
    /// `true` if coach marks are currently being displayed, `false` otherwise.
    public var isStarted: Bool { return currentIndex > -1 }

    /// Sometimes, the chain of coach mark display can be paused
    /// to let animations be performed. `true` to pause the execution,
    /// `false` otherwise.
    private(set) open var isPaused = false

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
    /// used to prevent the normal flow when calling `stop(immediately:)`.
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
    internal var currentIndex = -1

    init(coachMarksViewController: CoachMarksViewController) {
        self.coachMarksViewController = coachMarksViewController
    }

    // MARK: Internal methods
    internal func startFlow(withNumberOfCoachMarks numberOfCoachMarks: Int) {
        disableFlow = false

        self.numberOfCoachMarks = numberOfCoachMarks

        coachMarksViewController.prepareToShowCoachMarks {
            self.showNextCoachMark()
        }
    }

    internal func reset() {
        currentIndex = -1
        isPaused = false
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
                           shouldCallDelegate: Bool = true, completion: (() -> Void)? = nil) {
        reset()

        let animationBlock = { () -> Void in
            self.coachMarksViewController.skipView?.asView?.alpha = 0.0
            self.coachMarksViewController.currentCoachMarkView?.alpha = 0.0
        }

        let completionBlock = { [weak self] (finished: Bool) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.coachMarksViewController.detachFromWindow()
            if shouldCallDelegate { strongSelf.delegate?.didEndShowingBySkipping(skipped) }
            completion?()
        }

        if immediately {
            disableFlow = true
            animationBlock()
            completionBlock(true)
            // TODO: SoC
            self.coachMarksViewController.overlayManager.overlayView.alpha = 0
        } else {
            UIView.animate(withDuration: coachMarksViewController.overlayManager
                                                                 .fadeAnimationDuration,
                           animations: animationBlock)

            self.coachMarksViewController.overlayManager.showOverlay(false,
                                                                     completion: completionBlock)
        }
    }

    internal func showNextCoachMark(hidePrevious: Bool = true) {
        if disableFlow || isPaused || !canShowCoachMark { return }

        let previousIndex = currentIndex

        canShowCoachMark = false
        currentIndex += 1

        if currentIndex == 0 {
            createAndShowCoachMark()
            return
        }

        if let currentCoachMark = currentCoachMark, currentIndex > 0 {
            delegate?.willHide(coachMark: currentCoachMark, at: currentIndex - 1)
        }

        if hidePrevious {
            guard let currentCoachMark = currentCoachMark else { return }

            coachMarksViewController.hide(coachMark: currentCoachMark, at: previousIndex) {
                if self.currentIndex > 0 {
                    self.delegate?.didHide(coachMark: self.currentCoachMark!,
                                           at: self.currentIndex - 1)
                }
                self.showOrStop()
            }
        } else {
            showOrStop()
        }
    }

    internal func showPreviousCoachMark(hidePrevious: Bool = true) {
        if disableFlow || isPaused || !canShowCoachMark { return }

        let previousIndex = currentIndex

        canShowCoachMark = false
        currentIndex -= 1

        if currentIndex < 0 {
            stopFlow()
            return
        }

        if let currentCoachMark = currentCoachMark {
            delegate?.willHide(coachMark: currentCoachMark, at: currentIndex + 1)
        }

        if hidePrevious {
            guard let currentCoachMark = currentCoachMark else { return }

            coachMarksViewController.hide(coachMark: currentCoachMark, at: previousIndex) {
                self.delegate?.didHide(coachMark: self.currentCoachMark!, at: self.currentIndex)
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
    internal func createAndShowCoachMark(afterResuming: Bool = false,
                                         changing change: ConfigurationChange = .nothing) {
        if disableFlow { return }
        if currentIndex < 0 { return }

        if !afterResuming {
            guard delegate?.willLoadCoachMark(at: currentIndex) ?? false else {
                canShowCoachMark = true
                showNextCoachMark(hidePrevious: false)
                return
            }

            // Retrieves the current coach mark structure from the datasource.
            // It can't be nil, that's why we'll force unwrap it everywhere.
            currentCoachMark = self.dataSource!.coachMark(at: currentIndex)

            // The coach mark will soon show, we notify the delegate, so it
            // can perform some things and, if required, update the coach mark structure.
            self.delegate?.willShow(coachMark: &currentCoachMark!,
                                    beforeChanging: change, at: currentIndex)
        }

        // The delegate might have paused the flow, we check whether or not it's
        // the case.
        if !self.isPaused {
            if coachMarksViewController.instructionsRootView.bounds.isEmpty {
                print(ErrorMessage.Error.overlayEmptyBounds)
                self.stopFlow()
                return
            }

            coachMarksViewController.show(coachMark: &currentCoachMark!, at: currentIndex) {
                self.canShowCoachMark = true

                self.delegate?.didShow(coachMark: self.currentCoachMark!,
                                       afterChanging: change, at: self.currentIndex)
            }
        }
    }

    // MARK: Public methods
    public func resume() {
        if isStarted && isPaused {
            isPaused = false

            let completion: (Bool) -> Void = { _ in
                self.createAndShowCoachMark(afterResuming: true)
            }

            if coachMarksViewController.overlayManager.isWindowHidden {
                coachMarksViewController.overlayManager.showWindow(true, completion: completion)
            } else if coachMarksViewController.overlayManager.isOverlayInvisible {
                coachMarksViewController.overlayManager.showOverlay(true, completion: completion)
            } else {
                completion(true)
            }
        }
    }

    public func pause(and pauseStyle: PauseStyle = .hideNothing) {
        isPaused = true

        switch pauseStyle {
        case .hideInstructions:
            coachMarksViewController.overlayManager.showWindow(false, completion: nil)
        case .hideOverlay:
            coachMarksViewController.overlayManager.showOverlay(false, completion: nil)
        case .hideNothing: break
        }
    }

    /// Show the next specified Coach Mark.
    ///
    /// - Parameter numberOfCoachMarksToSkip: the number of coach marks
    ///                                       to skip.
    public func showNext(numberOfCoachMarksToSkip numberToSkip: Int = 0) {
        if !self.isStarted || !canShowCoachMark { return }

        if numberToSkip < 0 {
            print(ErrorMessage.Warning.negativeNumberOfCoachMarksToSkip)
            return
        }

        currentIndex += numberToSkip

        showNextCoachMark(hidePrevious: true)
    }

    /// Show the previous specified Coach Mark.
    ///
    /// - Parameter numberOfCoachMarksToSkip: the number of coach marks
    ///                                       to skip.
    public func showPrevious(numberOfCoachMarksToSkip numberToSkip: Int = 0) {
        if !self.isStarted || !canShowCoachMark { return }

        if numberToSkip < 0 {
            print(ErrorMessage.Warning.negativeNumberOfCoachMarksToSkip)
            return
        }

        currentIndex -= numberToSkip

        showPreviousCoachMark(hidePrevious: true)
    }

    // MARK: Renamed Public Properties
    @available(*, unavailable, renamed: "isStarted")
    public var started: Bool { return false }

    @available(*, unavailable, renamed: "isPaused")
    public var paused: Bool { return false }
}

extension FlowManager: CoachMarksViewControllerDelegate {
    func didTap(coachMarkView: CoachMarkView?) {
        delegate?.didTapCoachMark(at: currentIndex)
        showNextCoachMark()
    }

    func didTap(skipView: CoachMarkSkipView?) {
        stopFlow(immediately: false, userDidSkip: true, shouldCallDelegate: true)
    }

    func willTransition() {
        coachMarksViewController.prepareForSizeTransition()
        if let coachMark = currentCoachMark {
            coachMarksViewController.hide(coachMark: coachMark, at: currentIndex,
                                          animated: false, beforeTransition: true)
        }
    }

    func didTransition(afterChanging change: ConfigurationChange) {
        coachMarksViewController.restoreAfterSizeTransitionDidComplete()
        createAndShowCoachMark(changing: change)
    }
}
