//
//  CoachMarkHelper.swift
//  Instructions
//
//  Created by Frédéric Maquin on 05/08/16.
//  Copyright © 2016 Ephread. All rights reserved.
//

import Foundation

public class CoachMarkHelper {

    let instructionsRootView: InstructionsRootView
    let flowManager: FlowManager

    init(instructionsRootView: InstructionsRootView,
         flowManager: FlowManager) {
        self.instructionsRootView = instructionsRootView
        self.flowManager = flowManager
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
    public func coachMarkForView(
        view: UIView? = nil,
        pointOfInterest: CGPoint? = nil,
        bezierPathBlock: ((frame: CGRect) -> UIBezierPath)? = nil
    ) -> CoachMark {
        var coachMark = CoachMark()

        guard let view = view else {
            return coachMark
        }

        self.updateCoachMark(&coachMark, forView: view,
                             pointOfInterest: pointOfInterest,
                             bezierPathBlock: bezierPathBlock)

        return coachMark
    }

    /// Provides default coach views.
    ///
    /// - Parameter arrow: `true` to return an instance of `CoachMarkArrowDefaultView`
    ///                        as well, `false` otherwise.
    /// - Parameter withNextText: `true` to show the ‘next’ pseudo-button,
    ///                           `false` otherwise.
    /// - Parameter arrowOrientation: orientation of the arrow (either .Top or .Bottom)
    ///
    /// - Returns: new instances of the default coach views.
    public func defaultCoachViewsWithArrow(
        arrow: Bool = true,
        withNextText nextText: Bool = true,
        arrowOrientation: CoachMarkArrowOrientation? = .Top
    ) -> (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?) {

        var coachMarkBodyView: CoachMarkBodyDefaultView

        if nextText {
            coachMarkBodyView = CoachMarkBodyDefaultView()
        } else {
            coachMarkBodyView = CoachMarkBodyDefaultView(hintText: "", nextText: nil)
        }

        var coachMarkArrowView: CoachMarkArrowDefaultView? = nil

        if arrow {
            var arrowOrientation = arrowOrientation

            if arrowOrientation == nil {
                arrowOrientation = .Top
            }

            coachMarkArrowView = CoachMarkArrowDefaultView(orientation: arrowOrientation!)
        }

        return (bodyView: coachMarkBodyView, arrowView: coachMarkArrowView)
    }

    /// Provides default coach views, can have a next label or just the message.
    ///
    /// - Parameter arrow: `true` to return an instance of
    ///                        `CoachMarkArrowDefaultView` as well, `false` otherwise.
    /// - Parameter arrowOrientation: orientation of the arrow (either .Top or .Bottom)
    /// - Parameter hintText: message to show in the CoachMark
    /// - Parameter nextText: text for the next label, if nil the CoachMark
    ///                       view will only show the hint text
    ///
    /// - Returns: new instances of the default coach views.
    public func defaultCoachViewsWithArrow(
        arrow: Bool = true,
        arrowOrientation: CoachMarkArrowOrientation? = .Top,
        hintText: String,
        nextText: String? = nil
    ) -> (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?) {
        let coachMarkBodyView = CoachMarkBodyDefaultView(hintText: hintText, nextText: nextText)

        var coachMarkArrowView: CoachMarkArrowDefaultView? = nil

        if arrow {
            var arrowOrientation = arrowOrientation

            if arrowOrientation == nil {
                arrowOrientation = .Top
            }

            coachMarkArrowView = CoachMarkArrowDefaultView(orientation: arrowOrientation!)
        }

        return (bodyView: coachMarkBodyView, arrowView: coachMarkArrowView)
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
    public func updateCurrentCoachMarkForView(
        view: UIView? = nil,
        pointOfInterest: CGPoint? = nil ,
        bezierPathBlock: ((frame: CGRect) -> UIBezierPath)? = nil
    ) {
        if !flowManager.paused || flowManager.currentCoachMark == nil {
            print("updateCurrentCoachMarkForView: Something is wrong, did you" +
                "called updateCurrentCoachMarkForView without pausing" +
                "the controller first?")
            return
        }

        updateCoachMark(&flowManager.currentCoachMark!,
                        forView: view,
                        pointOfInterest: pointOfInterest,
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
    internal func updateCoachMark(
        inout coachMark: CoachMark,
        forView view: UIView? = nil,
        pointOfInterest: CGPoint?,
        bezierPathBlock: ((frame: CGRect) -> UIBezierPath)? = nil
    ) {
        guard let view = view else {
            return
        }

        let convertedFrame =
            instructionsRootView.convertRect(view.frame, fromView: view.superview)

        let bezierPath: UIBezierPath

        if let bezierPathBlock = bezierPathBlock {
            bezierPath = bezierPathBlock(frame: convertedFrame)
        } else {
            bezierPath = UIBezierPath(
                roundedRect: convertedFrame.insetBy(dx: -4, dy: -4),
                byRoundingCorners: .AllCorners,
                cornerRadii: CGSize(width: 4, height: 4)
            )
        }

        coachMark.cutoutPath = bezierPath

        if let pointOfInterest = pointOfInterest {
            coachMark.pointOfInterest =
                instructionsRootView.convertPoint(pointOfInterest,
                                                  fromView: view.superview)
        }
    }
}
