// CoachMarksViewController.swift
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

// MARK: - Main Class
/// Handles a set of coach marks, and display them successively.
class CoachMarksViewController: UIViewController {

    // MARK: - Internal properties
    /// Control or control wrapper used to skip the flow.
    var skipView: CoachMarkSkipView? {
        willSet {
            if newValue == nil {
                self.skipView?.asView?.removeFromSuperview()
                self.skipView?.skipControl?.removeTarget(self,
                                                         action: #selector(skipCoachMarksTour(_:)),
                                                         for: .touchUpInside)
            }
        }

        didSet {
            guard let skipView = skipView else { return }
            guard skipView is UIView else {
                fatalError("skipView must conform to CoachMarkBodyView but also be a UIView.")
            }

            addSkipView()
        }
    }

    ///
    var currentCoachMarkView: CoachMarkView?

    ///
    var overlayView: OverlayView!

    ///
    var instructionsRootView: InstructionsRootView!

    ///
    var coachMarkDisplayManager: CoachMarkDisplayManager!

    ///
    var skipViewDisplayManager: SkipViewDisplayManager!

    ///
    weak var delegate: CoachMarksViewControllerDelegate?

    // MARK: - Private properties
    fileprivate var onGoingSizeChange = false
    fileprivate let mainViewsLayoutHelper = MainViewsLayoutHelper()

    // MARK: - Lifecycle
    convenience init(coachMarkDisplayManager: CoachMarkDisplayManager,
                     skipViewDisplayManager: SkipViewDisplayManager) {
        self.init()

        self.coachMarkDisplayManager = coachMarkDisplayManager
        self.skipViewDisplayManager = skipViewDisplayManager
    }

    override func loadView() {
        view = DummyView(frame: UIScreen.main.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    // Called after the view was loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        unregisterFromStatusBarFrameChanges()
    }

    // MARK: - Private Methods
    fileprivate func addOverlayView() {
        instructionsRootView.addSubview(overlayView)
        let constraints = mainViewsLayoutHelper.fullSizeConstraints(for: overlayView)
        instructionsRootView.addConstraints(constraints)

        overlayView.alpha = 0.0
    }

    fileprivate func addRootView(to window: UIWindow) {
        window.addSubview(instructionsRootView)
        let constraints = mainViewsLayoutHelper.fullSizeConstraints(for: instructionsRootView)
        window.addConstraints(constraints)

        instructionsRootView.backgroundColor = UIColor.clear
    }

    /// Add a the "Skip view" to the main view container.
    fileprivate func addSkipView() {
        guard let skipView = skipView else { return }

        skipView.asView?.alpha = 0.0
        skipView.skipControl?.addTarget(self,
                                        action: #selector(skipCoachMarksTour(_:)),
                                        for: .touchUpInside)

        instructionsRootView.addSubview(skipView.asView!)
    }
}

// MARK: - Coach Mark Display
extension CoachMarksViewController {
    // MARK: - Internal Methods
    func prepareToShowCoachMarks(_ completion: @escaping () -> Void) {
        disableInteraction()
        overlayView.prepareForFade()

        if let skipView = skipView {
            self.skipViewDisplayManager.show(skipView: skipView,
                                             duration: overlayView.fadeAnimationDuration)
        }

        UIView.animate(withDuration: overlayView.fadeAnimationDuration, animations: { () -> Void in
            self.overlayView.alpha = 1.0
        }, completion: { (finished: Bool) -> Void in
            self.enableInteraction()
            completion()
        })
    }

    func hide(coachMark: CoachMark, animated: Bool = true,
              completion: (() -> Void)? = nil) {
        guard let currentCoachMarkView = currentCoachMarkView else {
            completion?()
            return
        }

        disableInteraction()
        let duration: TimeInterval

        if animated {
            duration = coachMark.animationDuration
        } else {
            duration = 0
        }

        self.coachMarkDisplayManager.hide(coachMarkView: currentCoachMarkView,
                                          overlayView: overlayView, animationDuration: duration) {
            self.enableInteraction()
            self.removeTargetFromCurrentCoachView()
            completion?()
        }
    }

    func show(coachMark: inout CoachMark, at index: Int, animated: Bool = true,
              completion: (() -> Void)? = nil) {
        disableInteraction()
        coachMark.computeMetadata(inFrame: instructionsRootView.frame)
        let passthrough = coachMark.allowTouchInsideCutoutPath

        let coachMarkView = coachMarkDisplayManager.createCoachMarkView(from: coachMark,
                                                                        at: index)

        currentCoachMarkView = coachMarkView

        addTargetToCurrentCoachView()

        coachMarkDisplayManager.showNew(coachMarkView: coachMarkView, from: coachMark,
                                        on: overlayView!, animated: animated) {
            self.instructionsRootView.passthrough = passthrough
            self.enableInteraction()
            completion?()
        }
    }

