// Copyright (c)  2021-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import Foundation

public class CoachMarkCoordinateConverter {
    private let rootView: InstructionsRootView

    init(rootView: InstructionsRootView) {
        self.rootView = rootView
    }

    func convert(frame: CGRect, from superview: UIView?) -> CGRect {
        // No superview, assuming frame in `instructionsRootView`'s coordinate system.
        guard let superview = superview else {
            print(ErrorMessage.Warning.anchorViewIsNotInTheViewHierarchy)
            return frame
        }

        // Either `superview` and `instructionsRootView` is not in the hierarchy,
        // the result is undefined.
        guard let superviewWindow = superview.window,
              let instructionsWindow = rootView.window else {
            print(ErrorMessage.Warning.anchorViewIsNotInTheViewHierarchy)
            return rootView.convert(frame, from: superview)
        }

        // If both windows are the same, we can directly convert, because
        // `superview` and `instructionsRootView` are in the same hierarchy.
        //
        // This is the case when showing Instructions either in the parent
        // view controller or the parent window.
        guard superviewWindow != instructionsWindow else {
            return rootView.convert(frame, from: superview)
        }

        // 1. Converts the coordinates of the frame from its superview to its window.
        let frameInWindow = superviewWindow.convert(frame, from: superview)

        // 2. Converts the coordinates of the frame from its window to Instructions' window.
        let frameInInstructionsWindow = instructionsWindow.convert(frameInWindow,
                                                                   from: superviewWindow)

        // 3. Converts the coordinates of the frame from Instructions' window to
        //    `instructionsRootView`.
        return rootView.convert(frameInInstructionsWindow, from: instructionsWindow)
    }

    func convert(point: CGPoint, from superview: UIView?) -> CGPoint {
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
