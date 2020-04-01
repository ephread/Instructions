// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.
import UIKit

// TODO: Remove the override once the bug is fixed.
// swiftlint:disable identifier_name

public enum PresentationContext {
    case newWindow(over: UIViewController, at: UIWindow.Level?)
    case currentWindow(of: UIViewController)
    case viewController(_: UIViewController)

    public static func window(over: UIViewController) -> PresentationContext {
        return newWindow(over: over, at: nil)
    }
}

internal enum PresentationFashion {
    case window, viewControllerWindow, viewController
}
