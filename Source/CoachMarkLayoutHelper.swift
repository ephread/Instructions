// CoachMarkDisplayManager.swift
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

class CoachMarkLayoutHelper {
    struct CoachMarkComputedProperties {
        let layoutDirection: UIUserInterfaceLayoutDirection
        let segmentIndex: Int
    }

    /// Position the coach mark view.
    /// TODO: Improve the layout system. Make it smarter.
    func constraintsForCoachMarkView(
        coachMarkView: CoachMarkView,
        coachMark: CoachMark,
        parentView: UIView
    ) -> [NSLayoutConstraint] {

        let computedProperties = computePropertiesForCoachMark(coachMark,
            inParentView: parentView
        )

        let offset = arrowOffsetForCoachMark(coachMark,
            withProperties: computedProperties,
            inParentView: parentView
        )

        let constraints: [NSLayoutConstraint]

        switch computedProperties.segmentIndex {
        case 1:
            constraints = leadingConstraintsForCoachMarkView(coachMarkView,
                withCoachMark: coachMark,
                inParentView: parentView
            )

            coachMarkView.changeArrowPositionTo(.Leading, offset: offset)
        case 2:

            constraints = middleConstraintsForCoachMarkView(coachMarkView,
                withCoachMark: coachMark,
                inParentView: parentView
            )

            coachMarkView.changeArrowPositionTo(.Center, offset: offset)
        case 3:
            constraints = trailingConstraintsForCoachMarkView(coachMarkView,
                withCoachMark: coachMark,
                inParentView: parentView
            )

            coachMarkView.changeArrowPositionTo(.Trailing, offset: offset)
        default:
            constraints = [NSLayoutConstraint]()
        }

        return constraints
    }

    private func leadingConstraintsForCoachMarkView(coachMarkView: CoachMarkView,
                                                    withCoachMark coachMark: CoachMark,
                                                    inParentView parentView: UIView
    ) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(==\(coachMark.horizontalMargin))-" +
            "[currentCoachMarkView(<=\(coachMark.maxWidth))]" +
            "-(>=\(coachMark.horizontalMargin))-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["currentCoachMarkView": coachMarkView])
    }

    private func middleConstraintsForCoachMarkView(coachMarkView: CoachMarkView,
                                                   withCoachMark coachMark: CoachMark,
                                                   inParentView parentView: UIView
    ) -> [NSLayoutConstraint] {
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(>=\(coachMark.horizontalMargin))-" +
            "[currentCoachMarkView(<=\(coachMark.maxWidth)@1000)]" +
            "-(>=\(coachMark.horizontalMargin))-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["currentCoachMarkView": coachMarkView]
        )

        constraints.append(NSLayoutConstraint(
            item: coachMarkView, attribute: .CenterX, relatedBy: .Equal,
            toItem: parentView, attribute: .CenterX,
            multiplier: 1, constant: 0
        ))

        return constraints
    }

    private func trailingConstraintsForCoachMarkView(coachMarkView: CoachMarkView,
                                                     withCoachMark coachMark: CoachMark,
                                                     inParentView parentView: UIView
    ) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(>=\(coachMark.horizontalMargin))-" +
            "[currentCoachMarkView(<=\(coachMark.maxWidth))]" +
            "-(==\(coachMark.horizontalMargin))-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["currentCoachMarkView": coachMarkView]
        )
    }

    /// Returns the arrow offset, based on the layout and the
    /// segment in which the coach mark will be.
    ///
    /// - Parameter layoutDirection: the layout direction (RTL or LTR)
    /// - Parameter segmentIndex: the segment index (either 1, 2 or 3)
    private func arrowOffsetForCoachMark(coachMark: CoachMark,
                                         withProperties properties: CoachMarkComputedProperties,
                                         inParentView parentView: UIView
    ) -> CGFloat {
        let pointOfInterest = coachMark.pointOfInterest!

        var arrowOffset: CGFloat

        switch properties.segmentIndex {
        case 1:
            if properties.layoutDirection == .LeftToRight {
                arrowOffset = pointOfInterest.x - coachMark.horizontalMargin
            } else {
                arrowOffset = parentView.bounds.size.width - pointOfInterest.x -
                              coachMark.horizontalMargin
            }
        case 2:
            if properties.layoutDirection == .LeftToRight {
                arrowOffset = parentView.center.x - pointOfInterest.x
            } else {
                arrowOffset = pointOfInterest.x - parentView.center.x
            }
        case 3:
            if properties.layoutDirection == .LeftToRight {
                arrowOffset = parentView.bounds.size.width - pointOfInterest.x -
                              coachMark.horizontalMargin
            } else {
                arrowOffset = pointOfInterest.x - coachMark.horizontalMargin
            }

        default:
            arrowOffset = 0
            break
        }

        return arrowOffset
    }

    /// Compute the segment index (for now the screen is separated
    /// in three horizontal areas and depending in which one the coach
    /// mark stand, it will be layed out in a different way.
    ///
    /// - Parameter layoutDirection: the layout direction (RTL or LTR)
    ///
    /// - Returns: the segment index (either 1, 2 or 3)
    private func computeSegmentIndexOfCoachMark(
        coachMark: CoachMark,
        forLayoutDirection layoutDirection: UIUserInterfaceLayoutDirection,
        inFrame frame: CGRect
    ) -> Int {
        let pointOfInterest = coachMark.pointOfInterest!
        var segmentIndex = 3 * pointOfInterest.x / frame.size.width

        if layoutDirection == .RightToLeft {
            segmentIndex = 3 - segmentIndex
        }

        return Int(ceil(segmentIndex))
    }

    private func computePropertiesForCoachMark(
        coachMark: CoachMark,
        inParentView parentView: UIView
    ) -> CoachMarkComputedProperties {
        let layoutDirection: UIUserInterfaceLayoutDirection

        if #available(iOS 9, *) {
            layoutDirection =
                UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(
                    parentView.semanticContentAttribute
            )
        } else {
            layoutDirection = .LeftToRight
        }

        let segmentIndex = computeSegmentIndexOfCoachMark(coachMark,
            forLayoutDirection: layoutDirection,
            inFrame: parentView.frame
        )

        return CoachMarkComputedProperties(
            layoutDirection: layoutDirection,
            segmentIndex: segmentIndex
        )
    }
}
