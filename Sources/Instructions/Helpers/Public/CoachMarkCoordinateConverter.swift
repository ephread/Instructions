// Copyright (c)  2021-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

public class CoachMarkCoordinateConverter {
    private let rootView: InstructionsRootView

    init(rootView: InstructionsRootView) {
        self.rootView = rootView
    }

    /// Converts a rectangle from the specified coordinate space
    /// to the coordinate space of Instructions.
    ///
    /// - Parameters:
    ///   - frame: A rectangle in the specified coordinate space.
    ///   - superview: The coordinate space in which `rect` is specified.
    /// - Returns: A rectangle specified in the coordinate space of Instructions.
    public func convert(rect: CGRect, from superview: UIView?) -> CGRect {
        // No superview, assuming frame in `instructionsRootView`'s coordinate system.
        guard let superview = superview else {
            print(ErrorMessage.Warning.anchorViewIsNotInTheViewHierarchy)
            return rect
        }

        // Either `superview` and `instructionsRootView` is not in the hierarchy,
        // the result is undefined.
        guard let superviewWindow = superview.window,
              let instructionsWindow = rootView.window else {
            print(ErrorMessage.Warning.anchorViewIsNotInTheViewHierarchy)
            return rootView.convert(rect, from: superview)
        }

        // If both windows are the same, we can directly convert, because
        // `superview` and `instructionsRootView` are in the same hierarchy.
        //
        // This is the case when showing Instructions either in the parent
        // view controller or the parent window.
        guard superviewWindow != instructionsWindow else {
            return rootView.convert(rect, from: superview)
        }

        // 1. Converts the coordinates of the frame from its superview to its window.
        let rectInWindow = superviewWindow.convert(rect, from: superview)

        // 2. Converts the coordinates of the frame from its window to Instructions' window.
        let rectInInstructionsWindow = instructionsWindow.convert(rectInWindow,
                                                                  from: superviewWindow)

        // 3. Converts the coordinates of the frame from Instructions' window to
        //    `instructionsRootView`.
        return rootView.convert(rectInInstructionsWindow, from: instructionsWindow)
    }

    /// Converts a point from the specified coordinate space
    /// to the coordinate space of Instructions.
    ///
    /// - Parameters:
    ///   - frame: A point in the specified coordinate space.
    ///   - superview: The coordinate space in which `point` is specified.
    /// - Returns: A point specified in the coordinate space of Instructions.
    public func convert(point: CGPoint, from superview: UIView?) -> CGPoint {
        // No superview, assuming frame in `instructionsRootView`'s coordinate system.
        guard let superview = superview else {
            print(ErrorMessage.Warning.anchorViewIsNotInTheViewHierarchy)
            return point
        }

        // Either `superview` and `instructionsRootView` is not in the hierarchy,
        // the result is undefined.
        guard let superviewWindow = superview.window,
              let instructionsWindow = rootView.window else {
            print(ErrorMessage.Warning.anchorViewIsNotInTheViewHierarchy)
            return rootView.convert(point, from: superview)
        }

        // If both windows are the same, we can directly convert, because
        // `superview` and `instructionsRootView` are in the same hierarchy.
        //
        // This is the case when showing Instructions either in the parent
        // view controller or the parent window.
        guard superviewWindow != instructionsWindow else {
            return rootView.convert(point, from: superview)
        }

        // 1. Converts the coordinates of the frame from its superview to its window.
        let frameInWindow = superviewWindow.convert(point, from: superview)

        // 2. Converts the coordinates of the frame from its window to Instructions' window.
        let frameInInstructionsWindow = instructionsWindow.convert(frameInWindow,
                                                                   from: superviewWindow)

        // 3. Converts the coordinates of the frame from Instructions' window to
        //    `instructionsRootView`.
        return rootView.convert(frameInInstructionsWindow, from: instructionsWindow)
    }
}
