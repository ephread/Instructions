// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// TODO: ❗️ Find a good way to refactor this growing controller
// swiftlint:disable file_length
// MARK: - Main Class
/// Handles a set of coach marks, and display them successively.
class CoachMarksViewController: UIViewController {
    // MARK: - Private properties
    private var onGoingSizeChange = false
    private var presentationFashion: PresentationFashion = .window {
        didSet {
            if let skipViewDisplayManager = skipViewDisplayManager {
                skipViewDisplayManager.presentationFashion = presentationFashion
            }
        }
    }

    private weak var viewControllerDisplayedUnder: UIViewController?

    // MARK: - Internal properties
    weak var delegate: CoachMarksViewControllerDelegate?

    var rotationStyle: RotationStyle = .systemDefined
    var statusBarVisibility: StatusBarVisibility = .systemDefined
    var interfaceOrientations: InterfaceOrientations = .systemDefined

    var coachMarkDisplayManager: CoachMarkDisplayManager!
    var skipViewDisplayManager: SkipViewDisplayManager!
    var overlayManager: OverlayManager! {
        didSet {
            coachMarkDisplayManager.overlayManager = overlayManager
        }
    }

    var customStatusBarStyle: UIStatusBarStyle?

    var currentCoachMarkView: CoachMarkView?
    var skipView: (UIView & CoachMarkSkipView)? {
        willSet {
            if newValue == nil {
                self.skipView?.asView?.removeFromSuperview()
                self.skipView?.skipControl?.removeTarget(self,
                                                         action: #selector(skipCoachMarksTour(_:)),
                                                         for: .touchUpInside)
            }
        }

        didSet {
            guard skipView != nil else { return }

            addSkipView()
        }
    }

    lazy var instructionsRootView: InstructionsRootView = {
        let view = InstructionsRootView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear

        return view
    }()

    // MARK: - Overrided properties
    ///
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let statusBarStyle = customStatusBarStyle {
            return statusBarStyle
        } else if overlayManager.backgroundColor == .clear {
            return super.preferredStatusBarStyle
        } else {
            return overlayManager.statusBarStyle
        }
    }

    override var shouldAutorotate: Bool {
        switch rotationStyle {
        case .systemDefined: return super.shouldAutorotate
        case .automatic: return true
        case .manual: return false
        }
    }

    override var prefersStatusBarHidden: Bool {
        switch statusBarVisibility {
        case .systemDefined: return super.prefersStatusBarHidden
        case .hidden: return true
        case .visible: return false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        switch interfaceOrientations {
        case .systemDefined: return super.supportedInterfaceOrientations
        case .userDefined(let orientations): return orientations
        }
    }

    // MARK: - Lifecycle
    convenience init(coachMarkDisplayManager: CoachMarkDisplayManager,
                     skipViewDisplayManager: SkipViewDisplayManager) {
        self.init()

        self.coachMarkDisplayManager = coachMarkDisplayManager
        self.skipViewDisplayManager = skipViewDisplayManager
    }

    deinit {
        deregisterFromSystemEventChanges()
    }

    // Called after the view was loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
    }

    override func loadView() { view = PassthroughView() }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        overlayManager.updateStyle(with: traitCollection)
    }

    // MARK: - Internal Methods
    /// Will attach the controller as a child of the given window.
    ///
    /// - Parameters:
    ///   - window: the window which will hold the controller
    ///   - viewController: the controller displayed under the window
    ///   - windowLevel: the level at whcih display the window.
    func attach(to window: UIWindow, over viewController: UIViewController,
                at windowLevel: UIWindow.Level? = nil) {
        if #available(iOS 13.0, *) {
            if let windowLevel = windowLevel,
               windowLevel.rawValue >= UIWindow.Level.statusBar.rawValue {
                print("""
                      [WARNING] Displaying Instructions over the status bar is \
                      unsupported in iOS 13+.
                      """)
            }
        }

        presentationFashion = .window
        window.windowLevel = windowLevel ?? UIWindow.Level.normal + 1

        viewControllerDisplayedUnder = viewController

        registerForSystemEventChanges()

        view.addSubview(instructionsRootView)
        instructionsRootView.fillSuperview()

        addOverlayView()

        window.rootViewController = self
        window.isHidden = false
    }

    /// Will attach the controller as a child of the given view controller and add
    /// Instructions-related view to the window of the given view controller.
    ///
    /// - Parameter viewController: the controller to which attach Instructions
    func attachToWindow(of viewController: UIViewController) {
        guard let window = viewController.view?.window else {
            print("""
                  [ERROR] Instructions could not be properly attached to the window \
                  did you call `start(in:)` inside `viewDidLoad` instead of `viewDidAppear`?
                  """)

            return
        }

        presentationFashion = .viewControllerWindow

        viewController.addChild(self)
        view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(view)
        view.fillSuperview()

        registerForSystemEventChanges()
        self.didMove(toParent: viewController)

        addRootView(to: window)
        addOverlayView()

        window.layoutIfNeeded()
    }

    /// Will attach the controller as a child of the given view controller.
    ///
    /// - Parameter viewController: the controller to which attach the current view controller
    func attach(to viewController: UIViewController) {
        presentationFashion = .viewController

        viewController.addChild(self)
        view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(view)
        view.fillSuperview()

        registerForSystemEventChanges()
        view.addSubview(instructionsRootView)
        instructionsRootView.fillSuperview()
        addOverlayView()

        self.didMove(toParent: viewController)
    }

    func addRootView(to window: UIWindow) {
        window.addSubview(instructionsRootView)
        instructionsRootView.fillSuperview()
    }

    /// Detach the controller from its parent view controller.
    func detachFromWindow() {
        switch presentationFashion {
        case .window:
            deregisterFromSystemEventChanges()
            let window = view.window
            window?.isHidden = true
            window?.rootViewController = nil
            window?.accessibilityIdentifier = nil
        case .viewControllerWindow, .viewController:
            self.instructionsRootView.removeFromSuperview()
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            deregisterFromSystemEventChanges()
        }
    }

    // MARK: - Private Methods
    private func addOverlayView() {
        instructionsRootView.addSubview(overlayManager.overlayView)
        overlayManager.overlayView.fillSuperview()
    }

    /// Add a the "Skip view" to the main view container.
    private func addSkipView() {
        guard let skipView = skipView else { return }

        skipView.asView?.alpha = 0.0
        skipView.skipControl?.addTarget(self, action: #selector(skipCoachMarksTour(_:)),
                                        for: .touchUpInside)

        instructionsRootView.addSubview(skipView.asView!)
    }
}

