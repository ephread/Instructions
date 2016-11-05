// CoachMarkView.swift
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

// swiftlint:disable force_cast

/// The actual coach mark that will be displayed.
class CoachMarkView: UIView {
    //mark: - Internal properties

    /// The body of the coach mark (likely to contain some text).
    let bodyView: CoachMarkBodyView

    /// The arrow view, note that the arrow view is not mandatory.
    private(set) var arrowView: CoachMarkArrowView?

    /// The arrow orientation (where it will sit relative to the body view, i.e.
    /// above or below.)
    private(set) var arrowOrientation: CoachMarkArrowOrientation?

    /// The offset (in case the arrow is required to overlap the body)
    var arrowOffset: CGFloat = 0.0

    /// The control used to get to the next coach mark.
    var nextControl: UIControl? {
        get {
            return bodyView.nextControl
        }
    }

    //mark: - Private properties
    private var bodyUIView: UIView { return bodyView as! UIView }
    private var arrowUIView: UIView? { return arrowView as? UIView }
    private var innerConstraints = CoachMarkViewConstraints()
    private let coachMarkLayoutHelper: CoachMarkInnerLayoutHelper

    //mark: - Initialization

    /// Allocate and initliaze the coach mark view, with the given subviews.
    ///
    /// - Parameter bodyView:         the mandatory body view
    /// - Parameter arrowView:        the optional arrow view
    /// - Parameter arrowOrientation: the arrow orientation, either .Top or .Bottom
    /// - Parameter arrowOffset:      the arrow offset (in case the arrow is required
    ///                               to overlap the body) - a positive number
    ///                               will make the arrow overlap.
    /// - Parameter coachMarkInnerLayoutHelper: auto-layout constraints helper.
    init(bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView? = nil,
         arrowOrientation: CoachMarkArrowOrientation? = nil, arrowOffset: CGFloat? = 0.0,
         coachMarkInnerLayoutHelper: CoachMarkInnerLayoutHelper) {

        // Due to the fact Swift 2 compiler doesn't let us enforce type check of
        // an object being a class conforming to a given protocol, we are checking
        // the type of body and arrow views at runtime. This isn't very nice, but
        // I haven't found any better way to enforce that they both are subclasses
        // of `UIView` and conform to the `CoachMarkBodyView` and
        // `CoachMarkArrowView` protocols.
        if !(bodyView is UIView) {
            fatalError("Body view must conform to CoachMarkBodyView but also be a UIView.")
        }

        if arrowView != nil && !(arrowView is UIView) {
            fatalError("Arrow view must conform to CoachMarkArrowView but also be a UIView.")
        }

        self.bodyView = bodyView
        self.arrowView = arrowView
        self.arrowOrientation = arrowOrientation
        self.coachMarkLayoutHelper = coachMarkInnerLayoutHelper

        if arrowOffset != nil {
            self.arrowOffset = arrowOffset!
        }

        super.init(frame: CGRect.zero)

        self.bodyView.highlightArrowDelegate = self
        self.layoutViewComposition()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }

    //mark: - Internal Method

    //TODO: Better documentation
    /// Change the arrow horizontal position to the given position.
    /// `position` is relative to:
    /// - `.Leading`: `offset` is relative to the leading edge of the overlay;
    /// - `.Center`: `offset` is relative to the center of the overlay;
    /// - `.Trailing`: `offset` is relative to the trailing edge of the overlay.
    ///
    /// - Parameter position: arrow position
    /// - Parameter offset: arrow offset
    func changeArrowPosition(to position: ArrowPosition, offset: CGFloat) {

        guard let arrowUIView = arrowUIView else { return }

        if innerConstraints.arrowXposition != nil {
            self.removeConstraint(innerConstraints.arrowXposition!)
        }

        innerConstraints.arrowXposition = coachMarkLayoutHelper.horizontalArrowConstraints(
            for: (bodyView: bodyUIView, arrowView: arrowUIView), withPosition: position,
            horizontalOffset: offset)

        self.addConstraint(innerConstraints.arrowXposition!)
    }

    //mark: - Private Method

    /// Layout the body view and the arrow view together.
    fileprivate func layoutViewComposition() {
        translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(bodyUIView)
        self.addConstraints(coachMarkLayoutHelper.horizontalConstraints(forBody: bodyUIView))

        if let arrowUIView = arrowUIView, let arrowOrientation = self.arrowOrientation {
            self.addSubview(arrowUIView)

            innerConstraints.arrowXposition = coachMarkLayoutHelper.horizontalArrowConstraints(
                for: (bodyView: bodyUIView, arrowView: arrowUIView), withPosition: .center,
                horizontalOffset: 0)

            self.addConstraint(innerConstraints.arrowXposition!)
            self.addConstraints(coachMarkLayoutHelper.verticalConstraints(
                for: (bodyView: bodyUIView, arrowView: arrowUIView), in: self,
                withProperties: (orientation: arrowOrientation, verticalArrowOffset: arrowOffset)
            ))
        } else {
            self.addConstraint(coachMarkLayoutHelper.topConstraint(forBody: bodyUIView, in: self))
            self.addConstraint(coachMarkLayoutHelper.topConstraint(forBody: bodyUIView, in: self))
        }
    }
}

//mark: - Protocol conformance | CoachMarkBodyHighlightArrowDelegate
extension CoachMarkView: CoachMarkBodyHighlightArrowDelegate {
    func highlightArrow(_ highlighted: Bool) {
        self.arrowView?.highlighted = highlighted
    }
}

struct CoachMarkViewConstraints {
    /// The horizontal position of the arrow, likely to be at the center of the
    /// cutout path.
    fileprivate var arrowXposition: NSLayoutConstraint?

    /// The constraint making the body stick to its parent.
    fileprivate var bodyStickToParent: NSLayoutConstraint?

    init () { }
}
