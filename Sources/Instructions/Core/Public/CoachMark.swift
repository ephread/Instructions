// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// This structure handle the parametrization of a given coach mark.
/// It doesn't provide any clue about the way it will look, however.
public struct CoachMark {
    // MARK: - Public properties
    /// The path to cut in the overlay, so the point of interest will be visible.
    public var cutoutPath: UIBezierPath?

    /// The vertical offset for the arrow (in rare cases, the arrow might need to overlap with
    /// the coach mark body).
    public var gapBetweenBodyAndArrow: CGFloat = 2.0

    /// The orientation of the arrow, around the body of the coach mark (top or bottom).
    public var arrowOrientation: CoachMarkArrowOrientation?

    /// The "point of interest" toward which the arrow will point.
    ///
    /// At the moment, it's only used to shift the arrow horizontally and make it sits above/below
    /// the point of interest.
    public var pointOfInterest: CGPoint?

    /// Offset between the coach mark and the cutout path.
    public var gapBetweenCoachMarkAndCutoutPath: CGFloat = 2.0

    /// Maximum width for a coach mark.
    public var maxWidth: CGFloat = 350

    /// Trailing and leading margin of the coach mark.
    public var horizontalMargin: CGFloat = 20

    /// Set this property to `true` to display the coach mark over the cutoutPath.
    public var isDisplayedOverCutoutPath: Bool = false

    /// Set this property to `false` to disable a tap on the overlay.
    /// (only if the tap capture was enabled)
    ///
    /// If you need to disable the tap for all the coachmarks, prefer setting
    /// `CoachMarkController.isUserInteractionEnabled` to `false`.
    public var isOverlayInteractionEnabled: Bool = true

    /// Set this property to `true` to allow touch forwarding inside the cutoutPath.
    ///
    /// If you need to enable cutout interaction for all the coachmarks,
    /// prefer setting
    /// `CoachMarkController.isUserInteractionEnabledInsideCutoutPath`
    /// to `true`.
    public var isUserInteractionEnabledInsideCutoutPath: Bool = false

    // MARK: - Initialization
    /// Allocate and initialize a Coach mark with default values.
    public init () {

    }

    // MARK: - Internal Methods
    /// This method perform both `computeOrientationInFrame` and `computePointOfInterestInFrame`.
    ///
    /// - Parameter frame: the frame in which compute the orientation
    ///                    (likely to match the overlay's frame)
    internal mutating func computeMetadata(inFrame frame: CGRect) {
        self.computeOrientation(inFrame: frame)
        self.computePointOfInterest()
    }

    /// Compute the orientation of the arrow, given the frame in which the coach mark
    /// will be displayed.
    ///
    /// - Parameter frame: the frame in which compute the orientation
    ///                    (likely to match the overlay's frame)
    internal mutating func computeOrientation(inFrame frame: CGRect) {
        // No cutout path means no arrow. That way, no orientation
        // computation is needed.
        guard let cutoutPath = self.cutoutPath else {
            self.arrowOrientation = nil
            return
        }

        if self.arrowOrientation != nil {
            return
        }

        if cutoutPath.bounds.origin.y > frame.size.height / 2 {
            self.arrowOrientation = .bottom
        } else {
            self.arrowOrientation = .top
        }
    }

    /// Compute the orientation of the arrow, given the frame in which the coach mark
    /// will be displayed.
    internal mutating func computePointOfInterest() {
        /// If the value is already set, don't do anything.
        if self.pointOfInterest != nil { return }

        /// No cutout path means no point of interest.
        /// That way, no orientation computation is needed.
        guard let cutoutPath = self.cutoutPath else { return }

        let xVal = cutoutPath.bounds.origin.x + cutoutPath.bounds.width / 2
        let yVal = cutoutPath.bounds.origin.y + cutoutPath.bounds.height / 2

        self.pointOfInterest = CGPoint(x: xVal, y: yVal)
    }

    internal func ceiledMaxWidth(in frame: CGRect) -> CGFloat {
        return min(maxWidth, frame.width - 2 * horizontalMargin)
    }

    // MARK: - Renamed Properties
    // swiftlint:disable unused_setter_value
    @available(*, unavailable, renamed: "isDisplayedOverCutoutPath")
    public var displayOverCutoutPath: Bool {
        get { return false }
        set {}
    }

    @available(*, unavailable, renamed: "isOverlayInteractionEnabled")
    public var disableOverlayTap: Bool {
        get { return false }
        set {}
    }

    @available(*, unavailable, renamed: "isUserInteractionEnabledInsideCutoutPath")
    public var allowTouchInsideCutoutPath: Bool {
        get { return false }
        set {}
    }
}

extension CoachMark: Equatable {}