// MARK: - Coach Mark Display
extension CoachMarksViewController {
    // MARK: - Internal Methods
    func prepareToShowCoachMarks(_ completion: @escaping () -> Void) {
        disableInteraction()

        overlayManager.showOverlay(true, completion: { _ in
            if let skipView = self.skipView {
                self.skipViewDisplayManager.show(skipView: skipView,
                                                 duration: self.overlayManager.fadeAnimationDuration)
            }

            self.enableInteraction()
            completion()
        })
    }

    func hide(coachMark: CoachMark, at index: Int, animated: Bool = true,
              beforeTransition: Bool = false, completion: (() -> Void)? = nil) {
        guard let currentCoachMarkView = currentCoachMarkView else {
            completion?()
            return
        }

        disableInteraction()

        self.coachMarkDisplayManager.hide(coachMarkView: currentCoachMarkView,
                                          from: coachMark, at: index,
                                          animated: animated, beforeTransition: beforeTransition) {
            self.enableInteraction()
            self.removeTargetFromCurrentCoachView()
            completion?()
        }
    }

    func show(coachMark: inout CoachMark, at index: Int, animated: Bool = true,
              completion: (() -> Void)? = nil) {
        disableInteraction()
        coachMark.computeMetadata(inFrame: instructionsRootView.frame)
        let passthrough = coachMark.isUserInteractionEnabledInsideCutoutPath ||
                          overlayManager.areTouchEventsForwarded
        let coachMarkView = coachMarkDisplayManager.createCoachMarkView(from: coachMark,
                                                                        at: index)

        currentCoachMarkView = coachMarkView
        addTargetToCurrentCoachView()
        coachMarkDisplayManager.showNew(coachMarkView: coachMarkView, from: coachMark,
                                        at: index, animated: animated) {
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
            self.delegate?.didTransition(afterChanging: .size)
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
            delegate?.didTransition(afterChanging: .statusBar)
        }
    }

    func registerForSystemEventChanges() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(prepareForChange),
                           name: UIApplication.willChangeStatusBarFrameNotification, object: nil)
        center.addObserver(self, selector: #selector(restoreAfterChangeDidComplete),
                           name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
    }

    func deregisterFromSystemEventChanges() {
        NotificationCenter.default.removeObserver(self)
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
