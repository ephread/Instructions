// CoachMarksController+Deprecated.swift
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

// Disable the line lenght, due to the lack support for multi-line string literals.
// swiftlint:disable line_length
public extension CoachMarksController {
    @available(*, deprecated=0.5, message="please use flow.started instead.")
    var started: Bool {
        return flow.started
    }

    @available(*, deprecated=0.5, message="please use flow.paused instead.")
    var paused: Bool {
        return flow.paused
    }

    /// Show the next specified Coach Mark.
    ///
    /// - Parameter numberOfCoachMarksToSkip: the number of coach marks
    ///                                       to skip.
    @available(*, deprecated=0.5, message="please use flow.showNext() instead.")
    public func showNext(numberOfCoachMarksToSkip numberToSkip: Int = 0) {
        flow.showNext(numberOfCoachMarksToSkip: numberToSkip)
    }

    /// Overlay fade animation duration
    @available(*, deprecated=0.5, message="please use overlay.fadeAnimationDuration instead.")
    var overlayFadeAnimationDuration: NSTimeInterval {
        get { return overlay.fadeAnimationDuration }
        set { overlay.fadeAnimationDuration = newValue }
    }

    /// Background color of the overlay.
    @available(*, deprecated=0.5, message="please use overlay.color instead.")
    var overlayBackgroundColor: UIColor {
        get { return overlay.color }
        set { overlay.color = newValue }
    }


    /// Blur effect style for the overlay view. Keeping this property
    /// `nil` will disable the effect. This property
    /// is mutually exclusive with `overlayBackgroundColor`.
    @available(*, deprecated=0.5, message="please use blurEffectStyle instead.")
    var overlayBlurEffectStyle: UIBlurEffectStyle? {
        get { return overlay.blurEffectStyle }
        set { overlay.blurEffectStyle = newValue }
    }

    /// `true` to let the overlay catch tap event and forward them to the
    /// CoachMarkController, `false` otherwise.
    ///
    /// After receiving a tap event, the controller will show the next coach mark.
    ///
    /// You can disable the tap on a case-by-case basis, see CoachMark.disableOverlayTap
    @available(*, deprecated=0.5, message="please use overlay.allowTap instead.")
    var allowOverlayTap: Bool {
        get { return overlay.allowTap }
        set { overlay.allowTap = newValue }
    }

    /// Returns a new coach mark with a cutout path set to be
    /// around the provided UIView. The cutout path will be slightly
    /// larger than the view and have rounded corners, however you can
    /// bypass the default creator by providing a block.
    ///
    /// The point of interest (defining where the arrow will sit, horizontally)
    /// will be the one provided.
    ///
    /// - Parameter view: the view around which create the cutoutPath
    /// - Parameter pointOfInterest: the point of interest toward which the arrow should point
    /// - Parameter bezierPathBlock: a block customizing the cutoutPath
    @available(*, deprecated=0.5, message="please use helper.coachMarkForView instead.")
    public func coachMarkForView(view: UIView? = nil, pointOfInterest: CGPoint? = nil,
                                 bezierPathBlock: BezierPathBlock? = nil) -> CoachMark {
        return helper.coachMarkForView(view,
                                       pointOfInterest: pointOfInterest,
                                       bezierPathBlock: bezierPathBlock)
    }

    /// Provides default coach views.
    ///
    /// - Parameter arrow: `true` to return an instance of `CoachMarkArrowDefaultView`
    ///                    as well, `false` otherwise.
    /// - Parameter withNextText: `true` to show the ‘next’ pseudo-button,
    ///                           `false` otherwise.
    /// - Parameter arrowOrientation: orientation of the arrow (either .Top or .Bottom)
    ///
    /// - Returns: new instances of the default coach views.
    @available(*, deprecated=0.5, message="please use helper.defaultCoachViewsWithArrow instead.")
    public func defaultCoachViewsWithArrow(arrow: Bool = true, withNextText nextText: Bool = true,
                                           arrowOrientation: CoachMarkArrowOrientation? = .Top)
    -> (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?) {
        return helper.defaultCoachViewsWithArrow(arrow, withNextText: nextText,
                                                 arrowOrientation: arrowOrientation)
    }

    /// Provides default coach views, can have a next label or just the message.
    ///
    /// - Parameter arrow: `true` to return an instance of
    ///                    `CoachMarkArrowDefaultView` as well, `false` otherwise.
    /// - Parameter arrowOrientation: orientation of the arrow (either .Top or .Bottom)
    /// - Parameter hintText: message to show in the CoachMark
    /// - Parameter nextText: text for the next label, if nil the CoachMark
    ///                       view will only show the hint text
    ///
    /// - Returns: new instances of the default coach views.
    @available(*, deprecated=0.5, message="please use helper.defaultCoachViewsWithArrow instead.")
    public func defaultCoachViewsWithArrow(arrow: Bool = true,
                                           arrowOrientation: CoachMarkArrowOrientation? = .Top,
                                           hintText: String, nextText: String? = nil)
    -> (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?) {
        return helper.defaultCoachViewsWithArrow(arrow, arrowOrientation: arrowOrientation,
                                                 hintText: hintText, nextText: nextText)
    }

    /// Updates the currently stored coach mark with a cutout path set to be
    /// around the provided UIView. The cutout path will be slightly
    /// larger than the view and have rounded corners, however you can
    /// bypass the default creator by providing a block.
    ///
    /// The point of interest (defining where the arrow will sit, horizontally)
    /// will be the one provided.
    ///
    /// This method is expected to be used in the delegate, after pausing the display.
    /// Otherwise, there might not be such a thing as a "current coach mark".
    ///
    /// - Parameter view: the view around which create the cutoutPath
    /// - Parameter pointOfInterest: the point of interest toward which the arrow
    ///                              should point
    /// - Parameter bezierPathBlock: a block customizing the cutoutPath
    @available(*, deprecated=0.5, message="please use helper.updateCurrentCoachMarkForView instead.")
    public func updateCurrentCoachMarkForView(view: UIView? = nil, pointOfInterest: CGPoint? = nil ,
                                              bezierPathBlock: BezierPathBlock? = nil) {
        helper.updateCurrentCoachMarkForView(view, pointOfInterest: pointOfInterest,
                                             bezierPathBlock: bezierPathBlock)
    }

    /// Updates the given coach mark with a cutout path set to be
    /// around the provided UIView. The cutout path will be slightly
    /// larger than the view and have rounded corners, however you can
    /// bypass the default creator by providing a block.
    ///
    /// The point of interest (defining where the arrow will sit, horizontally)
    /// will be the one provided.
    ///
    /// - Parameter coachMark: the CoachMark to update
    /// - Parameter forView: the view around which create the cutoutPath
    /// - Parameter pointOfInterest: the point of interest toward which the arrow should point
    /// - Parameter bezierPathBlock: a block customizing the cutoutPath
    @available(*, deprecated=0.5, message="please use helper.updateCoachMark instead.")
    internal func updateCoachMark(inout coachMark: CoachMark, forView view: UIView? = nil,
                                  pointOfInterest: CGPoint? = nil,
                                  bezierPathBlock: BezierPathBlock? = nil) {
        helper.updateCoachMark(&coachMark, forView: view, pointOfInterest: pointOfInterest,
                               bezierPathBlock: bezierPathBlock)
    }
}
