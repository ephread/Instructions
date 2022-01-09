// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// The context in which present Instructions.
///
/// Instructions support different presentation context
public enum PresentationContext {
    /// Presents Instructions in separate window sitting at the given window level.
    ///
    /// This is usually the best option to present a tutorial. The window will obscure content
    /// and by prevent the user from interaction with the content under, unless configured
    /// otherwise. If you need to present Instructions on top of the current window,
    /// without managing the window level, prefer using ``window(over:)``.
    ///
    /// Although Instructions is presented in a separate window, a view controller is
    /// still required to properly handle trait collection or size changes.
    ///
    /// ⚠️ This context is not available in app extensions.
    case newWindow(over: UIViewController, at: UIWindow.Level?)

    /// The coach marks are presented the given view controller's window.
    ///
    /// Although it's possible to present coach mark in the current window, always prefer using
    /// either ``newWindow(over:at:)`` or ``viewController(_:)``.
    case currentWindow(of: UIViewController)

    /// The coach marks are presented in the given view controller.
    ///
    /// In app extensions, this is usually the best option. Instructions's root view is
    /// added to the given controller's `view` property.
    case viewController(UIViewController)

    /// Presents Instructions in separate window sitting at a higher level than the key window.
    ///
    /// This is equivalent to using ``newWindow(over:at:)`` with a window level of
    /// `.normal` + 1.
    public static func newWindow(over: UIViewController) -> PresentationContext {
        return newWindow(over: over, at: nil)
    }

    @available(swift, obsoleted: 3.0.0, renamed: "newWindow(over:)")
    public static func window(over: UIViewController) -> PresentationContext {
        return newWindow(over: over)
    }
}

internal enum PresentationStyle {
    case separateWindow, sameWindow, viewController
}
