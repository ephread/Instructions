// OverlayView.swift
//
// Copyright (c) 2015 Frédéric Maquin <fred@ephread.com>
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
internal class OverlayView: UIView {
    //MARK: - Internal properties

    /// The background color of the overlay
    var overlayColor: UIColor = Constants.overlayColor

    /// The blur effect style to apply to the overlay.
    /// Setting this property to anything but `nil` will
    /// enable the effect. `overlayColor` will be ignored if this
    /// property is set.
    var blurEffectStyle: UIBlurEffectStyle? {
        didSet {
            if self.blurEffectStyle != oldValue {
                self.destroyBlurView()
                self.createBlurView()
            }
        }
    }

    /// `true` to let the overlay catch tap event and forward them to the
    /// CoachMarkController, `false` otherwise.
    /// After receiving a tap event, the controller will show the next coach mark.
    var allowOverlayTap: Bool {
        get {
            return self.singleTapGestureRecognizer.view != nil
        }

        set {
            if newValue == true {
                self.addGestureRecognizer(self.singleTapGestureRecognizer)
            } else {
                self.removeGestureRecognizer(self.singleTapGestureRecognizer)
            }
        }
    }

    /// Used to temporarily disable the tap, for a given coachmark.
    var disableOverlayTap: Bool = false

    /// Used to temporarily enable touch forwarding isnide the cutoutPath.
    var allowTouchInsideCutoutPath: Bool = false

    /// Delegate to which tell that the overlay view received a tap event.
    weak var delegate: OverlayViewDelegate?

    //MARK: - Private properties

    /// The original cutout path
    private var cutoutPath: UIBezierPath?

    /// The cutout mask
    private var cutoutMaskLayer = CAShapeLayer()

    /// The full mask (together with `cutoutMaskLayer` they will form the cutout shape)
    private var fullMaskLayer = CAShapeLayer()

    /// The overlay layer, which will handle the background color
    private var overlayLayer = CALayer()

    /// The view holding the blur effect
    private var blurEffectView: UIVisualEffectView?

    /// TapGestureRecognizer that will catch tap event performed on the overlay
    private lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(OverlayView.handleSingleTap(_:))
        )

        return gestureRecognizer
    }()

    //MARK: - Initialization
    init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    //MARK: - Internal methods

    /// Prepare for the fade, by removing the cutout shape.
    func prepareForFade() {
        self.updateCutoutPath(nil)
    }

    /// Show a cutout path with fade in animation
    ///
    /// - Parameter duration: duration of the animation
    func showCutoutPathViewWithAnimationDuration(duration: NSTimeInterval) {
        CATransaction.begin()

        self.fullMaskLayer.opacity = 0.0

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.removedOnCompletion = true

        self.fullMaskLayer.addAnimation(animation, forKey: "opacityAnimationFadeIn")

        CATransaction.commit()
    }

    /// Hide a cutout path with fade in animation
    ///
    /// - Parameter duration: duration of the animation
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

    /// Update the cutout path. Please note that the update won't perform any
    /// interpolation. The previous cutout path better be hidden or else,
    /// some jaggy effects are to be expected.
    ///
    /// - Parameter cutoutPath: the cutout path
    func updateCutoutPath(cutoutPath: UIBezierPath?) {

        self.cutoutMaskLayer.removeFromSuperlayer()
        self.fullMaskLayer.removeFromSuperlayer()
        self.overlayLayer.removeFromSuperlayer()

        self.cutoutPath = cutoutPath

        if cutoutPath == nil {
            if self.blurEffectView == nil {
                self.backgroundColor = self.overlayColor
            }

            return
        }

        self.backgroundColor = UIColor.clearColor()

        self.cutoutMaskLayer = CAShapeLayer()
        self.cutoutMaskLayer.name = "cutoutMaskLayer"
        self.cutoutMaskLayer.fillRule = kCAFillRuleEvenOdd
        self.cutoutMaskLayer.frame = self.frame

        self.fullMaskLayer = CAShapeLayer()
        self.fullMaskLayer.name = "fullMaskLayer"
        self.fullMaskLayer.fillRule = kCAFillRuleEvenOdd
        self.fullMaskLayer.frame = self.frame
        self.fullMaskLayer.opacity = 1.0

        let cutoutMaskLayerPath = UIBezierPath()
        cutoutMaskLayerPath.appendPath(UIBezierPath(rect: self.bounds))
        cutoutMaskLayerPath.appendPath(cutoutPath!)

        let fullMaskLayerPath = UIBezierPath()
        fullMaskLayerPath.appendPath(UIBezierPath(rect: self.bounds))

        self.cutoutMaskLayer.path = cutoutMaskLayerPath.CGPath
        self.fullMaskLayer.path = fullMaskLayerPath.CGPath

        let maskLayer = CALayer()
        maskLayer.frame = self.layer.bounds
        maskLayer.addSublayer(self.cutoutMaskLayer)
        maskLayer.addSublayer(self.fullMaskLayer)

        self.overlayLayer = CALayer()
        self.overlayLayer.frame = self.layer.bounds

        if self.blurEffectView == nil {
            self.overlayLayer.backgroundColor = self.overlayColor.CGColor
        }

        self.overlayLayer.mask = maskLayer

        if let blurEffectView = self.blurEffectView {
            blurEffectView.layer.mask = maskLayer
        } else {
            self.layer.addSublayer(self.overlayLayer)
        }
    }

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)

        if hitView == self {
            guard let cutoutPath = self.cutoutPath else {
                return hitView
            }

            if !self.allowTouchInsideCutoutPath {
                return hitView
            }

            if cutoutPath.containsPoint(point) {
                return nil
            } else {
                return hitView
            }
        }

        return hitView
    }

    //MARK: - Private Methods

    /// Creates the visual effect view holding
    /// the blur effect and adds it to the overlay.
    private func createBlurView() {
        if self.blurEffectStyle == nil { return }

        let blurEffect = UIBlurEffect(style: self.blurEffectStyle!)

        self.blurEffectView = UIVisualEffectView(effect:blurEffect)
        self.blurEffectView!.translatesAutoresizingMaskIntoConstraints = false
        self.blurEffectView!.userInteractionEnabled = false
        self.addSubview(self.blurEffectView!)

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[visualEffectView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["visualEffectView": self.blurEffectView!]
        ))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[visualEffectView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["visualEffectView": self.blurEffectView!]
        ))
    }

    /// Removes the view holding the blur effect.
    private func destroyBlurView() {
        self.blurEffectView?.removeFromSuperview()
        self.blurEffectView = nil
    }

    /// This method will be called each time the overlay receive
    /// a tap event.
    ///
    /// - Parameter sender: the object which sent the event
    @objc private func handleSingleTap(sender: AnyObject?) {
        if !disableOverlayTap {
            self.delegate?.didReceivedSingleTap()
        }
    }
}
