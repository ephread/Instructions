// Copyright (c) 2021-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// A protocol that defines a skipper view, e. g. a view that is always
/// displayed and allows the user to skip the tutorial.
public protocol TutorialSkipper: UIView {
    /// The control that skips the tutorial.
    ///
    /// Return `self` if the entire view is interactable.
    var control: UIControl? { get }
}
