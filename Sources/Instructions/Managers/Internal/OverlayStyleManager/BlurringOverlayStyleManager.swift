// Copyright (c) 2017-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// The idea is simple:
///
/// 1. Snapshot what's behind the overlay twice (let's call those foreground and background).
/// 2. Blur them (Hypothetical improvement -> pre-render the foregorund overlay)
/// 3. Show them on top of one another, the foreground one will hold the mask
///    displaying the cutout.
/// 4. Fade out the background to make it look it the cutout is appearing.
///
/// All that work because UIVisualEffectView doesn't support:
///
/// 1. Opacity animation
/// 2. Mask animation
///
/// TODO: Look for ways to improve everything, I'm fairly confident we can optimize
///       a bunch of things.
class BlurringOverlayStyleManager: OverlayStyleManager {
    // MARK: Properties
    weak var overlayView: OverlayView? {
        didSet {
            sizeTransitionOverlay = UIVisualEffectView(effect: blurEffect)
            sizeTransitionOverlay?.translatesAutoresizingMaskIntoConstraints = false
            sizeTransitionOverlay?.isHidden = true

            overlayView?.holder.addSubview(sizeTransitionOverlay!)
            sizeTransitionOverlay?.fillSuperview()
        }
    }

    /// Will provide shapshot to use for animations involving blurs.
    weak var snapshotDelegate: Snapshottable?

    // MARK: Private Properties
    /// Basic blurring overlay used during size transitions
    private var sizeTransitionOverlay: UIView?
    /// Subview holding the actual bunch.
    private var subOverlay: UIView?
    /// Foreground and background overlay.
    private var cutoutOverlays: (background: OverlaySnapshotView, foreground: OverlaySnapshotView)?

    // `true` is a size change is on going, `false` otherwise.
    private var onGoingTransition = false

    // Used to mask the `foreground`, thus showing the cutout.
    private var mask: MaskView {
        let view = MaskView()
        view.backgroundColor = UIColor.clear

        guard let overlay = self.overlayView,
            let cutoutPath = self.overlayView?.cutoutPath else {
                return view
        }

        let path = UIBezierPath(rect: overlay.bounds)
        path.append(cutoutPath)
        path.usesEvenOddFillRule = true

        view.shapeLayer.path = path.cgPath
        view.shapeLayer.fillRule = CAShapeLayerFillRule.evenOdd

        return view
    }

    private var blurEffect: UIVisualEffect {
        return UIBlurEffect(style: style)
    }

    private let style: UIBlurEffect.Style

    private var isOverlayHidden: Bool = true

    // MARK: Initialization
    init(style: UIBlurEffect.Style) {
        self.style = style
    }

    // MARK: OverlayStyleManager

    func viewWillTransition() {
        onGoingTransition = true
        guard let overlay = overlayView else { return }

        overlay.holder.subviews.forEach { if $0 !== sizeTransitionOverlay { $0.removeFromSuperview() } }

        sizeTransitionOverlay?.isHidden = false
    }

    func viewDidTransition() {
        onGoingTransition = false
    }

    func showOverlay(_ show: Bool, withDuration duration: TimeInterval,
                     completion: ((Bool) -> Void)?) {
        sizeTransitionOverlay?.isHidden = true
        let subviews = overlayView?.holder.subviews

        setUpOverlay()

        guard let overlay = overlayView,
              let subOverlay = subOverlay as? UIVisualEffectView else {
            completion?(false)
            return
        }

        overlay.isHidden = false
        overlay.alpha = 1.0

        subOverlay.frame = overlay.bounds
        subOverlay.effect = (show || isOverlayHidden) ? nil : blurEffect

        subviews?.forEach { if $0 !== sizeTransitionOverlay { $0.removeFromSuperview() } }
        overlay.holder.addSubview(subOverlay)

        UIView.animate(withDuration: duration, animations: {
            subOverlay.effect = show ? self.blurEffect : nil
            overlay.ornaments.alpha = show ? 1.0 : 0.0

            self.isOverlayHidden = !show
        }, completion: { success in
            if !show {
                subOverlay.removeFromSuperview()
                overlay.alpha = 0.0
            }
            completion?(success)
        })
    }

    func showCutout(_ show: Bool, withDuration duration: TimeInterval,
                    completion: ((Bool) -> Void)?) {
        if onGoingTransition { return }
        let subviews = overlayView?.holder.subviews

        setUpOverlay()
        sizeTransitionOverlay?.isHidden = true
        guard let overlay = overlayView,
            let background = cutoutOverlays?.background,
            let foreground = cutoutOverlays?.foreground else {
                completion?(false)
                return
        }

        background.frame = overlay.bounds
        foreground.frame = overlay.bounds

        background.visualEffectView.effect = show ? self.blurEffect : nil
        foreground.visualEffectView.effect = self.blurEffect
        foreground.mask = self.mask

        subviews?.forEach { if $0 !== sizeTransitionOverlay { $0.removeFromSuperview() } }

        overlay.holder.addSubview(background)
        overlay.holder.addSubview(foreground)

        UIView.animate(withDuration: duration, animations: {
            if duration > 0 {
                background.visualEffectView?.effect = show ? nil : self.blurEffect
            }
        }, completion: { success in
            background.removeFromSuperview()
            completion?(success)
        })
    }

    func updateStyle(with traitCollection: UITraitCollection) {
        overlayView?.setNeedsDisplay()
    }

    // MARK: Private methods
    private func setUpOverlay() {
        guard let cutoutOverlays = self.makeSnapshotOverlays() else { return }

        self.cutoutOverlays = cutoutOverlays

        subOverlay = UIVisualEffectView(effect: blurEffect)
        subOverlay?.translatesAutoresizingMaskIntoConstraints = false
    }

    private func makeSnapshotView() -> OverlaySnapshotView? {
        guard let overlayView = overlayView,
              let snapshot = snapshotDelegate?.snapshot() else {
            return nil
        }

        let view = OverlaySnapshotView(frame: overlayView.bounds)
        let backgroundEffectView = UIVisualEffectView(effect: blurEffect)
        backgroundEffectView.frame = overlayView.bounds
        backgroundEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundView = snapshot
        view.visualEffectView = backgroundEffectView

        return view
    }

    private func makeSnapshotOverlays() -> (background: OverlaySnapshotView,
                                            foreground: OverlaySnapshotView)? {
            guard let background = makeSnapshotView(),
                  let foreground = makeSnapshotView() else {
                    return nil
            }

            return (background: background, foreground: foreground)
    }
}
