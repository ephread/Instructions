// OpaqueOverlayAnimator.swift
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

class TranslucentOverlayStyleManager: OverlayStyleManager {
    // MARK: Properties
    weak var overlayView: OverlayView?

    // MARK: Private Properties
    private var onGoingTransition = false
    private let color: UIColor

    // MARK: Layer Mask related properties
    private var cutoutMaskLayer = CAShapeLayer()
    private var fullMaskLayer = CAShapeLayer()
    private lazy var overlayLayer: CALayer = {
        return self.createSublayer()
    }()

    // MARK: Initialization
    init(color: UIColor) {
        self.color = color
    }

    // MARK: OverlayStyleManager
    func viewWillTransition() {
        // Basically removes everything except the overlay itself.
        // Background color duty, handled by the sublayer, it transfered to
        // the overlay itself.
        guard let overlay = overlayView else { return }

        onGoingTransition = true
        self.overlayLayer.removeFromSuperlayer()
        overlay.backgroundColor = color
    }

    func viewDidTransition() {
        // Back to business, recreating the sublayer.
        guard let overlay = overlayView else { return }

        onGoingTransition = false

        overlayLayer = createSublayer()
        overlayLayer.frame = overlay.bounds
        overlayLayer.backgroundColor = self.color.cgColor

        overlay.layer.addSublayer(overlayLayer)
        updateCutoutPath()

        overlay.backgroundColor = UIColor.clear
    }

    func showOverlay(_ show: Bool, withDuration duration: TimeInterval,
                     completion: ((Bool) -> Void)?) {
        guard let overlay = overlayView else { return }

        overlay.isHidden = false
        overlay.alpha = show ? 0.0 : 1.0
        overlay.backgroundColor = color

        if !show { self.overlayLayer.removeFromSuperlayer() }

        UIView.animate(withDuration: duration, animations: {
            overlay.alpha = show ? 1.0 : 0.0
        }, completion: { success in
            if show {
                self.overlayLayer.removeFromSuperlayer()
                self.overlayLayer.frame = overlay.bounds
                self.overlayLayer.backgroundColor = self.color.cgColor
                overlay.layer.addSublayer(self.overlayLayer)
                overlay.backgroundColor = UIColor.clear
            } else {
                self.overlayLayer.removeFromSuperlayer()
            }
            completion?(success)
        })
    }

    func showCutout(_ show: Bool, withDuration duration: TimeInterval,
                    completion: ((Bool) -> Void)?) {
        if show { updateCutoutPath() }

        CATransaction.begin()

        fullMaskLayer.opacity = show ? 0.0 : 1.0

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = show ? 1.0 : 0.0
        animation.toValue = show ? 0.0 : 1.0
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.isRemovedOnCompletion = true

        CATransaction.setCompletionBlock {
            completion?(true)
        }

        fullMaskLayer.add(animation, forKey: "opacityAnimationFade")

        CATransaction.commit()
    }

    // MARK: Private methods
    private func updateCutoutPath() {
        cutoutMaskLayer.removeFromSuperlayer()
        fullMaskLayer.removeFromSuperlayer()

        guard let cutoutPath = overlayView?.cutoutPath else {
            overlayLayer.mask = nil
            return
        }

        configureCutoutMask(usingCutoutPath: cutoutPath)
        configureFullMask()

        let maskLayer = CALayer()
        maskLayer.frame = overlayLayer.bounds
        maskLayer.addSublayer(self.cutoutMaskLayer)
        maskLayer.addSublayer(self.fullMaskLayer)

        overlayLayer.mask = maskLayer
    }

    private func configureCutoutMask(usingCutoutPath cutoutPath: UIBezierPath) {
        cutoutMaskLayer = CAShapeLayer()
        cutoutMaskLayer.name = "cutoutMaskLayer"
        cutoutMaskLayer.fillRule = kCAFillRuleEvenOdd
        cutoutMaskLayer.frame = overlayLayer.frame

        let cutoutMaskLayerPath = UIBezierPath()
        cutoutMaskLayerPath.append(UIBezierPath(rect: overlayLayer.bounds))
        cutoutMaskLayerPath.append(cutoutPath)

        cutoutMaskLayer.path = cutoutMaskLayerPath.cgPath
    }

    private func configureFullMask() {
        fullMaskLayer = CAShapeLayer()
        fullMaskLayer.name = "fullMaskLayer"
        fullMaskLayer.fillRule = kCAFillRuleEvenOdd
        fullMaskLayer.frame = overlayLayer.frame
        fullMaskLayer.opacity = 1.0

        let fullMaskLayerPath = UIBezierPath()
        fullMaskLayerPath.append(UIBezierPath(rect: overlayLayer.bounds))

        fullMaskLayer.path = fullMaskLayerPath.cgPath
    }

    private func createSublayer() -> CALayer {
        let layer = CALayer()
        layer.name = OverlayView.sublayerName

        return layer
    }
}
