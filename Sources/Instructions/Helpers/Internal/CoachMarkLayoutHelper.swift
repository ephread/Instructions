// CoachMarkLayoutHelper.swift
//
// Copyright (c) 2016, 2018 Frédéric Maquin <fred@ephread.com>
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
    var layoutDirection: UIUserInterfaceLayoutDirection = .leftToRight

    // TODO: Improve the layout system. Make it smarter.
    func constraints(
        for coachMarkView: CoachMarkView,
        coachMark: CoachMark,
        parentView: UIView,
        layoutDirection: UIUserInterfaceLayoutDirection? = nil,
        passNumber: Int = 0
    ) -> [NSLayoutConstraint] {
        if coachMarkView.superview != parentView {
            print("coachMarkView was not added to parentView, returned constraints will be empty")
            return []
        }

        self.layoutDirection = UIView.userInterfaceLayoutDirection(
            for: parentView.semanticContentAttribute
        )

        let computedProperties: CoachMarkComputedProperties
        let offset: CGFloat

        if passNumber == 0 {
            computedProperties = CoachMarkComputedProperties(layoutDirection: self.layoutDirection,
                                                             horizontalAligment: .centered)
            offset = 0
        } else {
            computedProperties = computeProperties(for: coachMark, inParentView: parentView)
            offset = arrowOffset(for: coachMark, withProperties: computedProperties,
                                 inParentView: parentView)
        }

        switch computedProperties.horizontalAligment {
        case .leading:
            coachMarkView.changeArrowPosition(to: .leading, offset: offset)
            return leadingConstraints(for: coachMarkView, withCoachMark: coachMark,
                                      inParentView: parentView)
        case .centered:
            coachMarkView.changeArrowPosition(to: .center, offset: offset)
            return middleConstraints(for: coachMarkView, withCoachMark: coachMark,
                                     inParentView: parentView)
        case .trailing:
            coachMarkView.changeArrowPosition(to: .trailing, offset: offset)
            return trailingConstraints(for: coachMarkView, withCoachMark: coachMark,
                                       inParentView: parentView)
        }
    }

    private func leadingConstraints(for coachMarkView: CoachMarkView,
                                    withCoachMark coachMark: CoachMark,
                                    inParentView parentView: UIView
    ) -> [NSLayoutConstraint] {
        let visualFormat = "H:|-(==\(coachMark.horizontalMargin))-" +
                           "[currentCoachMarkView(<=\(coachMark.maxWidth))]-" +
                           "(>=\(coachMark.horizontalMargin))-|"

        return NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                              options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                              metrics: nil,
                                              views: ["currentCoachMarkView": coachMarkView])
    }

    private func middleConstraints(for coachMarkView: CoachMarkView,
                                   withCoachMark coachMark: CoachMark,
                                   inParentView parentView: UIView
    ) -> [NSLayoutConstraint] {
        let maxWidth = min(coachMark.maxWidth, (parentView.bounds.width - 2 *
                                                coachMark.horizontalMargin))

        let visualFormat = "H:[currentCoachMarkView(<=\(maxWidth)@1000)]"

        var constraints =
            NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                           metrics: nil,
                                           views: ["currentCoachMarkView": coachMarkView])

        var offset: CGFloat = 0

        if let pointOfInterest = coachMark.pointOfInterest {
            if layoutDirection == .leftToRight {
                offset = parentView.center.x - pointOfInterest.x
            } else {
                offset = pointOfInterest.x - parentView.center.x
            }
        }

        constraints.append(NSLayoutConstraint(
            item: coachMarkView, attribute: .centerX, relatedBy: .equal,
            toItem: parentView, attribute: .centerX,
            multiplier: 1, constant: -offset
        ))

        return constraints
    }

    private func trailingConstraints(for coachMarkView: CoachMarkView,
                                     withCoachMark coachMark: CoachMark,
                                     inParentView parentView: UIView
    ) -> [NSLayoutConstraint] {
        let visualFormat = "H:|-(>=\(coachMark.horizontalMargin))-" +
                           "[currentCoachMarkView(<=\(coachMark.maxWidth))]-" +
                           "(==\(coachMark.horizontalMargin))-|"

        return NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                              options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                              metrics: nil,
                                              views: ["currentCoachMarkView": coachMarkView])
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

        switch properties.horizontalAligment {
        case .centered:
            arrowOffset = middleArrowOffset(for: coachMark, withProperties: properties,
                                            inParentView: parentView)
        case .leading:
            arrowOffset = leadingArrowOffset(for: coachMark, withProperties: properties,
                                             inParentView: parentView)
        case .trailing:
            arrowOffset = trailingArrowOffset(for: coachMark, withProperties: properties,
                                              inParentView: parentView)
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
            print("The point of interest was found nil. Falling back to offset = 0")
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
    /// in two horizontal areas and depending in which one the coach
    /// mark stand, it will be layed out in a different way.
    ///
    /// - Parameters:
    ///   - coachMark: coachmark data.
    ///   - layoutDirection: the layout direction (LTR or RTL)
    ///   - frame: frame of the parent view
    ///
    /// - Returns: the aligment
    private func computeHorizontalAligment(
        of coachMark: CoachMark,
        forLayoutDirection layoutDirection: UIUserInterfaceLayoutDirection,
        inFrame frame: CGRect
    ) -> CoachMarkHorizontalAligment {
        if let pointOfInterest = coachMark.pointOfInterest {
            let segmentIndex = Int(ceil(2 * pointOfInterest.x / frame.size.width))

            switch (segmentIndex, layoutDirection) {
            case (1, .leftToRight): return .leading
            case (2, .leftToRight): return .trailing
            case (1, .rightToLeft): return .trailing
            case (2, .rightToLeft): return .leading
            default: return .centered
            }
        } else {
            print("The point of interest was found nil: falling back to centered.")
            return .centered
        }
    }

    private func computeProperties(for coachMark: CoachMark,
                                   inParentView parentView: UIView)
    -> CoachMarkComputedProperties {
        let horizontalAligment = computeHorizontalAligment(of: coachMark,
                                                           forLayoutDirection: layoutDirection,
                                                           inFrame: parentView.frame)

        return CoachMarkComputedProperties(
            layoutDirection: layoutDirection,
            horizontalAligment: horizontalAligment
        )
    }
}

struct CoachMarkComputedProperties {
    let layoutDirection: UIUserInterfaceLayoutDirection
    let horizontalAligment: CoachMarkHorizontalAligment
}

enum CoachMarkHorizontalAligment {
    case leading, centered, trailing
}
