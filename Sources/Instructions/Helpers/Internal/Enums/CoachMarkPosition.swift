// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// Define the horizontal position of the coach mark.
enum CoachMarkPosition {
    var layoutAttribute: NSLayoutConstraint.Attribute {
        switch self {
        case .leading: return .leading
        case .center: return .centerX
        case .trailing: return .trailing
        }
    }

    case leading
    case center
    case trailing
}

/// Define the horizontal position of the arrow.
typealias ArrowPosition = CoachMarkPosition
