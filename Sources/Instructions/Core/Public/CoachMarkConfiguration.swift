// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// This structure handle the parametrization of a given coach mark.
/// It doesn't provide any clue about the way it will look, however.
public struct CoachMarkConfiguration: Equatable {
    public var position: VerticalPosition = .automatic
    public var layout: CoachMarkLayoutConfiguration
    public var anchor: CoachMarkAnchorConfiguration
    public var interaction: CoachMarkInteractionConfiguration

    internal func computedConfiguration(
        inFrame frame: CGRect
    ) -> ComputedCoachMarkConfiguration {
        ComputedCoachMarkConfiguration(
            position: computePosition(inFrame: frame),
            layout: layout.makeComputedLayout(inFrame: frame),
            anchor: anchor.makeComputedAnchors(),
            interaction: interaction
        )
    }

    /// Compute the orientation of the arrow, given the frame in which the coach mark
    /// will be displayed.
    ///
    /// - Parameter frame: the frame in which compute the orientation
    ///                    (likely to match the overlay's frame)
    private func computePosition(inFrame frame: CGRect) -> ComputedVerticalPosition {
        // No cutout path means no arrow. That way, no orientation
        // computation is needed.
        guard let cutoutPath = anchor.cutoutPath else {
            return .over
        }

        guard self.position != .automatic else {
            return .init(position: self.position)
        }

        if cutoutPath.bounds.origin.y > frame.size.height / 2 {
            return .above
        } else {
            return .below
        }
    }
}

/// This structure handle the computed parametrization of a given coach mark.
/// It's intended to be strictly immutable and passed to UI-related methods.
public struct ComputedCoachMarkConfiguration: Equatable {
    public let position: ComputedVerticalPosition
    public let layout: CoachMarkLayoutConfiguration
    public let anchor: CoachMarkAnchorConfiguration
    public let interaction: CoachMarkInteractionConfiguration

    internal init(
        position: ComputedVerticalPosition,
        layout: CoachMarkLayoutConfiguration,
        anchor: CoachMarkAnchorConfiguration,
        interaction: CoachMarkInteractionConfiguration
    ) {
        self.position = position
        self.layout = layout
        self.anchor = anchor
        self.interaction = interaction
    }
}

public struct CoachMarkLayoutConfiguration: Equatable {
    /// The vertical offset for the arrow (in rare cases, the arrow might need to overlap with
    /// the coach mark body).
    public var marginBetweenContentAndPointer: CGFloat = 2.0

    /// Offset between the coach mark and the cutout path.
    public var marginBetweenCoachMarkAndCutoutPath: CGFloat = 2.0

    /// Maximum width for a coach mark.
    public var maxWidth: CGFloat = 350

    /// Trailing and leading margin of the coach mark.
    public var horizontalMargin: CGFloat = 20

    internal func makeComputedLayout(inFrame frame: CGRect) -> CoachMarkLayoutConfiguration {
        return CoachMarkLayoutConfiguration(
            marginBetweenContentAndPointer: marginBetweenContentAndPointer,
            marginBetweenCoachMarkAndCutoutPath: marginBetweenCoachMarkAndCutoutPath,
            maxWidth: ceiledMaxWidth(inFrame: frame),
            horizontalMargin: horizontalMargin
        )
    }

    private func ceiledMaxWidth(inFrame frame: CGRect) -> CGFloat {
        return min(maxWidth, frame.width - 2 * horizontalMargin)
    }
}

public struct CoachMarkAnchorConfiguration: Equatable {
    /// The path to cut in the overlay, so the point of interest will be visible.
    public var cutoutPath: UIBezierPath?

    /// The "point of interest" toward which the arrow will point.
    ///
    /// At the moment, it's only used to shift the arrow horizontally and make it sits above/below
    /// the point of interest.
    public var pointOfInterest: CGPoint?

    internal func makeComputedAnchors() -> CoachMarkAnchorConfiguration {
        CoachMarkAnchorConfiguration(cutoutPath: cutoutPath,
                                     pointOfInterest: computedPointOfInterest())
    }

    /// Compute the orientation of the arrow, given the frame in which the coach mark
    /// will be displayed.
    private func computedPointOfInterest() -> CGPoint {
        // If the value is already set, don't do anything.
        if let pointOfInterest = pointOfInterest { return pointOfInterest }

        // No cutout path means no point of interest.
        // That way, no orientation computation is needed.
        // TODO: Check that .zero is an appropriate value.
        guard let cutoutPath = self.cutoutPath else { return .zero }

        let xVal = cutoutPath.bounds.origin.x + cutoutPath.bounds.width / 2
        let yVal = cutoutPath.bounds.origin.y + cutoutPath.bounds.height / 2

        return CGPoint(x: xVal, y: yVal)
    }
}

public struct CoachMarkInteractionConfiguration: Equatable {
    /// Set this property to `false` to disable a tap on the overlay.
    /// (only if the tap capture was enabled)
    ///
    /// If you need to disable the tap for all the coach marks, prefer setting
    /// `CoachMarkController.isUserInteractionEnabled` to `false`.
    public var isOverlayInteractionEnabled: Bool = true

    /// Set this property to `true` to allow touch forwarding inside the cutoutPath.
    ///
    /// If you need to enable cutout interaction for all the coachmarks,
    /// prefer setting
    /// `CoachMarkController.isUserInteractionEnabledInsideCutoutPath`
    /// to `true`.
    public var isUserInteractionEnabledInsideCutoutPath: Bool = false
}
