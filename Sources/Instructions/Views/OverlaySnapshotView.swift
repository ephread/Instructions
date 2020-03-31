// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

class OverlaySnapshotView: UIView {
    var visualEffectView: UIVisualEffectView! {
        willSet {
            if visualEffectView == nil { return }
            visualEffectView.removeFromSuperview()
        }

        didSet {
            if visualEffectView != nil {
                self.addSubview(visualEffectView)
            }
        }
    }
    var backgroundView: UIView! {
        willSet {
            if backgroundView == nil { return }
            backgroundView.removeFromSuperview()
        }

        didSet {
            if backgroundView != nil {
                self.addSubview(backgroundView)
            }
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}
