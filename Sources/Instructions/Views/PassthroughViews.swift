// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

class InstructionsWindow: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityIdentifier = AccessibilityIdentifiers.window
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        accessibilityIdentifier = AccessibilityIdentifiers.window
    }

    @available(iOS 13.0, *)
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        accessibilityIdentifier = AccessibilityIdentifiers.window
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        if hitView == self {
            return nil
        }

        return hitView
    }
}

class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        if hitView == self {
            return nil
        }

        return hitView
    }
}

/// Top view added to the window, forwarding touch events.
class InstructionsRootView: UIView {

    var passthrough: Bool = false

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        if hitView == self && passthrough {
            return nil
        }

        return hitView
    }
}
