// OverlayManager.swift
//
// Copyright (c) 2017 Frédéric Maquin <fred@ephread.com>
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

// Overlay a blocking view on top of the screen and handle the cutout path
// around the point of interest.
public class OverlayManager {
    // MARK: - Public properties
    /// The background color of the overlay
    public var color: UIColor = Constants.overlayColor {
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
    public var blurEffectStyle: UIBlurEffectStyle? {
        didSet {
            overlayStyleManager = updateOverlayStyleManager()
        }
    }

    /// `true` to let the overlay catch tap event and forward them to the
    /// CoachMarkController, `false` otherwise.
    /// After receiving a tap event, the controller will show the next coach mark.
    public var allowTap: Bool {
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

    public var cutoutPath: UIBezierPath? {
        get {
            return overlayView.cutoutPath
        }

        set {
            overlayView.cutoutPath = newValue
        }
    }

    /// Used to temporarily enable touch forwarding isnide the cutoutPath.
    public var allowTouchInsideCutoutPath: Bool {
        get {
            return overlayView.allowTouchInsideCutoutPath
        }

        set {
            overlayView.allowTouchInsideCutoutPath = newValue
        }
    }

    /// Define the window level for the overlay.
    public var windowLevel = UIWindowLevelNormal + 1

    // MARK: - Internal Properties
    /// Delegate to which tell that the overlay view received a tap event.
    internal weak var delegate: OverlayManagerDelegate?

    /// Used to temporarily disable the tap, for a given coachmark.
    internal var enableTap: Bool = true

    internal lazy var overlayView: OverlayView = OverlayView()

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
    @objc fileprivate func handleSingleTap(_ sender: AnyObject?) {
        if enableTap {
            self.delegate?.didReceivedSingleTap()
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

    func viewWillTransition() {
        cutoutPath = nil
        overlayStyleManager.viewWillTransition()
    }

    func viewDidTransition() {
        cutoutPath = nil
        overlayStyleManager.viewDidTransition()
    }

    private func updateDependencies(of overlayAnimator: BlurringOverlayStyleManager) {
        overlayAnimator.overlayView = self.overlayView
        overlayAnimator.snapshotDelegate = self.delegate
    }

    private func updateDependencies(of overlayAnimator: TranslucentOverlayStyleManager) {
        overlayAnimator.overlayView = self.overlayView
    }

    private func updateOverlayStyleManager() -> OverlayStyleManager {
        if let style = blurEffectStyle {
            let blurringOverlayStyleManager = BlurringOverlayStyleManager(style: style)
            self.updateDependencies(of: blurringOverlayStyleManager)
            return blurringOverlayStyleManager
        } else {
            let translucentOverlayStyleManager = TranslucentOverlayStyleManager(color: color)
            self.updateDependencies(of: translucentOverlayStyleManager)
            return translucentOverlayStyleManager
        }
    }
}

/// This protocol expected to be implemented by CoachMarkManager, so
/// it can be notified when a tap occured on the overlay.
internal protocol OverlayManagerDelegate: Snapshottable {
    /// Called when the overlay received a tap event.
    func didReceivedSingleTap()
}
