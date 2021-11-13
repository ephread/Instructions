// Copyright (c) 2017-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import Foundation
import Instructions

class InstructionsNavigationController: UINavigationController {
    var isLocked = false

    override var shouldAutorotate: Bool {
        return !isLocked
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return isLocked ? .portrait : .all
    }
}
