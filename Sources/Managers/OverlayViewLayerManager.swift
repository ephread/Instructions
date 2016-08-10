// OverlayViewLayerManager.swift
//
// Copyright (c) 2016 Frédéric Maquin <fred@ephread.com>
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

class OverlayViewLayerManager {
    var managedLayer: CALayer
    var cutoutPath: UIBezierPath? {
        didSet {
            updateCutoutPath()
        }
    }

    /// The cutout mask
    private var cutoutMaskLayer = CAShapeLayer()

    /// The full mask (together with `cutoutMaskLayer` they will form the cutout shape)
    private var fullMaskLayer = CAShapeLayer()

    init(layer: CALayer) {
        managedLayer = layer
    }

    func showCutoutPathViewWithAnimationDuration(duration: NSTimeInterval) {
        CATransaction.begin()

        fullMaskLayer.opacity = 0.0

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.removedOnCompletion = true

        fullMaskLayer.addAnimation(animation, forKey: "opacityAnimationFadeIn")

        CATransaction.commit()
    }

    func hideCutoutPathViewWithAnimationDuration(duration: NSTimeInterval) {
        CATransaction.begin()

        self.fullMaskLayer.opacity = 1.0

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.removedOnCompletion = true

        self.fullMaskLayer.addAnimation(animation, forKey: "opacityAnimationFadeOut")

        CATransaction.commit()
    }
}

private extension OverlayViewLayerManager {
    func updateCutoutPath() {
        cutoutMaskLayer.removeFromSuperlayer()
        fullMaskLayer.removeFromSuperlayer()

        guard let cutoutPath = cutoutPath else {
            managedLayer.mask = nil
            return
        }

        configureCutoutMask(cutoutPath)
        configureFullMask()

        let maskLayer = CALayer()
        maskLayer.frame = managedLayer.bounds
        maskLayer.addSublayer(self.cutoutMaskLayer)
        maskLayer.addSublayer(self.fullMaskLayer)

        managedLayer.mask = maskLayer
    }

    func configureCutoutMask(cutoutPath: UIBezierPath) {
        cutoutMaskLayer = CAShapeLayer()
        cutoutMaskLayer.name = "cutoutMaskLayer"
        cutoutMaskLayer.fillRule = kCAFillRuleEvenOdd
        cutoutMaskLayer.frame = managedLayer.frame

        let cutoutMaskLayerPath = UIBezierPath()
        cutoutMaskLayerPath.appendPath(UIBezierPath(rect: managedLayer.bounds))
        cutoutMaskLayerPath.appendPath(cutoutPath)

        cutoutMaskLayer.path = cutoutMaskLayerPath.CGPath
    }

    func configureFullMask() {
        fullMaskLayer = CAShapeLayer()
        fullMaskLayer.name = "fullMaskLayer"
        fullMaskLayer.fillRule = kCAFillRuleEvenOdd
        fullMaskLayer.frame = managedLayer.frame
        fullMaskLayer.opacity = 1.0

        let fullMaskLayerPath = UIBezierPath()
        fullMaskLayerPath.appendPath(UIBezierPath(rect: managedLayer.bounds))

        fullMaskLayer.path = fullMaskLayerPath.CGPath
    }
}
