// Copyright (c) 2017-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// This protocol expected to be implemented by the CoachMarkController.
/// A snapshottable object will return a snapshot view of its content.
/// Useful when dealing with multiple windows.
protocol Snapshottable: AnyObject {
    /// Returns: A snapshot of the view hierarchy.
    func snapshot() -> UIView?
}

/// Define a common API for different types of overlay.
/// (Blurring the content behind, simple background color, etc.)
/// Takes care of displaying and animating the overlay / cutout path (doesn't
/// deals with the coach mark view itself).
protocol OverlayStyleManager: AnyObject {
    /// The overlay managed by the styleManager.
    var overlayView: OverlayView? { get set }

    /// Called when the size of usable screen space will change.
    func viewWillTransition()

    /// Called when the size of usable screen space did change.
    func viewDidTransition()

    /// Show/hide the overlay.
    ///
    /// - Parameters:
    ///   - show: `true` to show the overlay, `false` to hide.
    ///   - duration: duration of the animation
    ///   - completion: a block to execute after compleion.
    func showOverlay(_ show: Bool, withDuration duration: TimeInterval,
                     completion: ((Bool) -> Void)?)

    /// Show/hide the cutout.
    ///
    /// - Parameters:
    ///   - show: `true` to show the overlay, `false` to hide.
    ///   - duration: duration of the animation
    ///   - completion: a block to execute after completion.
    func showCutout(_ show: Bool, withDuration duration: TimeInterval,
                    completion: ((Bool) -> Void)?)

    func updateStyle(with traitCollection: UITraitCollection)
}