    // MARK: - Private Methods
    private func disableInteraction() {
        instructionsRootView.passthrough = false
        instructionsRootView.isUserInteractionEnabled = true
        overlayView.isUserInteractionEnabled = false
        currentCoachMarkView?.isUserInteractionEnabled = false
        skipView?.asView?.isUserInteractionEnabled = false
    }

    private func enableInteraction() {
        instructionsRootView.isUserInteractionEnabled = true
        overlayView.isUserInteractionEnabled = true
        currentCoachMarkView?.isUserInteractionEnabled = true
        skipView?.asView?.isUserInteractionEnabled = true
    }
}

// MARK: - Change Events
extension CoachMarksViewController {
    // MARK: - Overrides
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        if currentCoachMarkView == nil { return }
        if onGoingSizeChange { return }
        onGoingSizeChange = true

        overlayView.update(cutoutPath: nil)
        delegate?.willTransition()

        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil, completion: {
            (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.onGoingSizeChange = false
            self.delegate?.didTransition()
        })
    }

    // MARK: - Internal Methods
    /// Will remove currently displayed coach mark.
    func prepareForSizeTransition() {
        guard let skipView = skipView else { return }
        skipViewDisplayManager?.hide(skipView: skipView)
    }

    /// Will re-add the current coach mark
    func restoreAfterSizeTransitionDidComplete() {
        guard let skipView = skipView else { return }
        skipViewDisplayManager?.show(skipView: skipView)
    }

    // MARK: - Private methods
    fileprivate func registerForStatusBarFrameChanges() {
        let center = NotificationCenter.default

        center.addObserver(self, selector: #selector(prepareForStatusBarChange),
                           name: .UIApplicationWillChangeStatusBarFrame, object: nil)

        center.addObserver(self, selector: #selector(restoreAfterStatusBarChangeDidComplete),
                           name: .UIApplicationDidChangeStatusBarFrame, object: nil)
    }

    fileprivate func unregisterFromStatusBarFrameChanges() {
        NotificationCenter.default.removeObserver(self)
    }

    /// Same as `prepareForSizeTransition`, but for status bar changes.
    @objc fileprivate func prepareForStatusBarChange() {
        if !onGoingSizeChange { prepareForSizeTransition() }
    }

    /// Same as `restoreAfterSizeTransitionDidComplete`, but for status bar changes.
    @objc fileprivate func restoreAfterStatusBarChangeDidComplete() {
        if !onGoingSizeChange {
            prepareForSizeTransition()
            restoreAfterSizeTransitionDidComplete()
        }
    }
}

// MARK: - Extension: Controller Containment
extension CoachMarksViewController {
    /// Will attach the controller as a child of the given view controller. This will
    /// allow the coach mark controller to respond to size changes, though
    /// `instructionsRootView` will be a subview of `UIWindow`.
    ///
    /// - Parameter parentViewController: the controller of which become a child
    func attachTo(_ parentViewController: UIViewController) {
        guard let window = parentViewController.view?.window else {
            print("attachToViewController: Instructions could not be properly" +
                  "attached to the window, did you call `startOn` inside" +
                  "`viewDidLoad` instead of `ViewDidAppear`?")

            return
        }

        registerForStatusBarFrameChanges()

        parentViewController.addChildViewController(self)
        parentViewController.view.addSubview(self.view)

        addRootView(to: window)
        addOverlayView()

        // If we're in the background we'll manually lay out the view.
        //
        // `instructionsRootView` is not laid out automatically in the
        // background, likely because it's added to the window.
        #if !INSTRUCTIONS_APP_EXTENSIONS
            if UIApplication.shared.applicationState == .background {
                window.layoutIfNeeded()
            }
        #else
            window.layoutIfNeeded()
        #endif

        self.didMove(toParentViewController: parentViewController)

    }

    /// Detach the controller from its parent view controller.
    func detachFromParentViewController() {
        self.instructionsRootView.removeFromSuperview()
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        unregisterFromStatusBarFrameChanges()
    }
}

// MARK: - Private Extension: User Events
private extension CoachMarksViewController {
    /// Add touch up target to the current coach mark view.
    func addTargetToCurrentCoachView() {
        currentCoachMarkView?.nextControl?.addTarget(self,
            action: #selector(didTapCoachMark(_:)), for: .touchUpInside)
    }

    /// Remove touch up target from the current coach mark view.
    func removeTargetFromCurrentCoachView() {
        currentCoachMarkView?.nextControl?.removeTarget(self,
            action: #selector(didTapCoachMark(_:)), for: .touchUpInside)
    }

    /// Will be called when the user perform an action requiring the display of the next coach mark.
    ///
    /// - Parameter sender: the object sending the message
    @objc func didTapCoachMark(_ sender: AnyObject?) {
        delegate?.didTap(coachMarkView: currentCoachMarkView)
    }

    /// Will be called when the user choose to skip the coach mark tour.
    ///
    /// - Parameter sender: the object sending the message
    @objc func skipCoachMarksTour(_ sender: AnyObject?) {
        delegate?.didTap(skipView: skipView)
    }
}
