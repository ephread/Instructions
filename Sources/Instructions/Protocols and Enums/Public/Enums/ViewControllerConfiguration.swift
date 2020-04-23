// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// TODO: Remove the override once the bug is fixed.
// swiftlint:disable identifier_name

public enum RotationStyle {
    case systemDefined
    case automatic
    case manual
}

public enum StatusBarVisibility {
    case systemDefined
    case visible
    case hidden
}

public enum InterfaceOrientations {
    case systemDefined
    case userDefined(as: UIInterfaceOrientationMask)
}
