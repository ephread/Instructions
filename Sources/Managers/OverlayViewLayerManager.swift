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
    fileprivate var cutoutMaskLayer = CAShapeLayer()

    /// The full mask (together with `cutoutMaskLayer` they will form the cutout shape)
    fileprivate var fullMaskLayer = CAShapeLayer()

    init(layer: CALayer) {
        managedLayer = layer
    }

    func showCutoutPathView(withAnimationDuration duration: TimeInterval) {
        CATransaction.begin()

        fullMaskLayer.opacity = 0.0

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.isRemovedOnCompletion = true

        fullMaskLayer.add(animation, forKey: "opacityAnimationFadeIn")

        CATransaction.commit()
    }

    func hideCutoutPathView(withAnimationDuration duration: TimeInterval) {
        CATransaction.begin()

        self.fullMaskLayer.opacity = 1.0

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.isRemovedOnCompletion = true

        self.fullMaskLayer.add(animation, forKey: "opacityAnimationFadeOut")

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

        configureCutoutMask(usingCutoutPath: cutoutPath)
        configureFullMask()

        let maskLayer = CALayer()
        maskLayer.frame = managedLayer.bounds
        maskLayer.addSublayer(self.cutoutMaskLayer)
        maskLayer.addSublayer(self.fullMaskLayer)

        managedLayer.mask = maskLayer
    }

    func configureCutoutMask(usingCutoutPath cutoutPath: UIBezierPath) {
        cutoutMaskLayer = CAShapeLayer()
        cutoutMaskLayer.name = "cutoutMaskLayer"
        cutoutMaskLayer.fillRule = kCAFillRuleEvenOdd
        cutoutMaskLayer.frame = managedLayer.frame

        let cutoutMaskLayerPath = UIBezierPath()
        cutoutMaskLayerPath.append(UIBezierPath(rect: managedLayer.bounds))
        cutoutMaskLayerPath.append(cutoutPath)

        cutoutMaskLayer.path = cutoutMaskLayerPath.cgPath
    }

    func configureFullMask() {
        fullMaskLayer = CAShapeLayer()
        fullMaskLayer.name = "fullMaskLayer"
        fullMaskLayer.fillRule = kCAFillRuleEvenOdd
        fullMaskLayer.frame = managedLayer.frame
        fullMaskLayer.opacity = 1.0

        let fullMaskLayerPath = UIBezierPath()
        fullMaskLayerPath.append(UIBezierPath(rect: managedLayer.bounds))

        fullMaskLayer.path = fullMaskLayerPath.cgPath
    }
}
