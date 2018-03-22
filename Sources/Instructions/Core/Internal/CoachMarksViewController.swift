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
    var overlayManager: OverlayManager!

    ///
    var instructionsRootView: InstructionsRootView {
#if INSTRUCTIONS_APP_EXTENSIONS
        return appExtensionsRootView
#else
        //swiftlint:disable force_cast
        return view as! InstructionsRootView
        //swiftlint:enable force_cast
#endif
    }

    ///
    var coachMarkDisplayManager: CoachMarkDisplayManager!

    ///
    var skipViewDisplayManager: SkipViewDisplayManager!

    ///
    weak var delegate: CoachMarksViewControllerDelegate?

    // MARK: - Private properties
    fileprivate var onGoingSizeChange = false

#if INSTRUCTIONS_APP_EXTENSIONS
    fileprivate lazy var appExtensionsRootView: InstructionsRootView = {
        let view = InstructionsRootView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
#endif

    fileprivate var _shouldAutorotate: Bool = true
    fileprivate var _prefersStatusBarHidden: Bool = false
    fileprivate var _supportedInterfaceOrientations: UIInterfaceOrientationMask = [.portrait]

    // MARK: - Lifecycle
    convenience init(coachMarkDisplayManager: CoachMarkDisplayManager,
                     skipViewDisplayManager: SkipViewDisplayManager) {
        self.init()

        self.coachMarkDisplayManager = coachMarkDisplayManager
        self.skipViewDisplayManager = skipViewDisplayManager
    }

    override func loadView() {
#if INSTRUCTIONS_APP_EXTENSIONS
        view = UIView()
#else
        view = InstructionsRootView()
#endif
        view.backgroundColor = UIColor.clear
    }

    // Called after the view was loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        deregisterFromSystemEventChanges()
    }

#if INSTRUCTIONS_APP_EXTENSIONS
    func addRootView(to window: UIWindow) {
        window.addSubview(instructionsRootView)
        instructionsRootView.fillSuperview()
        instructionsRootView.backgroundColor = UIColor.clear
    }
#endif

    func addOverlayView() {
        instructionsRootView.addSubview(overlayManager.overlayView)
        overlayManager.overlayView.fillSuperview()
    }

    // MARK: - Private Methods
    /// Add a the "Skip view" to the main view container.
    fileprivate func addSkipView() {
        guard let skipView = skipView else { return }

        skipView.asView?.alpha = 0.0
        skipView.skipControl?.addTarget(self,
                                        action: #selector(skipCoachMarksTour(_:)),
                                        for: .touchUpInside)

        instructionsRootView.addSubview(skipView.asView!)
    }

    override var shouldAutorotate: Bool {
        return _shouldAutorotate
    }

    override var prefersStatusBarHidden: Bool {
        return _prefersStatusBarHidden
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return _supportedInterfaceOrientations
    }
}

// MARK: - Coach Mark Display
extension CoachMarksViewController {
    // MARK: - Internal Methods
    func prepareToShowCoachMarks(_ completion: @escaping () -> Void) {
        disableInteraction()

        if let skipView = skipView {
            self.skipViewDisplayManager.show(skipView: skipView,
                                             duration: overlayManager.fadeAnimationDuration)
        }

        overlayManager.showOverlay(true, completion: { _ in
            self.enableInteraction()
            completion()
        })
    }

    func hide(coachMark: CoachMark, animated: Bool = true, beforeTransition: Bool = false,
              completion: (() -> Void)? = nil) {
        guard let currentCoachMarkView = currentCoachMarkView else {
            completion?()
            return
        }

        disableInteraction()
        let duration: TimeInterval = animated ? coachMark.animationDuration : 0

        self.coachMarkDisplayManager.hide(coachMarkView: currentCoachMarkView,
                                          overlay: overlayManager,
                                          animationDuration: duration,
                                          beforeTransition: beforeTransition) {
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
                                        on: overlayManager,
                                        animated: animated) {
            self.instructionsRootView.passthrough = passthrough
            self.enableInteraction()
            completion?()
        }
    }

    // MARK: - Private Methods
    private func disableInteraction() {
        instructionsRootView.passthrough = false
        instructionsRootView.isUserInteractionEnabled = true
        overlayManager.overlayView.isUserInteractionEnabled = false
        currentCoachMarkView?.isUserInteractionEnabled = false
        skipView?.asView?.isUserInteractionEnabled = false
    }

    private func enableInteraction() {
        instructionsRootView.isUserInteractionEnabled = true
        overlayManager.overlayView.isUserInteractionEnabled = true
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

        delegate?.willTransition()
        overlayManager.viewWillTransition()

        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.onGoingSizeChange = false
            self.overlayManager.viewDidTransition()
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

    /// Same as `prepareForSizeTransition`, but for status bar changes.
    @objc public func prepareForChange() {
        if !onGoingSizeChange {
            delegate?.willTransition()
            overlayManager.viewWillTransition()
        }
    }

    /// Same as `restoreAfterSizeTransitionDidComplete`, but for status bar changes.
    @objc public func restoreAfterChangeDidComplete() {
        if !onGoingSizeChange {
            overlayManager.viewDidTransition()
            delegate?.didTransition()
        }
    }

    func registerForSystemEventChanges() {
        let center = NotificationCenter.default

        center.addObserver(self, selector: #selector(prepareForChange),
                           name: .UIApplicationWillChangeStatusBarFrame, object: nil)

        center.addObserver(self, selector: #selector(restoreAfterChangeDidComplete),
                           name: .UIApplicationDidChangeStatusBarFrame, object: nil)
    }

    func deregisterFromSystemEventChanges() {
        NotificationCenter.default.removeObserver(self)
    }

    func retrieveConfig(from parentViewController: UIViewController) {
        _shouldAutorotate = parentViewController.shouldAutorotate
        _prefersStatusBarHidden = parentViewController.prefersStatusBarHidden
        _supportedInterfaceOrientations = parentViewController.supportedInterfaceOrientations
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
