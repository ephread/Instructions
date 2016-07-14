// CoachMarkView.swift
//
// Copyright (c) 2015 Frédéric Maquin <fred@ephread.com>
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

/// The actual coach mark that will be displayed.
///
/// Note: This class is final for two reasons:
/// 1. It doesn't implement properly all the UIView initializers
/// 2. It is not suppoed to be subclassed at the moment, as it only acts as
///    container for body and arrow views.
final internal class CoachMarkView : UIView, CoachMarkBodyHighlightArrowDelegate {
    //MARK: - Internal properties

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
    
    //MARK: - Private properties

    /// The horizontal position of the arrow, likely to be at the center of the
    /// cutout path.
    var arrowXpositionConstraint: NSLayoutConstraint?

    /// The constraint making the arrow stick to its parent.
    var arrowStickToParent: NSLayoutConstraint?

    /// The constraint making the arrow stick to its body.
    var arrowStickToBodyConstraint: NSLayoutConstraint?

    /// The constraint making the body stick to its parent.
    var bodyStickToParent: NSLayoutConstraint?

    //MARK: - Initialization

    /// Allocate and initliaze the coach mark view, with the given subviews.
    ///
    /// - Parameter bodyView: the mandatory body view
    /// - Parameter arrowView: the optional arrow view
    /// - Parameter arrowOrientation: the arrow orientation, either .Top or .Bottom
    /// - Parameter arrowOffset: the arrow offset (in case the arrow is required to overlap the body) - a positive number will make the arrow overlap.
    init(bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView? = nil,
        arrowOrientation: CoachMarkArrowOrientation? = nil, arrowOffset: CGFloat? = 0.0) {

        // Due to the fact Swift 2 compiler doesn't let us enforce type check of
        // an object being a class conforming to a given protocol, we are checking the
        // type of body and arrow views at runtime. This isn't very nice, but I haven't found any
        // better way to enforce that they both are subclasses of `UIView` and conform to the `CoachMarkBodyView`
        // and `CoachMarkArrowView` protocols.
        if !(bodyView is UIView) {
            fatalError("Body view must conform to CoachMarkBodyView but also be a UIView.")
        }

        if arrowView != nil && !(arrowView is UIView) {
            fatalError("Arrow view must conform to CoachMarkArrowView but also be a UIView.")
        }

        self.bodyView = bodyView
        self.arrowView = arrowView
        self.arrowOrientation = arrowOrientation

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

    //MARK: - Protocol conformance | CoachMarkBodyHighlightArrowDelegate

    func highlightArrow(_ highlighted: Bool) {
        self.arrowView?.highlighted = highlighted
    }

    //MARK: - Internal Method

    //TODO: Better documentation
    /// Change the arrow horizontal position to the given position.
    /// `position` is relative to:
    /// - `.Leading`: `offset` is relative to the leading edge of the overlay
    /// - `.Center`: `offset` is relative to the center of the overlay
    /// - `.Trailing`: `offset` is relative to the trailing edge of the overlay
    ///
    /// - Parameter position: arrow position
    /// - Parameter offset: arrow offset
    func changeArrowPositionTo(_ position: ArrowPosition, offset: CGFloat) {
        
        if self.arrowView == nil {
            return
        }

        let arrowView = self.arrowView as! UIView

        if self.arrowXpositionConstraint != nil {
            self.removeConstraint(self.arrowXpositionConstraint!)
        }

        if position == .leading {
            self.arrowXpositionConstraint =
                NSLayoutConstraint(item: arrowView, attribute: .centerX, relatedBy: .equal,
                                   toItem: self.bodyView, attribute: .leading,
                                   multiplier: 1, constant: offset)
        } else if position == .center {
            self.arrowXpositionConstraint =
                NSLayoutConstraint(item: arrowView, attribute: .centerX, relatedBy: .equal,
                                   toItem: self.bodyView, attribute: .centerX,
                                   multiplier: 1, constant: -offset)
        } else if position == .trailing {
            self.arrowXpositionConstraint =
                NSLayoutConstraint(item: arrowView, attribute: .centerX, relatedBy: .equal,
                                   toItem: self.bodyView, attribute: .trailing,
                                   multiplier: 1, constant: -offset)
        }

        self.addConstraint(self.arrowXpositionConstraint!)
    }

    //MARK: - Private Method

    /// Layout the body view and the arrow view together.
    private func layoutViewComposition() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.bodyView as! UIView)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bodyView]|", options: NSLayoutFormatOptions(rawValue: 0),
                                                                           metrics: nil, views: ["bodyView": self.bodyView]))

        let bodyStickToTop = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                                                toItem: self.bodyView, attribute: .top,
                                                multiplier: 1, constant: 0)

        let bodyStickToBottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                                                   toItem: self.bodyView, attribute: .bottom,
                                                   multiplier: 1, constant: 0)

        if let arrowView = self.arrowView, arrowOrientation = self.arrowOrientation {
            let arrowView = arrowView as! UIView

            self.addSubview(arrowView)

            self.arrowXpositionConstraint = NSLayoutConstraint(item: arrowView, attribute: .centerX, relatedBy: .equal,
                                                               toItem: self.bodyView, attribute: .centerX,
                                                               multiplier: 1, constant: 0)

            self.addConstraint(self.arrowXpositionConstraint!)

            if arrowOrientation == .top {
                self.arrowStickToParent = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                                                              toItem: arrowView, attribute: .top,
                                                              multiplier: 1, constant: 0)
                
                self.arrowStickToBodyConstraint = NSLayoutConstraint(item: arrowView, attribute: .bottom, relatedBy: .equal,
                                                                     toItem: self.bodyView, attribute: .top,
                                                                     multiplier: 1, constant: self.arrowOffset)

                self.addConstraint(bodyStickToBottom)
            } else if arrowOrientation == .bottom {
                self.arrowStickToParent = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                                                             toItem: arrowView, attribute: .bottom,
                                                             multiplier: 1, constant: 0)

                self.arrowStickToBodyConstraint = NSLayoutConstraint(item: arrowView, attribute: .top, relatedBy: .equal,
                                                                     toItem: self.bodyView, attribute: .bottom,
                                                                     multiplier: 1, constant: -self.arrowOffset)

                self.addConstraint(bodyStickToTop)
            }

            self.addConstraint(self.arrowStickToParent!)
            self.addConstraint(self.arrowStickToBodyConstraint!)
        } else {
            self.addConstraint(bodyStickToTop)
            self.addConstraint(bodyStickToBottom)
        }
    }
}
