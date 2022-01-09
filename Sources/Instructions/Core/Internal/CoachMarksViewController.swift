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
    private var presentationStyle: PresentationStyle = .separateWindow {
        didSet { skipperManager.presentationStyle = presentationStyle }
    }

    private weak var viewControllerDisplayedUnder: UIViewController?

    // MARK: - Internal properties
    weak var delegate: CoachMarksViewControllerDelegate?

    var rotationStyle: RotationBehavior = .systemDefined
    var statusBarVisibility: StatusBarVisibility = .systemDefined
    var interfaceOrientations: InterfaceOrientationBehavior = .systemDefined

    var overlayManager: OverlayManager! {
        didSet { coachMarkDisplayManager.overlayManager = overlayManager }
    }

    var customStatusBarStyle: UIStatusBarStyle?

    var currentCoachMarkView: CoachMarkView?

    var coachMarkDisplayManager: CoachMarkDisplayManager
    var skipperManager: SkippingManager
    var instructionsRootView: InstructionsRootView

    // MARK: - Overridden properties
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
    init(
        coachMarkDisplayManager: CoachMarkDisplayManager,
        skipViewDisplayManager: SkippingManager,
        instructionsRootView: InstructionsRootView
    ) {
        self.coachMarkDisplayManager = coachMarkDisplayManager
        self.skipperManager = skipViewDisplayManager
        self.instructionsRootView = instructionsRootView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    ///   - windowLevel: the level at which display the window.
    func attach(to window: UIWindow, over viewController: UIViewController,
                at windowLevel: UIWindow.Level? = nil) {
        if let windowLevel = windowLevel,
           windowLevel.rawValue >= UIWindow.Level.statusBar.rawValue {
            print(ErrorMessage.Warning.unsupportedWindowLevel)
        }

        presentationStyle = .separateWindow
        window.windowLevel = windowLevel ?? UIWindow.Level.normal + 1

        viewControllerDisplayedUnder = viewController

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
            print(ErrorMessage.Error.couldNotBeAttached)
            return
        }

        presentationStyle = .sameWindow

        viewController.addChild(self)
        view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(view)
        view.fillSuperview()

        self.didMove(toParent: viewController)

        addRootView(to: window)
        addOverlayView()

        window.layoutIfNeeded()
    }

    /// Will attach the controller as a child of the given view controller.
    ///
    /// - Parameter viewController: the controller to which attach the current view controller
    func attach(to viewController: UIViewController) {
        presentationStyle = .viewController

        viewController.addChild(self)
        view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(view)
        view.fillSuperview()

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
        switch presentationStyle {
        case .separateWindow:
            let window = view.window
            window?.isHidden = true
            window?.rootViewController = nil
            window?.accessibilityIdentifier = nil
        case .sameWindow, .viewController:
            self.instructionsRootView.removeFromSuperview()
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }

    // MARK: - Private Methods
    private func addOverlayView() {
        instructionsRootView.addSubview(overlayManager.overlayView)
        overlayManager.overlayView.fillSuperview()
    }
}

// MARK: - Coach Mark Display
extension CoachMarksViewController {
    // MARK: - Internal Methods
    func prepareToShowCoachMarks(_ completion: @escaping () -> Void) {
        disableInteraction()

        overlayManager.showOverlay(true, completion: { _ in
            self.skipperManager.showSkipper(duration: self.overlayManager.fadeAnimationDuration)

            self.enableInteraction()
            completion()
        })
    }

    func hide(coachMark: ComputedCoachMarkConfiguration, at index: Int, animated: Bool = true,
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

    func show(
        coachMark: ComputedCoachMarkConfiguration,
        at index: Int,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        disableInteraction()
        let passthrough = coachMark.interaction.isUserInteractionEnabledInsideCutoutPath ||
                          overlayManager.areTouchEventsForwarded

        guard let coachMarkView = coachMarkDisplayManager.createCoachMarkView(from: coachMark,
                                                                              at: index) else {
            instructionsRootView.passthrough = passthrough
            enableInteraction()
            completion?()
            return
        }

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
        skipperManager.view?.isUserInteractionEnabled = false
    }

    private func enableInteraction() {
        instructionsRootView.isUserInteractionEnabled = true
        overlayManager.overlayView.isUserInteractionEnabled = true
        currentCoachMarkView?.isUserInteractionEnabled = true
        skipperManager.view?.isUserInteractionEnabled = true
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
            self.delegate?.didTransition(afterChanging: .sizeChange)
        })
    }

    // MARK: - Internal Methods
    /// Will remove currently displayed coach mark.
    func prepareForSizeTransition() {
        skipperManager.hideSkipper()
    }

    /// Will re-add the current coach mark
    func restoreAfterSizeTransitionDidComplete() {
        skipperManager.showSkipper()
    }

    /// Same as `prepareForSizeTransition`, but for status bar changes.
    @objc public func prepareForChange() {

    }

    /// Same as `restoreAfterSizeTransitionDidComplete`, but for status bar changes.
    @objc public func restoreAfterChangeDidComplete() {
        if !onGoingSizeChange {
            overlayManager.viewDidTransition()
            delegate?.didTransition(afterChanging: .statusBarChange)
        }
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
        delegate?.didTapSkipper()
    }
}
