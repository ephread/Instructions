// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

public class CoachMarkHelper {

    let instructionsRootView: InstructionsRootView
    let flowManager: FlowManager
    let coordinateConverter: CoachMarkCoordinateConverter

    init(instructionsRootView: InstructionsRootView, flowManager: FlowManager) {
        self.instructionsRootView = instructionsRootView
        self.flowManager = flowManager

        self.coordinateConverter = CoachMarkCoordinateConverter(rootView: instructionsRootView)
    }

    // MARK: - Coach View Creation
    /// Creates the default coach views.
    ///
    /// - Parameters:
    ///   - arrow: `true` to generate the arrow view, `false` otherwise.
    ///   - nextText: `true` to add a label on the trailing side, calling for
    ///               a tap; the content of the label can be customised at a later stage.
    ///   - arrowOrientation: The orientation of the coach mark / arrow.
    /// - Returns: New instances of the default coach views.
    public func makeDefaultCoachViews(
        withArrow arrow: Bool = true,
        withNextText nextText: Bool = true,
        arrowOrientation: CoachMarkArrowOrientation? = .top
    ) -> (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?) {

        var coachMarkBodyView: CoachMarkBodyDefaultView

        if nextText {
            coachMarkBodyView = CoachMarkBodyDefaultView()
        } else {
            coachMarkBodyView = CoachMarkBodyDefaultView(hintText: "", nextText: nil)
        }

        var coachMarkArrowView: CoachMarkArrowDefaultView?

        if arrow {
            coachMarkArrowView = makeDefaultArrow(withOrientation: arrowOrientation)
        }

        return (bodyView: coachMarkBodyView, arrowView: coachMarkArrowView)
    }

    /// Creates the default coach views.
    ///
    /// - Parameters:
    ///   - arrow: `true` to generate the arrow view, `false` otherwise.
    ///   - arrowOrientation: The orientation of the coach mark / arrow.
    ///   - hintText: The hint/description of the coach mark.
    ///   - nextText: An optional text to display on the trailing side, calling for
    ///               a tap.
    /// - Returns: New instances of the default coach views.
    public func makeDefaultCoachViews(
        withArrow arrow: Bool = true,
        arrowOrientation: CoachMarkArrowOrientation? = .top,
        hintText: String,
        nextText: String? = nil
    ) -> (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?) {
        let coachMarkBodyView = CoachMarkBodyDefaultView(hintText: hintText, nextText: nextText)

        var coachMarkArrowView: CoachMarkArrowDefaultView?

        if arrow {
            coachMarkArrowView = makeDefaultArrow(withOrientation: arrowOrientation)
        }

        return (bodyView: coachMarkBodyView, arrowView: coachMarkArrowView)
    }

    // MARK: - Coach Mark Creation
    /// Returns a new coach mark based on the given `frame` rectangle and `pointOfInterest`.
    /// Both are relative to `superview`’s coordinate system.
    ///
    /// The default cutout path expands the frame of the given view by a few points and
    /// rounds its corners. If the default behavior is undesirable, a custom
    /// `cutoutPathMaker` should be provided.
    ///
    /// If `pointOfInterest` is `nil`, the center of `frame` will be used to create the
    /// coach mark.
    ///
    /// If all parameters are `nil`, calling this method has the same effect as
    /// instantiating a new `CoachMark`.
    ///
    /// - Parameters:
    ///   - view: The view used to generate the cutout path.
    ///   - pointOfInterest: The point of interest towards which the arrow points; must
    ///                      be relative to the coordinates of view's superview.
    ///   - cutoutPathMaker: a block customizing the cutout path.
    /// - Returns: A instance of `CoachMark` configured with the provided parameters.
    public func makeCoachMark(
        for view: UIView? = nil,
        pointOfInterest: CGPoint? = nil,
        cutoutPathMaker: CutoutPathMaker? = nil
    ) -> CoachMark {
        var coachMark = CoachMark()

        guard let view = view else {
            return coachMark
        }

        update(coachMark: &coachMark,
               usingFrame: view.frame,
               pointOfInterest: pointOfInterest,
               superview: view.superview,
               cutoutPathMaker: cutoutPathMaker)

        return coachMark
    }

    /// Returns a new coach mark based on the given `frame` rectangle and `pointOfInterest`.
    /// Both are relative to `superview`’s coordinate system.
    ///
    /// The default cutout path expands the given rectangle by a few points and rounds its corners.
    /// If the default behavior is undesirable, a custom `cutoutPathMaker` should be provided.
    ///
    /// If `pointOfInterest` is `nil`,
    ///
    /// - Parameters:
    ///   - frame: The frame used to generate the cutout path.
    ///   - superview: The superview defining the coordinate system.
    ///   - pointOfInterest: The point of interest towards which the arrow points.
    ///   - cutoutPathMaker: a block customizing the cutout path.
    /// - Returns: A instance of `CoachMark` configured with the provided parameters.
    public func makeCoachMark(
        forFrame frame: CGRect,
        pointOfInterest: CGPoint,
        in superview: UIView?,
        cutoutPathMaker: CutoutPathMaker? = nil
    ) -> CoachMark {
        var coachMark = CoachMark()

        update(coachMark: &coachMark,
               usingFrame: frame,
               pointOfInterest: pointOfInterest,
               superview: superview,
               cutoutPathMaker: cutoutPathMaker)

        return coachMark
    }

