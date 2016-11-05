// OverlayView.swift
//
// Copyright (c) 2015, 2016 Frédéric Maquin <fred@ephread.com>
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
public class OverlayView: UIView {
    //mark: - Public properties
    /// The background color of the overlay
    public var color: UIColor = Constants.overlayColor

    /// Duration to use when hiding/showing the overlay.
    public var fadeAnimationDuration = Constants.overlayFadeAnimationDuration

    /// The blur effect style to apply to the overlay.
    /// Setting this property to anything but `nil` will
    /// enable the effect. `overlayColor` will be ignored if this
    /// property is set.
    public var blurEffectStyle: UIBlurEffectStyle? {
        didSet {
            if self.blurEffectStyle != oldValue {
                self.destroyBlurView()
                self.createBlurView()
            }
        }
    }

    /// The original cutout path
    public var cutoutPath: UIBezierPath? {
        set(cutoutPath) {
            update(cutoutPath: cutoutPath)
        }

        get {
            return layerManager.cutoutPath
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
                self.addGestureRecognizer(self.singleTapGestureRecognizer)
            } else {
                self.removeGestureRecognizer(self.singleTapGestureRecognizer)
            }
        }
    }

    /// Used to temporarily enable touch forwarding isnide the cutoutPath.
    public var allowTouchInsideCutoutPath: Bool = false

    //mark: Internal Properties
    /// Used to temporarily disable the tap, for a given coachmark.
    internal var enableTap: Bool = true

    /// Delegate to which tell that the overlay view received a tap event.
    internal weak var delegate: OverlayViewDelegate?

    //mark: - Private properties
    /// The overlay layer, which will handle the background color
    private var overlayLayer = CALayer()

    private var layerManager: OverlayViewLayerManager

    /// The view holding the blur effect
    private var blurEffectView: UIVisualEffectView?

    /// TapGestureRecognizer that will catch tap event performed on the overlay
    private lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(handleSingleTap(_:)))

        return gestureRecognizer
    }()

    //mark: - Initialization
    init() {
        layerManager = OverlayViewLayerManager(layer: overlayLayer)
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    //mark: - Internal methods

    /// Prepare for the fade, by removing the cutout shape.
    func prepareForFade() {
        update(cutoutPath: nil)
    }

    /// Show/hide a cutout path with fade in animation
    ///
    /// - Parameter show: `true` to show the cutout path, `false` to hide.
    /// - Parameter duration: duration of the animation
    func showCutoutPath(_ show: Bool, withAnimationDuration duration: TimeInterval) {
        if show {
            layerManager.showCutoutPathView(withAnimationDuration: duration)
        } else {
            layerManager.hideCutoutPathView(withAnimationDuration: duration)
        }
    }

    /// Update the cutout path. Please note that the update won't perform any
    /// interpolation. The previous cutout path better be hidden or else,
    /// some jaggy effects are to be expected.
    ///
    /// - Parameter cutoutPath: the cutout path
    func update(cutoutPath: UIBezierPath?) {
        if cutoutPath == nil {
            if blurEffectView == nil {
                backgroundColor = color
                overlayLayer.removeFromSuperlayer()
            }
        } else {
            if blurEffectView == nil {
                overlayLayer.removeFromSuperlayer()

                overlayLayer.frame = bounds

                overlayLayer.backgroundColor = color.cgColor

                layer.addSublayer(overlayLayer)
            }

            backgroundColor = UIColor.clear
        }

        layerManager.cutoutPath = cutoutPath
    }

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        if hitView == self {
            guard let cutoutPath = self.cutoutPath else {
                return hitView
            }

            if !self.allowTouchInsideCutoutPath {
                return hitView
            }

            if cutoutPath.contains(point) {
                return nil
            } else {
                return hitView
            }
        }

        return hitView
    }

    override public func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        if layer == self.layer {
            overlayLayer.frame = bounds
        }
    }

    //mark: - Private Methods

    /// Creates the visual effect view holding
    /// the blur effect and adds it to the overlay.
    fileprivate func createBlurView() {
        guard let blurEffectStyle = blurEffectStyle else { return }

        overlayLayer.removeFromSuperlayer()

        let helper = BlurEffectViewHelper()

        blurEffectView = helper.makeBlurEffectView(style: blurEffectStyle)
        helper.add(blurEffectView!, to: self)

        layerManager.managedLayer = blurEffectView!.layer
    }

    /// Removes the view holding the blur effect.
    fileprivate func destroyBlurView() {
        self.blurEffectView?.removeFromSuperview()
        self.blurEffectView = nil

        layerManager.managedLayer = overlayLayer
    }

    /// This method will be called each time the overlay receive
    /// a tap event.
    ///
    /// - Parameter sender: the object which sent the event
    @objc fileprivate func handleSingleTap(_ sender: AnyObject?) {
        if enableTap {
            self.delegate?.didReceivedSingleTap()
        }
    }
}

/// This protocol expected to be implemented by CoachMarkManager, so
/// it can be notified when a tap occured on the overlay.
internal protocol OverlayViewDelegate: class {
    /// Called when the overlay received a tap event.
    func didReceivedSingleTap()
}
