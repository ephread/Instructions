// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

/// Will display coach marks on top of a blurred background.
internal class BlurringOverlayViewController: DefaultViewController {
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.coachMarksController.overlay.blurEffectStyle = .regular
    }
}
