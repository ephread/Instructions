// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

public enum InterfaceOrientationBehavior {
    case systemDefined
    case userDefined(as: UIInterfaceOrientationMask)
}
