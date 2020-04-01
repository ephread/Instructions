// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// Overlay a blocking view on top of the screen and handle the cutout path
// around the point of interest.
class OverlayView: UIView {
    internal static let sublayerName = "Instructions.OverlaySublayer"

    var cutoutPath: UIBezierPath?

    let holder: UIView
    let ornaments: UIView

    /// Used to temporarily enable touch forwarding isnide the cutoutPath.
    public var allowTouchInsideCutoutPath: Bool = false
    public var forwardTouchEvents: Bool = false

    // MARK: - Initialization
    init() {
        holder = UIView()
        ornaments = UIView()

        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false

        holder.translatesAutoresizingMaskIntoConstraints = false
        ornaments.translatesAutoresizingMaskIntoConstraints = false

        holder.isUserInteractionEnabled = false
        ornaments.isUserInteractionEnabled = false

        addSubview(holder)
        addSubview(ornaments)

        holder.fillSuperview()
        ornaments.fillSuperview()

        accessibilityIdentifier = AccessibilityIdentifiers.overlayView
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    // MARK: - Internal methods
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        if hitView == self {
            guard !forwardTouchEvents else { return nil }

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
}
