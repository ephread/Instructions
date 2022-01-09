// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// The vertical alignment of the coach mark.
public enum ComputedVerticalPosition: Hashable {
    /// The coach mark should sit above the point of interest / cutout path.
    case above

    /// The coach mark should over point of interest / cutout path.
    case over

    /// The coach mark should sit below the point of interest / cutout path.
    case below

    init(position: VerticalPosition) {
        switch position {
        case .above: self = .above
        case .over, .automatic: self = .over
        case .below: self = .below
        }
    }
}

/// The vertical alignment of the coach mark.
public enum VerticalPosition: Hashable {
    /// The coach mark should sit above the point of interest / cutout path.
    case above

    /// The coach mark should over point of interest / cutout path.
    case over

    /// The coach mark should sit below the point of interest / cutout path.
    case below

    /// Depending on the available space, the coach mark should sit either above or below,
    /// but never over point of interest / cutout path.
    case automatic
}

@available(*, unavailable, renamed: "VerticalPosition")
typealias CoachMarkArrowOrientation = VerticalPosition
