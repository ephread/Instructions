// Copyright (c) 2017-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// Overlay a blocking view on top of the screen and handle the cutout path
// around the point of interest.
public class OverlayManager {
    // MARK: - Public properties
    /// The background color of the overlay
    public var backgroundColor: UIColor = InstructionsColor.overlay {
        didSet {
            overlayStyleManager = updateOverlayStyleManager()
        }
    }

    /// Duration to use when hiding/showing the overlay.
    public var fadeAnimationDuration = Constants.overlayFadeAnimationDuration

    /// The blur effect style to apply to the overlay.
    /// Setting this property to anything but `nil` will
    /// enable the effect. `overlayColor` will be ignored if this
    /// property is set.
    public var blurEffectStyle: UIBlurEffect.Style? {
        didSet {
            overlayStyleManager = updateOverlayStyleManager()
        }
    }

    public var cutoutPath: UIBezierPath? {
        get { return overlayView.cutoutPath }
        set { overlayView.cutoutPath = newValue }
    }

    /// `true` to let the overlay catch tap event and forward them to the
    /// CoachMarkController, `false` otherwise.
    /// After receiving a tap event, the controller will show the next coach mark.
    public var isUserInteractionEnabled: Bool {
        get {
            return self.singleTapGestureRecognizer.view != nil
        }

        set {
            if newValue == true {
                self.overlayView.addGestureRecognizer(self.singleTapGestureRecognizer)
            } else {
                self.overlayView.removeGestureRecognizer(self.singleTapGestureRecognizer)
            }
        }
    }

    /// Used to temporarily enable touch forwarding isnide the cutoutPath.
    public var isUserInteractionEnabledInsideCutoutPath: Bool {
        get { return overlayView.allowTouchInsideCutoutPath }
        set { overlayView.allowTouchInsideCutoutPath = newValue }
    }

    public var areTouchEventsForwarded: Bool {
        get { return overlayView.forwardTouchEvents }
        set { overlayView.forwardTouchEvents = newValue }
    }

    // MARK: - Internal Properties
    /// Delegate to which tell that the overlay view received a tap event.
    internal weak var overlayDelegate: OverlayManagerDelegate?

    /// Used to temporarily disable the tap, for a given coachmark.
    internal var enableTap: Bool = true

    internal lazy var overlayView: OverlayView = OverlayView()

    internal var statusBarStyle: UIStatusBarStyle {
        if let blurEffectStyle = blurEffectStyle {
            if blurEffectStyle == .dark {
                return .lightContent
            } else {
                return .default
            }
        } else {
            var alpha: CGFloat = 1.0
            var white: CGFloat = 1.0
            backgroundColor.getWhite(&white, alpha: &alpha)

            return white >= 0.5 ? .default : .lightContent
        }
    }

    internal var isWindowHidden: Bool {
        return overlayView.superview?.isHidden ?? true
    }

    internal var isOverlayInvisible: Bool {
        return overlayView.alpha == 0
    }

    // MARK: - Private Properties
    private lazy var overlayStyleManager: OverlayStyleManager = {
        return self.updateOverlayStyleManager()
    }()

    /// TapGestureRecognizer that will catch tap event performed on the overlay
    private lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(handleSingleTap(_:)))

        return gestureRecognizer
    }()

    /// This method will be called each time the overlay receive
    /// a tap event.
    ///
    /// - Parameter sender: the object which sent the event
    @objc private func handleSingleTap(_ sender: AnyObject?) {
        if enableTap {
            self.overlayDelegate?.didReceivedSingleTap()
        }
    }

    /// Show/hide a cutout path with fade in animation
    ///
    /// - Parameter show: `true` to show the cutout path, `false` to hide.
    /// - Parameter duration: duration of the animation
    func showCutoutPath(_ show: Bool, withDuration duration: TimeInterval) {
        overlayStyleManager.showCutout(show, withDuration: duration, completion: nil)
    }

    func showOverlay(_ show: Bool, completion: ((Bool) -> Void)?) {
        overlayStyleManager.showOverlay(show, withDuration: fadeAnimationDuration,
                                        completion: completion)
    }

    func showWindow(_ show: Bool, completion: ((Bool) -> Void)?) {
        guard let rootView = overlayView.superview else {
            completion?(false)
            return
        }

        if show {
            overlayView.alpha = 1.0
            rootView.isHidden = false
            UIView.animate(withDuration: fadeAnimationDuration, animations: {
                rootView.alpha = 1.0
            }, completion: completion)
        } else {
            overlayView.window?.isHidden = false
            UIView.animate(withDuration: fadeAnimationDuration, animations: {
                rootView.alpha = 0.0
            }, completion: { (success) in
                rootView.isHidden = true
                completion?(success)
            })
        }
    }

    func viewWillTransition() {
        cutoutPath = nil
        overlayStyleManager.viewWillTransition()
    }

    func viewDidTransition() {
        cutoutPath = nil
        overlayStyleManager.viewDidTransition()
    }

    func updateStyle(with traitCollection: UITraitCollection) {
        overlayStyleManager.updateStyle(with: traitCollection)
    }

    private func updateDependencies(of overlayAnimator: BlurringOverlayStyleManager) {
        overlayAnimator.overlayView = self.overlayView
        overlayAnimator.snapshotDelegate = self.overlayDelegate
    }

    private func updateDependencies(of overlayAnimator: TranslucentOverlayStyleManager) {
        overlayAnimator.overlayView = self.overlayView
    }

    private func updateOverlayStyleManager() -> OverlayStyleManager {
        if let style = blurEffectStyle, !UIAccessibility.isReduceTransparencyEnabled {
            let blurringOverlayStyleManager = BlurringOverlayStyleManager(style: style)
            self.updateDependencies(of: blurringOverlayStyleManager)
            return blurringOverlayStyleManager
        } else {
            let translucentOverlayStyleManager = TranslucentOverlayStyleManager(color: backgroundColor)
            self.updateDependencies(of: translucentOverlayStyleManager)
            return translucentOverlayStyleManager
        }
    }

    // MARK: Renamed Public Properties
    @available(*, unavailable, renamed: "backgroundColor")
    public var color: UIColor = InstructionsColor.overlay

    @available(*, unavailable, renamed: "isUserInteractionEnabled")
    public var allowTap: Bool = true

    @available(*, unavailable, renamed: "isUserInteractionEnabledInsideCutoutPath")
    public var allowTouchInsideCutoutPath: Bool = false

    @available(*, unavailable, renamed: "areTouchEventsForwarded")
    public var forwardTouchEvents: Bool = false
}

// swiftlint:disable class_delegate_protocol
/// This protocol expected to be implemented by CoachMarkManager, so
/// it can be notified when a tap occured on the overlay.
internal protocol OverlayManagerDelegate: Snapshottable {
    /// Called when the overlay received a tap event.
    func didReceivedSingleTap()
}
