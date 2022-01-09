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

        if let hitView = hitView, (hitView == self || insertedViewsToIgnore.contains(hitView)) {
            return nil
        }

        return hitView
    }

    // On iPad Pros, since iOS 13, a blocking view is present in the UIKit
    // hierarchy. Here we're simply grabbing all these intermediate UIKit views
    // so that we can ignore them in hitTest.
    //
    // See #234 and https://forums.developer.apple.com/thread/122174
    var insertedViewsToIgnore: [UIView] {
        return recursiveSubviews(of: self)
    }

    func recursiveSubviews(of view: UIView) -> [UIView] {
        // We just hit the bottom.
        guard !(view is PassthroughView) && !(view is InstructionsRootView) else {
            return []
        }

        var subviews = view.subviews.filter {
            !($0 is PassthroughView) && !($0 is InstructionsRootView)
        }

        for subview in view.subviews {
            subviews.append(contentsOf: recursiveSubviews(of: subview))
        }

        return subviews
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