    /// Returns a new coach mark based on the `pointOfInterest`, relative to
    /// `superview`’s coordinate system.
    ///
    /// If `pointOfInterest` is `nil`, the center of `frame` will be used to create the
    /// coach mark.
    ///
    /// - Parameters:
    ///   - frame: The frame used to generate the cutout path.
    ///   - superview: The superview defining the coordinate system.
    ///   - pointOfInterest: The point of interest towards which the arrow points.
    ///   - cutoutPathMaker: a block customizing the cutout path.
    /// - Returns: A instance of `CoachMark` configured with the provided parameters.
    public func makeCoachMark(
        pointOfInterest: CGPoint? = nil,
        in superview: UIView?
    ) -> CoachMark {
        var coachMark = CoachMark()

        update(coachMark: &coachMark,
               usingFrame: nil,
               pointOfInterest: pointOfInterest,
               superview: superview,
               cutoutPathMaker: nil)

        return coachMark
    }

    /// Returns a new coach mark based on the given `frame` rectangle relative to
    /// `superview`’s coordinate system.
    ///
    /// The default cutout path expands the given rectangle by a few points and rounds its corners.
    /// If the default behavior is undesirable, a custom `cutoutPathMaker` should be provided.
    ///
    /// The center of `frame` is used to create the point of interest.
    ///
    /// - Parameters:
    ///   - frame: The frame used to generate the cutout path.
    ///   - superview: The superview defining the coordinate system.
    ///   - cutoutPathMaker: a block customizing the cutout path.
    /// - Returns: A instance of `CoachMark` configured with the provided parameters.
    public func makeCoachMark(
        forFrame frame: CGRect,
        in superview: UIView?,
        cutoutPathMaker: CutoutPathMaker? = nil
    ) -> CoachMark {
        var coachMark = CoachMark()

        update(coachMark: &coachMark,
               usingFrame: frame,
               pointOfInterest: nil,
               superview: superview,
               cutoutPathMaker: cutoutPathMaker)

        return coachMark
    }

    // MARK: - Coach Mark Update
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
    public func updateCurrentCoachMark(usingView view: UIView? = nil,
                                       pointOfInterest: CGPoint? = nil,
                                       cutoutPathMaker: CutoutPathMaker? = nil) {
        // `currentCoachMark` is inout, so binding it conditionally doesn't
        // make sense, we'll have to force unwrap it later anyway since it's
        // a value type.
        guard flowManager.isPaused, flowManager.currentCoachMark != nil else {
            print(ErrorMessage.Error.updateWentWrong)
            return
        }

        update(coachMark: &flowManager.currentCoachMark!,
               usingFrame: view?.frame,
               pointOfInterest: pointOfInterest,
               superview: view?.superview,
               cutoutPathMaker: cutoutPathMaker)
    }

    /// Updates the current coach mark, using a configuration block.
    ///
    /// This method is expected to be used in the delegate, after pausing the display.
    /// Otherwise, there might not be such a thing as a "current coach mark".
    ///
    /// - Parameter configure: A configuration updating the current coach mark.
    /// - Parameter coachMark: The coach mark to update.
    /// - Parameter frameConverter: Since the cutout path and the point of interest need
    ///                             to be expressed in Instruction's coordinate system, you
    ///                             can used this instance of `CoachMarkCoordinateConverter`
    ///                             to convert rectangles and points.
    public func updateCurrentCoachMark(
        _ configure: (_ coachMark: inout CoachMark,
                      _ frameConverter: CoachMarkCoordinateConverter) -> Void
    ) {
        // `currentCoachMark` is inout, so binding it conditionally doesn't
        // make sense, we'll have to force unwrap it later anyway since it's
        // a value type.
        guard flowManager.isPaused, flowManager.currentCoachMark != nil else {
            print(ErrorMessage.Error.updateWentWrong)
            return
        }

        configure(&flowManager.currentCoachMark!, coordinateConverter)
    }
}

// MARK: - Internal Methods
internal extension CoachMarkHelper {
    func update(
        coachMark: inout CoachMark,
        usingFrame frame: CGRect? = nil,
        pointOfInterest: CGPoint?,
        superview: UIView? = nil,
        cutoutPathMaker: CutoutPathMaker? = nil
    ) {
        if let frame = frame {
            let convertedFrame = coordinateConverter.convert(rect: frame, from: superview)

            let bezierPath: UIBezierPath

            if let makeCutoutPathWithFrame = cutoutPathMaker {
                bezierPath = makeCutoutPathWithFrame(convertedFrame)
            } else {
                bezierPath = UIBezierPath(roundedRect: convertedFrame.insetBy(dx: -4, dy: -4),
                                          byRoundingCorners: .allCorners,
                                          cornerRadii: CGSize(width: 4, height: 4))
            }

            coachMark.cutoutPath = bezierPath
        }

        if let pointOfInterest = pointOfInterest {
            let convertedPointOfInterest = coordinateConverter.convert(point: pointOfInterest,
                                                                       from: superview)
            coachMark.pointOfInterest = convertedPointOfInterest
        }
    }

    func makeDefaultArrow(
        withOrientation arrowOrientation: CoachMarkArrowOrientation?
    ) -> CoachMarkArrowDefaultView {
        guard let arrowOrientation = arrowOrientation else {
            return CoachMarkArrowDefaultView(orientation: .top)
        }

        return CoachMarkArrowDefaultView(orientation: arrowOrientation)
    }
}

// MARK: - Typealiases
public typealias CutoutPathMaker = (_ frame: CGRect) -> UIBezierPath
