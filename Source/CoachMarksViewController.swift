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
class CoachMarksViewController: UIViewController {

    var overlayFadeAnimationDuration = Constants.overlayFadeAnimationDuration

    //MARK: Internal properties
    var skipView: CoachMarkSkipView? {
        willSet {
            if newValue == nil {
                self.skipView?.asView?.removeFromSuperview()
                self.skipView?.skipControl?.removeTarget(self, action: #selector(skipCoachMarksTour(_:)), forControlEvents: .TouchUpInside)
            }
        }

        didSet {
            guard let skipView = skipView else {
                return
            }

            guard skipView is UIView else {
                fatalError("skipView must conform to CoachMarkBodyView but also be a UIView.")
            }

            addSkipView()
        }
    }

    var currentCoachMarkView: CoachMarkView?
    var overlayView: OverlayView!
    var instructionsRootView: InstructionsRootView!

    var coachMarkDisplayManager: CoachMarkDisplayManager!
    var skipViewDisplayManager: SkipViewDisplayManager!

    weak var delegate: CoachMarksViewControllerDelegate?

    //MARK: Private properties
    private var onGoingSizeChange = false
    private let mainViewsLayoutHelper = MainViewsLayoutHelper()

    convenience init(coachMarkDisplayManager: CoachMarkDisplayManager,
                     skipViewDisplayManager: SkipViewDisplayManager) {
        self.init()

        self.coachMarkDisplayManager = coachMarkDisplayManager
        self.skipViewDisplayManager = skipViewDisplayManager
    }

    //MARK: View lifecycle
    override func loadView() {
        view = DummyView(frame: UIScreen.mainScreen().bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    // Called after the view was loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForStatusBarFrameChanges()
    }

    deinit {
        unregisterFromStatusBarFrameChanges()
    }

    //MARK: Private Methods
    private func addOverlayView() {
        instructionsRootView.addSubview(overlayView)
        let constraints = mainViewsLayoutHelper.fullSizeConstraintsForView(overlayView)
        instructionsRootView.addConstraints(constraints)

        overlayView.alpha = 0.0
    }

    private func addRootView(to window: UIWindow) {
        window.addSubview(instructionsRootView)
        let constraints = mainViewsLayoutHelper.fullSizeConstraintsForView(instructionsRootView)
        window.addConstraints(constraints)

        instructionsRootView.backgroundColor = UIColor.clearColor()
    }

    /// Add a the "Skip view" to the main view container.
    private func addSkipView() {
        guard let skipView = skipView else { return }

        skipView.asView?.alpha = 0.0
        skipView.skipControl?.addTarget(self, action: #selector(skipCoachMarksTour(_:)), forControlEvents: .TouchUpInside)

        instructionsRootView.addSubview(skipView.asView!)
    }
}

//MARK: - Coach Mark Display
extension CoachMarksViewController {
    func prepareToShowCoachMarks(completion: () -> Void) {
        view.userInteractionEnabled = true
        overlayView.prepareForFade()

        if let skipView = skipView {
            self.skipViewDisplayManager.showSkipView(skipView, duration: overlayFadeAnimationDuration)
        }

        UIView.animateWithDuration(overlayFadeAnimationDuration, animations: {
            () -> Void in
            self.overlayView.alpha = 1.0
        }, completion: { (finished: Bool) -> Void in
                // The view was previously hidden, to prevent it from catching the user input.
                // Now, we want exactly the opposite. We want the overlay view to prevent events
                // from reaching down.
                self.view.userInteractionEnabled = true
                completion()
        })
    }

    func hideCurrentCoachMark(coachMark: CoachMark,
                              withoutAnimation: Bool = false,
                              completion: (() -> Void)? = nil) {
        guard let currentCoachMarkView = currentCoachMarkView else {
            completion?()
            return
        }

        let duration: NSTimeInterval

        if withoutAnimation {
            duration = 0
        } else {
            duration = coachMark.animationDuration
        }

        self.coachMarkDisplayManager.hideCoachMarkView(
            currentCoachMarkView,
            overlayView: overlayView,
            animationDuration: duration,
            completion: {
                self.removeTargetFromCurrentCoachView()
                completion?()
            }
        )
    }

    func showCoachMark(inout coachMark: CoachMark, withIndex index: Int, animated: Bool = true, completion: (() -> Void)? = nil) {
        instructionsRootView.userInteractionEnabled = false

        coachMark.computeMetadataForFrame(instructionsRootView.frame)

        let coachMarkView = coachMarkDisplayManager.createCoachMarkViewFromCoachMark(
            coachMark, withIndex: index
        )

        currentCoachMarkView = coachMarkView

        addTargetToCurrentCoachView()

        coachMarkDisplayManager.showCoachMarkView(
            coachMarkView,
            from: coachMark,
            overlayView: overlayView!,
            noAnimation: !animated,
            completion: {
                self.instructionsRootView.userInteractionEnabled = true
                completion?()
            }
        )
    }
}

//MARK: Change Events
extension CoachMarksViewController {
    //MARK: Override
    override func viewWillTransitionToSize(
        size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator
    ) {
        if onGoingSizeChange { return }
        onGoingSizeChange = true

        overlayView.updateCutoutPath(nil)
        delegate?.willTransition()

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        coordinator.animateAlongsideTransition(nil, completion: {
            (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.onGoingSizeChange = false
            self.delegate?.didTransition()
        })
    }

    //MARK:
    private func registerForStatusBarFrameChanges() {
        let notificationCenter = NSNotificationCenter.defaultCenter()

        notificationCenter.addObserver(self,
                                       selector: #selector(prepareForStatusBarChange),
                                       name: UIApplicationWillChangeStatusBarFrameNotification,
                                       object: nil
        )

        notificationCenter.addObserver(self,
                                       selector: #selector(restoreAfterStatusBarChangeDidComplete),
                                       name: UIApplicationDidChangeStatusBarFrameNotification,
                                       object: nil
        )
    }

    private func unregisterFromStatusBarFrameChanges() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    /// Will remove currently displayed coach mark.
    func prepareForSizeTransition() {
        guard let skipView = skipView else { return }

        skipViewDisplayManager?.hideSkipView(skipView)
    }

    /// Will re-add the current coach mark
    func restoreAfterSizeTransitionDidComplete() {
        guard let skipView = skipView else { return }

        skipViewDisplayManager?.showSkipView(skipView)
    }

    /// Same as `prepareForSizeTransition`, but for status bar changes.
    @objc private func prepareForStatusBarChange() {
        if !onGoingSizeChange {
            prepareForSizeTransition()
        }
    }

    /// Same as `restoreAfterSizeTransitionDidComplete`, but for status bar changes.
    @objc private func restoreAfterStatusBarChangeDidComplete() {
        if !onGoingSizeChange {
            prepareForSizeTransition()
            restoreAfterSizeTransitionDidComplete()
        }
    }
}

//MARK: - Containment
extension CoachMarksViewController {
    /// Will attach the controller as a child of the given view controller. This will
    /// allow the coach mark controller to respond to size changes, though
    /// `instructionsRootView` will be a subview of `UIWindow`.
    ///
    /// - Parameter parentViewController: the controller of which become a child
    func attachToViewController(parentViewController: UIViewController) {
        guard let window = parentViewController.view?.window else {
            print("attachToViewController: Instructions could not be properly" +
                  "attached to the window, did you call `startOn` inside" +
                  "`viewDidLoad` instead of `ViewDidAppear`?")

            return
        }

        parentViewController.addChildViewController(self)
        parentViewController.view.addSubview(self.view)

        addRootView(to: window)
        addOverlayView()

        // If we're in the background we'll manually lay out the view.
        //
        // `instructionsRootView` is not laid out automatically in the
        // background, likely because it's added to the window.
        #if !INSTRUCTIONS_APP_EXTENSIONS
            if UIApplication.sharedApplication().applicationState == .Background {
                window.layoutIfNeeded()
            }
        #else
            window.layoutIfNeeded()
        #endif

        self.didMoveToParentViewController(parentViewController)
    }

    /// Detach the controller from its parent view controller.
    func detachFromViewController() {
        self.instructionsRootView.removeFromSuperview()

        self.willMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}

extension CoachMarksViewController {
    /// Add touch up target to the current coach mark view.
    private func addTargetToCurrentCoachView() {
        currentCoachMarkView?.nextControl?.addTarget(self,
            action: #selector(didTapCoachMark(_:)),
            forControlEvents: .TouchUpInside
        )
    }

    /// Remove touch up target from the current coach mark view.
    private func removeTargetFromCurrentCoachView() {
        currentCoachMarkView?.nextControl?.removeTarget(self,
            action: #selector(didTapCoachMark(_:)),
            forControlEvents: .TouchUpInside
        )
    }

    /// Will be called when the user perform an action requiring the display of the next coach mark.
    ///
    /// - Parameter sender: the object sending the message
    @objc private func didTapCoachMark(sender: AnyObject?) {
        delegate?.didTapCoachMark(currentCoachMarkView)
    }

    /// Will be called when the user choose to skip the coach mark tour.
    ///
    /// - Parameter sender: the object sending the message
    @objc private func skipCoachMarksTour(sender: AnyObject?) {
        delegate?.didTapSkipView(skipView)
    }
}

protocol CoachMarksViewControllerDelegate: class {
    func didTapCoachMark(coachMarkView: CoachMarkView?)
    func didTapSkipView(skipView: CoachMarkSkipView?)
    func willTransition()
    func didTransition()
}
