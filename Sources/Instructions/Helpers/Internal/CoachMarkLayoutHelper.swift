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
    var layoutDirection: UIUserInterfaceLayoutDirection = .leftToRight

    // TODO: Improve the layout system. Make it smarter.
    func constraints(for coachMarkView: CoachMarkView, coachMark: CoachMark, parentView: UIView,
                     layoutDirection: UIUserInterfaceLayoutDirection? = nil) -> [NSLayoutConstraint] {
        if coachMarkView.superview != parentView {
            print("coachMarkView was not added to parentView, returned constraints will be empty")
            return []
        }

        if layoutDirection == nil {
            if #available(iOS 9, *) {
                self.layoutDirection = UIView.userInterfaceLayoutDirection(
                    for: parentView.semanticContentAttribute)
            }
        } else {
            self.layoutDirection = layoutDirection!
        }

        if coachMark.arrowOrientation == .top || coachMark.arrowOrientation == .bottom {
            let computedProperties = computeProperties(for: coachMark, inParentView: parentView)
            let offset = arrowOffset(for: coachMark, withProperties: computedProperties,
                                     inParentView: parentView)

            switch computedProperties.segmentIndex {
            case 1:
                coachMarkView.changeArrowPosition(to: .leading, offset: offset)
                return leadingConstraints(for: coachMarkView, withCoachMark: coachMark,
                                          inParentView: parentView)
            case 2:
                coachMarkView.changeArrowPosition(to: .center, offset: offset)
                return middleConstraints(for: coachMarkView, withCoachMark: coachMark,
                                         inParentView: parentView)
            case 3:
                coachMarkView.changeArrowPosition(to: .trailing, offset: offset)
                return trailingConstraints(for: coachMarkView, withCoachMark: coachMark,
                                           inParentView: parentView)
            default: return [NSLayoutConstraint]()
            }
        } else {//arrow left or right, the layout constraints diff with top and bottom, and layout around cutoutPath
            if coachMark.arrowOrientation == .left {
                let constant = coachMark.cutoutPath!.bounds.maxX + coachMark.gapBetweenCoachMarkAndCutoutPath
                return NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==\(constant))-[currentCoachMarkView(<=\(coachMark.maxWidth))]-(>=\(coachMark.horizontalMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["currentCoachMarkView": coachMarkView])
            } else {
                let constant = (parentView.frame.size.width - coachMark.cutoutPath!.bounds.minX) + coachMark.gapBetweenCoachMarkAndCutoutPath
                return NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=\(coachMark.horizontalMargin))-[currentCoachMarkView(<=\(coachMark.maxWidth))]-(==\(constant))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["currentCoachMarkView": coachMarkView])
            }
        }

    }

    private func leadingConstraints(for coachMarkView: CoachMarkView,
                                    withCoachMark coachMark: CoachMark,
                                    inParentView parentView: UIView
    ) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==\(coachMark.horizontalMargin))-[currentCoachMarkView(<=\(coachMark.maxWidth))]-(>=\(coachMark.horizontalMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["currentCoachMarkView": coachMarkView])
    }

    private func middleConstraints(for coachMarkView: CoachMarkView,
                                   withCoachMark coachMark: CoachMark,
                                   inParentView parentView: UIView
    ) -> [NSLayoutConstraint] {
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=\(coachMark.horizontalMargin))-[currentCoachMarkView(<=\(coachMark.maxWidth)@1000)]-(>=\(coachMark.horizontalMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["currentCoachMarkView": coachMarkView])

        constraints.append(NSLayoutConstraint(
            item: coachMarkView, attribute: .centerX, relatedBy: .equal,
            toItem: parentView, attribute: .centerX,
            multiplier: 1, constant: 0
        ))

        return constraints
    }

    private func trailingConstraints(for coachMarkView: CoachMarkView,
                                     withCoachMark coachMark: CoachMark,
                                     inParentView parentView: UIView
    ) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=\(coachMark.horizontalMargin))-[currentCoachMarkView(<=\(coachMark.maxWidth))]-(==\(coachMark.horizontalMargin))-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["currentCoachMarkView": coachMarkView])
    }

    /// Returns the arrow offset, based on the layout and the
    /// segment in which the coach mark will be.
    ///
    /// - Parameter coachMark: coachmark data.
    /// - Parameter properties: precomputed properties.
    /// - Parameter parentView: view showing the coachmarks.
    private func arrowOffset(for coachMark: CoachMark,
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
        }

        return arrowOffset
    }

    private func leadingArrowOffset(for coachMark: CoachMark,
                                    withProperties properties: CoachMarkComputedProperties,
                                    inParentView parentView: UIView) -> CGFloat {
        guard let pointOfInterest = coachMark.pointOfInterest else {
            print("The point of interest was found nil. Fallbacking offset will be 0")
            return 0
        }

        if properties.layoutDirection == .leftToRight {
            return pointOfInterest.x - coachMark.horizontalMargin
        } else {
            return parentView.bounds.size.width - pointOfInterest.x -
                coachMark.horizontalMargin
        }
    }

    private func middleArrowOffset(for coachMark: CoachMark,
                                   withProperties properties: CoachMarkComputedProperties,
                                   inParentView parentView: UIView) -> CGFloat {
        guard let pointOfInterest = coachMark.pointOfInterest else {
            print("The point of interest was found nil. Fallbacking offset will be 0")
            return 0
        }

        if properties.layoutDirection == .leftToRight {
            return parentView.center.x - pointOfInterest.x
        } else {
            return pointOfInterest.x - parentView.center.x
        }
    }

    private func trailingArrowOffset(for coachMark: CoachMark,
                                     withProperties properties: CoachMarkComputedProperties,
                                     inParentView parentView: UIView) -> CGFloat {
        guard let pointOfInterest = coachMark.pointOfInterest else {
            print("The point of interest was found nil. Fallbacking offset will be 0")
            return 0
        }

        if properties.layoutDirection == .leftToRight {
            return parentView.bounds.size.width - pointOfInterest.x -
                   coachMark.horizontalMargin
        } else {
            return pointOfInterest.x - coachMark.horizontalMargin
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
    private func computeSegmentIndex(
        of coachMark: CoachMark,
        forLayoutDirection layoutDirection: UIUserInterfaceLayoutDirection,
        inFrame frame: CGRect
    ) -> Int {
        if let pointOfInterest = coachMark.pointOfInterest {
            var segmentIndex = 3 * pointOfInterest.x / frame.size.width

            if layoutDirection == .rightToLeft {
                segmentIndex = 3 - segmentIndex
            }

            return Int(ceil(segmentIndex))
        } else {
            print("The point of interest was found nil. Fallbacking to middle segment.")
            return 1
        }
    }

    private func computeProperties(for coachMark: CoachMark, inParentView parentView: UIView)
    -> CoachMarkComputedProperties {
        let segmentIndex = computeSegmentIndex(of: coachMark, forLayoutDirection: layoutDirection,
                                               inFrame: parentView.frame)

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
