// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// Delegate the highlight mechanism of the arrow. This protocol is
/// useful in case the whole body itself is the active control and
/// we want the arrow to looks like it is part of this control.
public protocol CoachMarkBodyHighlightArrowDelegate: AnyObject {

    /// Set whether or not the arrow should get in its
    /// highlighted state.
    ///
    /// - Parameters isHighlighted: `true` if the arrow should be highlighted, `false` otherwise.
    func highlightArrow(_ highlighted: Bool)
}
