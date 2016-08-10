// CoachMarkInnerLayoutHelper.swift
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

class CoachMarkInnerLayoutHelper {
    func horizontalArrowConstraints(for coachMarkViews: CoachMarkViews,
                                    withPosition position: ArrowPosition,
                                    horizontalOffset: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: coachMarkViews.arrowView, attribute: .CenterX, relatedBy: .Equal,
            toItem: coachMarkViews.bodyView, attribute: position.layoutAttribute,
            multiplier: 1, constant: adaptedOffset(for: position, offset: horizontalOffset)
        )
    }

    func horizontalConstraints(forBody body: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[bodyView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["bodyView": body]
        )
    }

    func verticalConstraints(for coachMarkViews: CoachMarkViews, in parentView: UIView,
                             withProperties properties: CoachMarkViewProperties)
    -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        let verticalArrowOffset = properties.verticalArrowOffset

        if properties.orientation == .Top {
            constraints = topOrientationConstraints(for: coachMarkViews, in: parentView,
                                                    verticalArrowOffset: verticalArrowOffset)
        } else if properties.orientation == .Bottom {
            constraints = bottomOrientationConstraints(for: coachMarkViews, in: parentView,
                                                       verticalArrowOffset: verticalArrowOffset)
        }

        return constraints
    }

    func topConstraint(forBody body: UIView, in parent: UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: parent, attribute: .Top, relatedBy: .Equal,
            toItem: body, attribute: .Top,
            multiplier: 1, constant: 0
        )
    }

    func bottomConstraint(forBody body: UIView, in parent: UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: parent, attribute: .Bottom, relatedBy: .Equal,
            toItem: body, attribute: .Bottom,
            multiplier: 1, constant: 0
        )
    }

    private func topOrientationConstraints(for coachMarkViews: CoachMarkViews,
                                           in parentView: UIView, verticalArrowOffset: CGFloat)
    -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        constraints.append(NSLayoutConstraint(
            item: parentView, attribute: .Top, relatedBy: .Equal,
            toItem: coachMarkViews.arrowView, attribute: .Top,
            multiplier: 1, constant: 0
        ))

        constraints.append(NSLayoutConstraint(
            item: coachMarkViews.arrowView, attribute: .Bottom, relatedBy: .Equal,
            toItem: coachMarkViews.bodyView, attribute: .Top,
            multiplier: 1, constant: adaptedOffset(for: .Top, offset: verticalArrowOffset)
        ))

        constraints.append(bottomConstraint(forBody: coachMarkViews.bodyView, in: parentView))

        return constraints
    }

    private func bottomOrientationConstraints(for coachMarkViews: CoachMarkViews,
                                              in parentView: UIView, verticalArrowOffset: CGFloat)
        -> [NSLayoutConstraint] {
            var constraints = [NSLayoutConstraint]()

            constraints.append(NSLayoutConstraint(
                item: parentView, attribute: .Bottom, relatedBy: .Equal,
                toItem: coachMarkViews.arrowView, attribute: .Bottom,
                multiplier: 1, constant: 0
            ))

            constraints.append(NSLayoutConstraint(
                item: coachMarkViews.arrowView, attribute: .Top, relatedBy: .Equal,
                toItem: coachMarkViews.bodyView, attribute: .Bottom,
                multiplier: 1, constant: adaptedOffset(for: .Bottom, offset: verticalArrowOffset)
            ))

            constraints.append(topConstraint(forBody: coachMarkViews.bodyView, in: parentView))

            return constraints
    }

    private func adaptedOffset(for arrowPosition: ArrowPosition, offset: CGFloat) -> CGFloat {
        switch arrowPosition {
        case .Leading: return offset
        case .Center: return -offset
        case .Trailing: return -offset
        }
    }

    private func adaptedOffset(for arrowOrientation: CoachMarkArrowOrientation,
                               offset: CGFloat) -> CGFloat {
        switch arrowOrientation {
        case .Top: return offset
        case .Bottom: return -offset
        }
    }
}

typealias CoachMarkViews = (bodyView: UIView, arrowView: UIView)
typealias CoachMarkViewProperties = (orientation: CoachMarkArrowOrientation,
                                     verticalArrowOffset: CGFloat)
