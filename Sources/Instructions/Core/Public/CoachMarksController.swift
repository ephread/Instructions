// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// MARK: - Main Class
/// Handles a set of coach marks, and display them successively.
public class CoachMarksController {
    // MARK: - Public properties
    /// The root window that displays the coach mark when the presentation context. `nil` unless
    /// the presentation context is ``Instructions/PresentationContext/newWindow(over:at:)``.
    public var rootWindow: UIWindow?

    /// Implement the data source protocol and supply
    /// the coach marks to display.
    public weak var dataSource: CoachMarksControllerDataSource?

    /// Implement the delegate protocol, which methods will
    /// be called at various points.
    public weak var delegate: CoachMarksControllerDelegate?

    /// Implement the animation delegate protocol, which methods will
    /// be called at various points.
    public weak var animationDelegate: CoachMarksControllerAnimationDelegate?

    /// Controls the style of the status bar when coach marks are displayed
    public var statusBarStyle: UIStatusBarStyle? {
        get {
            return coachMarksViewController.customStatusBarStyle
        }

        set {
            coachMarksViewController.customStatusBarStyle = newValue
            coachMarksViewController.setNeedsStatusBarAppearanceUpdate()
        }
    }

    public var rotationStyle: RotationStyle {
        get { return coachMarksViewController.rotationStyle }
        set { coachMarksViewController.rotationStyle = newValue }
    }

    public var statusBarVisibility: StatusBarVisibility {
        get { return coachMarksViewController.statusBarVisibility }
        set { coachMarksViewController.statusBarVisibility = newValue }
    }

    public var interfaceOrientations: InterfaceOrientations {
        get { return coachMarksViewController.interfaceOrientations }
        set { coachMarksViewController.interfaceOrientations = newValue }
    }

    /// Hide the UI.
    private(set) public lazy var overlay: OverlayManager = {
        let overlay = OverlayManager()
        overlay.overlayDelegate = self

        return overlay
    }()

    /// Provide cutout path related helpers.
    private(set) public lazy var helper: CoachMarkHelper! = {
        let instructionsTopView = self.coachMarksViewController.instructionsRootView
        return CoachMarkHelper(instructionsRootView: instructionsTopView,
                               flowManager: self.flow)
    }()

    /// Handles the flow of coachmarks.
    private(set) public lazy var flow: FlowManager = {
        let flowManager = FlowManager(coachMarksViewController: self.coachMarksViewController)
        flowManager.dataSource = self
        flowManager.delegate = self

        self.coachMarksViewController.delegate = flowManager

        return flowManager
    }()

    // MARK: - Private properties
    private weak var controllerWindow: UIWindow?

    /// Handle the UI part
    private lazy var coachMarksViewController: CoachMarksViewController = {
        let coachMarkController = CoachMarksViewController(
            coachMarkDisplayManager: self.buildCoachMarkDisplayManager(),
            skipViewDisplayManager: self.buildSkipViewDisplayManager()
        )

        coachMarkController.overlayManager = self.overlay

        return coachMarkController
    }()

    // MARK: - Lifecycle
    public init() { }
}

// MARK: - Forwarded Properties
public extension CoachMarksController {
    /// Control or control wrapper used to skip the flow.
    var skipView: (UIView & CoachMarkSkipView)? {
        get { return coachMarksViewController.skipView }
        set { coachMarksViewController.skipView = newValue }
    }
}

// MARK: - Flow management
public extension CoachMarksController {
    /// Start instructions in the given context.
    ///
    /// - Parameter presentationContext: the context in which show Instructions

