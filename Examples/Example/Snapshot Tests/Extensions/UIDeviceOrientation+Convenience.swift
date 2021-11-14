// Copyright (c)  2021-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

extension UIDeviceOrientation {
    var isLandscape: Bool { [.landscapeLeft, .landscapeRight].contains(self) }
    var isPortrait: Bool { [.portrait, .portraitUpsideDown, .unknown].contains(self) }
}
