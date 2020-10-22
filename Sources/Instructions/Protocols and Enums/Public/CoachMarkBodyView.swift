// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// A protocol to which all the "body views" of a coach mark must conform.
public protocol CoachMarkBodyView: AnyObject {
    /// The control that will trigger the change between the current coach mark
    /// and the next one.
    var nextControl: UIControl? { get }

    /// A delegate to call, when the arrow view to mirror the current highlight
    /// state of the body view. This is useful in case the entire view is actually a `UIControl`.
    ///
    /// The `CoachMarkView`, of which the current view must be
    /// part, will automatically set itself as the delegate and will take care
    /// of forwarding the state to the arrow view.
    var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate? { get set }
}