    func start(in presentationContext: PresentationContext) {
        guard let dataSource = self.dataSource else {
            print(ErrorMessage.Warning.nilDataSource)
            return
        }

        // If coach marks are currently being displayed, calling `start(in: )` doesn't do anything.
        if flow.isStarted { return }

        let numberOfCoachMarks = dataSource.numberOfCoachMarks(for: self)
        if numberOfCoachMarks < 0 {
            fatalError(ErrorMessage.Fatal.negativeNumberOfCoachMarks)
        } else if numberOfCoachMarks == 0 {
            print(ErrorMessage.Warning.noCoachMarks)
            return
        }

        switch presentationContext {
        case .newWindow(let viewController, let windowLevel):
#if INSTRUCTIONS_APP_EXTENSIONS
            fatalError(ErrorMessage.Fatal.windowContextNotAvailableInAppExtensions)
#else
            controllerWindow = viewController.view.window
            rootWindow = rootWindow ?? buildNewWindow()
            coachMarksViewController.attach(to: rootWindow!, over: viewController,
                                            at: windowLevel)
#endif
        case .currentWindow(let viewController):
            coachMarksViewController.attachToWindow(of: viewController)
        case .viewController(let viewController):
            coachMarksViewController.attach(to: viewController)
        }

        delegate?.coachMarksController(self,
                                       configureOrnamentsOfOverlay: overlay.overlayView.ornaments)


        // This tells the window to lay out the basic ornaments immediately. While this isn't
        // strictly needed, it ensures the window has its bounds set when starting the flow.
        //
        // The window won't be laid out again when coach marks are added, so this shouldn't
        // cause any glitch. If things become choppy, we can dispatch the call to `startFlow`
        // asynchronously in the future.
        rootWindow?.layoutIfNeeded()

        self.flow.startFlow(withNumberOfCoachMarks: numberOfCoachMarks)
    }

    // TODO: Refactor this method into two separate methods.

    /// Stop the flow of coach marks. Don't forget to call this method in `viewDidDisappear` or
    /// `viewWillDisappear`.
    ///
    /// When `immediately` is `true`, `emulatingSkip` is ignored since the delegate
    /// is not be called.
    ///
    /// - Parameter immediately: `true` to stop immediately, without animations.
    /// - Parameter emulatingSkip: `true` to tell the delegate that the user pressed the skip button.
    func stop(immediately: Bool = false, emulatingSkip userDidSkip: Bool = false) {
        if immediately {
            flow.stopFlow(
                immediately: true,
                userDidSkip: userDidSkip,
                shouldCallDelegate: false
            ) { [weak self] in
                self?.rootWindow = nil
            }
        } else {
            flow.stopFlow(
                immediately: false,
                userDidSkip: userDidSkip,
                shouldCallDelegate: true
            ) { [weak self] in
                self?.rootWindow = nil
            }
        }
    }

    func prepareForChange() {
        coachMarksViewController.prepareForChange()
    }

    func restoreAfterChangeDidComplete() {
        coachMarksViewController.restoreAfterChangeDidComplete()
    }
}

// MARK: - Protocol Conformance | OverlayViewDelegate
extension CoachMarksController: Snapshottable {
    func snapshot() -> UIView? {
        if let window = controllerWindow {
            return window.snapshotView(afterScreenUpdates: true)
        } else {
            return coachMarksViewController.view.snapshotView(afterScreenUpdates: true)
        }
    }
}

extension CoachMarksController: OverlayManagerDelegate {
    func didReceivedSingleTap() {
        if delegate?.shouldHandleOverlayTap(in: self, at: flow.currentIndex) ?? true {
            flow.showNextCoachMark()
        }
    }
}

// MARK: - Private builders
private extension CoachMarksController {
    func buildCoachMarkDisplayManager() -> CoachMarkDisplayManager {
        let coachMarkDisplayManager =
            CoachMarkDisplayManager(coachMarkLayoutHelper: CoachMarkLayoutHelper())
        coachMarkDisplayManager.dataSource = self
        coachMarkDisplayManager.animationDelegate = self

        return coachMarkDisplayManager
    }

    func buildSkipViewDisplayManager() -> SkipViewDisplayManager {
        let skipViewDisplayManager = SkipViewDisplayManager()
        skipViewDisplayManager.dataSource = self

        return skipViewDisplayManager
    }

    func buildNewWindow() -> UIWindow {
#if !INSTRUCTIONS_APP_EXTENSIONS
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.activeScene {
                let window = InstructionsWindow(windowScene: windowScene)
                let keyWindow = windowScene.windows.first { $0.isKeyWindow }

                window.frame = keyWindow?.bounds ?? UIScreen.main.bounds

                return window
            }
        } else {
            let bounds = UIApplication.shared.keyWindow?.bounds ?? UIScreen.main.bounds
            return InstructionsWindow(frame: bounds)
        }
#endif
        return InstructionsWindow(frame: UIScreen.main.bounds)
    }
}
