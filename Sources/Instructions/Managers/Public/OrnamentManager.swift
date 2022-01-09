// Copyright (c)  2021-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

public class OrnamentManager {
    private var configureOrnaments: ((_ overlay: UIView) -> Void)?

    private let overlayManager: OverlayManager

    init(overlayManager: OverlayManager) {
        self.overlayManager = overlayManager
    }

    public func configure(_ configure: @escaping (_ overlay: UIView) -> Void) {
        self.configureOrnaments = configure
    }

    internal func configure() {
        configureOrnaments?(overlayManager.overlayView.ornaments)
    }
}
