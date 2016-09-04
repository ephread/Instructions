// CoachMarkLayoutHelper.swift
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

// swiftlint:disable line_length
class CoachMarkLayoutHelper {
    // TODO: Improve the layout system. Make it smarter.
    func constraintsForCoachMarkView(coachMarkView: CoachMarkView, coachMark: CoachMark,
                                     parentView: UIView) -> [NSLayoutConstraint] {
        let computedProperties = computePropertiesForCoachMark(coachMark, inParentView: parentView)
        let offset = arrowOffsetForCoachMark(coachMark, withProperties: computedProperties,
                                             inParentView: parentView)

        switch computedProperties.segmentIndex {
        case 1:
            coachMarkView.changeArrowPositionTo(.Leading, offset: offset)
            return leadingConstraintsForCoachMark(coachMarkView, withCoachMark: coachMark,
                                                  inParentView: parentView)
        case 2:
            coachMarkView.changeArrowPositionTo(.Center, offset: offset)
            return middleConstraintsForCoachMark(coachMarkView, withCoachMark: coachMark,
                                                 inParentView: parentView)
        case 3:
            coachMarkView.changeArrowPositionTo(.Trailing, offset: offset)
            return trailingConstraintsForCoachMark(coachMarkView, withCoachMark: coachMark,
                                                          inParentView: parentView)
        default: return [NSLayoutConstraint]()
        }
    }

    private func leadingConstraintsForCoachMark(coachMarkView: CoachMarkView,
                                                withCoachMark coachMark: CoachMark,
                                                inParentView parentView: UIView
    ) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat("H:|-(==\(coachMark.horizontalMargin))-[currentCoachMarkView(<=\(coachMark.maxWidth))]-(>=\(coachMark.horizontalMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["currentCoachMarkView": coachMarkView])
    }

    private func middleConstraintsForCoachMark(coachMarkView: CoachMarkView,
                                               withCoachMark coachMark: CoachMark,
                                               inParentView parentView: UIView
    ) -> [NSLayoutConstraint] {
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=\(coachMark.horizontalMargin))-[currentCoachMarkView(<=\(coachMark.maxWidth)@1000)]-(>=\(coachMark.horizontalMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["currentCoachMarkView": coachMarkView])

        constraints.append(NSLayoutConstraint(
            item: coachMarkView, attribute: .CenterX, relatedBy: .Equal,
            toItem: parentView, attribute: .CenterX,
            multiplier: 1, constant: 0
        ))

        return constraints
    }

    private func trailingConstraintsForCoachMark(coachMarkView: CoachMarkView,
                                                 withCoachMark coachMark: CoachMark,
                                                 inParentView parentView: UIView
    ) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=\(coachMark.horizontalMargin))-[currentCoachMarkView(<=\(coachMark.maxWidth))]-(==\(coachMark.horizontalMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["currentCoachMarkView": coachMarkView])
    }

    /// Returns the arrow offset, based on the layout and the
    /// segment in which the coach mark will be.
    ///
    /// - Parameter coachMark: coachmark data.
    /// - Parameter properties: precomputed properties.
    /// - Parameter parentView: view showing the coachmarks.
    private func arrowOffsetForCoachMark(coachMark: CoachMark,
                                         withProperties properties: CoachMarkComputedProperties,
                                         inParentView parentView: UIView) -> CGFloat {
        var arrowOffset: CGFloat

        switch properties.segmentIndex {
        case 1:
            arrowOffset = leadingArrowOffset(for: coachMark, withProperties: properties,
                                             inParentView: parentView)
        case 2:
            arrowOffset = middleArrowOffset(for: coachMark, withProperties: properties,
                                            inParentView: parentView)
        case 3:
            arrowOffset = trailingArrowOffset(for: coachMark, withProperties: properties,
                                              inParentView: parentView)
        default:
            arrowOffset = 0
            break
        }

        return arrowOffset
    }

    func leadingArrowOffset(for coachMark: CoachMark,
                            withProperties properties: CoachMarkComputedProperties,
                            inParentView parentView: UIView) -> CGFloat {
        if properties.layoutDirection == .LeftToRight {
            return coachMark.pointOfInterest!.x - coachMark.horizontalMargin
        } else {
            return parentView.bounds.size.width - coachMark.pointOfInterest!.x -
                coachMark.horizontalMargin
        }
    }

    func middleArrowOffset(for coachMark: CoachMark,
                           withProperties properties: CoachMarkComputedProperties,
                           inParentView parentView: UIView) -> CGFloat {
        if properties.layoutDirection == .LeftToRight {
            return parentView.center.x - coachMark.pointOfInterest!.x
        } else {
            return coachMark.pointOfInterest!.x - parentView.center.x
        }
    }

    func trailingArrowOffset(for coachMark: CoachMark,
                             withProperties properties: CoachMarkComputedProperties,
                             inParentView parentView: UIView) -> CGFloat {
        if properties.layoutDirection == .LeftToRight {
            return parentView.bounds.size.width - coachMark.pointOfInterest!.x -
                   coachMark.horizontalMargin
        } else {
            return coachMark.pointOfInterest!.x - coachMark.horizontalMargin
        }
    }

    /// Compute the segment index (for now the screen is separated
    /// in three horizontal areas and depending in which one the coach
    /// mark stand, it will be layed out in a different way.
    ///
    /// - Parameter coachMark: coachmark data.
    /// - Parameter layoutDirection: the layout direction (LTR or RTL)
    /// - Parameter frame: frame of the parent view
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

struct CoachMarkComputedProperties {
    let layoutDirection: UIUserInterfaceLayoutDirection
    let segmentIndex: Int
}
