// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// MARK: - Main Class
/// An object that displays a sequence of coach marks on a screen.
public class TutorialController {
    // MARK: - Public properties
    /// The object that acts as the data source of the table view.
    ///
    /// The data source must adopt the ``TutorialControllerDataSource`` protocol.
    /// The data source is not retained.
    public weak var dataSource: TutorialControllerDataSource?

    /// The object that acts as the delegate of the table view.
    ///
    /// The delegate must adopt the ``TutorialControllerDelegate`` protocol.
    /// The delegate is not retained.
    public weak var delegate: TutorialControllerDelegate?

    /// The style of the status bar when coach marks are displayed.
    ///
    /// If no value is specified, Instructions will infer the best style based on the current configuration.
    ///
    /// The default value is `nil`.
    public var statusBarStyle: UIStatusBarStyle? {
        get { coachMarksViewController.customStatusBarStyle }

        set {
            coachMarksViewController.customStatusBarStyle = newValue
            coachMarksViewController.setNeedsStatusBarAppearanceUpdate()
        }
    }

    /// The visibility of the status bar when coach marks are displayed.
    ///
    /// The default value is ``StatusBarVisibility.systemDefined``.
    public var statusBarVisibility: StatusBarVisibility {
        get { coachMarksViewController.statusBarVisibility }
        set { coachMarksViewController.statusBarVisibility = newValue }
    }

    /// The rotation behavior when coach marks are displayed.
    ///
    /// The default value is ``StatusBarVisibility.systemDefined``.
    public var rotationBehavior: RotationBehavior {
        get { coachMarksViewController.rotationStyle }
        set { coachMarksViewController.rotationStyle = newValue }
    }

    /// No overview available 😅
    public var interfaceOrientations: InterfaceOrientationBehavior {
        get { coachMarksViewController.interfaceOrientations }
        set { coachMarksViewController.interfaceOrientations = newValue }
    }

    private(set) public lazy var overlay: OverlayManager = {
        let overlay = OverlayManager()
        overlay.overlayDelegate = self

        return overlay
    }()

    private(set) public lazy var helper: CoachMarkHelper = {
        return CoachMarkHelper(instructionsRootView: instructionsRootView,
                               flowManager: self.flow)
    }()

    private(set) public lazy var flow: FlowManager = {
        let flowManager = FlowManager(coachMarksViewController: self.coachMarksViewController)
        flowManager.dataSource = self
        flowManager.delegate = self

        self.coachMarksViewController.delegate = flowManager

        return flowManager
    }()

    private(set) public lazy var ornaments: OrnamentManager = {
        OrnamentManager(overlayManager: overlay)
    }()

    private(set) public lazy var skipper: SkippingManager = {
        SkippingManager(instructionsRootView: instructionsRootView)
    }()

    // MARK: - Private properties
    private weak var controllerWindow: UIWindow?
    private var coachMarksWindow: UIWindow?

    /// Handle the UI part
    private lazy var coachMarkDisplayManager: CoachMarkDisplayManager = {
        let manager = CoachMarkDisplayManager(coachMarkLayoutHelper: CoachMarkLayoutHelper())
        manager.dataSource = self
        manager.delegate = self

        return manager
    }()

    private lazy var coachMarksViewController: CoachMarksViewController = {
        let coachMarkController = CoachMarksViewController(
            coachMarkDisplayManager: coachMarkDisplayManager,
            skipViewDisplayManager: skipper,
            instructionsRootView: instructionsRootView
        )

        coachMarkController.overlayManager = self.overlay

        return coachMarkController
    }()

    lazy var instructionsRootView: InstructionsRootView = {
        let view = InstructionsRootView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear

        return view
    }()

    // MARK: - Lifecycle
    public init() { }
}

// MARK: - Flow management
public extension TutorialController {
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

        let numberOfCoachMarks = dataSource.numberOfCoachMarks(in: self)
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
            coachMarksWindow = coachMarksWindow ?? buildNewWindow()
            coachMarksViewController.attach(to: coachMarksWindow!, over: viewController,
                                            at: windowLevel)
            #endif
        case .currentWindow(let viewController):
            coachMarksViewController.attachToWindow(of: viewController)
        case .viewController(let viewController):
            coachMarksViewController.attach(to: viewController)
        }

        ornaments.configure()

        flow.startFlow(withNumberOfCoachMarks: numberOfCoachMarks)
    }

    /// Stop the flow of coach marks. Don't forget to call this method in viewDidDisappear or
    /// viewWillDisappear.
    ///
    /// - Parameter immediately: `true` to stop immediately, without animations.
    func stop(immediately: Bool = false) {
        if immediately {
            flow.stopFlow(immediately: true, userDidSkip: false,
                          shouldCallDelegate: false) { [weak self] in
                self?.coachMarksWindow = nil
            }
        } else {
            flow.stopFlow { [weak self] in
                self?.coachMarksWindow = nil
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
extension TutorialController: Snapshottable {
    func snapshot() -> UIView? {
        if let window = controllerWindow {
            return window.snapshotView(afterScreenUpdates: true)
        } else {
            return coachMarksViewController.view.snapshotView(afterScreenUpdates: true)
        }
    }
}

extension TutorialController: OverlayManagerDelegate {
    func didReceivedSingleTap() {
        if delegate?.tutorialController(self, shouldHandleOverlayTapAt: flow.currentIndex) ?? true {
            flow.showNextCoachMark()
        }
    }
}

// MARK: - Private builders
private extension TutorialController {
    func buildNewWindow() -> UIWindow {
        #if !INSTRUCTIONS_APP_EXTENSIONS
        if let windowScene = UIApplication.shared.activeScene {
            let window = InstructionsWindow(windowScene: windowScene)
            let keyWindow = windowScene.windows.first { $0.isKeyWindow }

            window.frame = keyWindow?.bounds ?? UIScreen.main.bounds

            return window
        }
        #endif
        return InstructionsWindow(frame: UIScreen.main.bounds)
    }
}
