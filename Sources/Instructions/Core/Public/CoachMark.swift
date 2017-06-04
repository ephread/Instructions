// CoachMark.swift
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

// codebeat:disable[TOO_MANY_IVARS]
/// This structure handle the parametrization of a given coach mark.
/// It doesn't provide any clue about the way it will look, however.
public struct CoachMark {
    // MARK: - Public properties
    /// Change this value to change the duration of the fade.
    public var animationDuration = Constants.coachMarkFadeAnimationDuration

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

    /// Set this property to `true` to disable a tap on the overlay.
    /// (only if the tap capture was enabled)
    ///
    /// If you need to disable the tap for all the coachmarks, prefer setting
    /// `CoachMarkController.allowOverlayTap`.
    public var disableOverlayTap: Bool = false

    /// Set this property to `true` to allow touch forwarding inside the cutoutPath.
    public var allowTouchInsideCutoutPath: Bool = false

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

        let x = cutoutPath.bounds.origin.x + cutoutPath.bounds.width / 2
        let y = cutoutPath.bounds.origin.y + cutoutPath.bounds.height / 2

        self.pointOfInterest = CGPoint(x: x, y: y)
    }
}

extension CoachMark: Equatable {}

public func == (lhs: CoachMark, rhs: CoachMark) -> Bool {
    return lhs.animationDuration == rhs.animationDuration &&
           lhs.cutoutPath == rhs.cutoutPath &&
           lhs.gapBetweenBodyAndArrow == rhs.gapBetweenBodyAndArrow &&
           lhs.arrowOrientation == rhs.arrowOrientation &&
           lhs.pointOfInterest == rhs.pointOfInterest &&
           lhs.gapBetweenCoachMarkAndCutoutPath == rhs.gapBetweenCoachMarkAndCutoutPath &&
           lhs.maxWidth == rhs.maxWidth &&
           lhs.horizontalMargin == rhs.horizontalMargin &&
           lhs.disableOverlayTap == rhs.disableOverlayTap &&
           lhs.allowTouchInsideCutoutPath == rhs.allowTouchInsideCutoutPath
}
