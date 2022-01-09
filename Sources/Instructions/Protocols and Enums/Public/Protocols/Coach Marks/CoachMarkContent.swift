// Copyright (c) 2021-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// A protocol that defines the content view of a Coach Mark.
public protocol CoachMarkContent: UIView {
    /// The control that triggers the next coach mark.
    ///
    /// Return `self` if the entire content view is interactable.
    var nextControl: UIControl? { get }

    /// Defines whether state forwarding is enabled for this view or not.
    ///
    /// If `true`, Instructions will automatically forwards any state change of
    /// ``nextControl`` to the arrow view. If `nextControl` returns `self`, then
    /// this property should likely return `true`.
    var onHighlight: ((Bool) -> Void)? { get set }
}
