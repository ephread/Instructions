// Copyright (c) 2021-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// A protocol that defines the pointer view of a coach mark,
/// colloquially known as an _arrow_ in Instructions' terminology.
public protocol CoachMarkPointer: UIView {
    /// The state of the view, specified as a bit mask value.
    ///
    /// If you don't need to support states in your coach marks, set
    /// ``CoachMarkContentView/shouldForwardStateChangeToPointer`` to false
    /// and set this property to `.normal`.
    ///
    /// ```swift
    /// class CoachMarkContentView: CoachMarkContent {
    ///     var nextControl: UIControl? { nil }
    ///     var shouldForwardStateChangeToPointer: Bool { false }
    /// }
    ///
    /// class CoachMarkPointerView: CoachMarkPointer {
    ///     var isHighlighted: Bool = false
    /// }
    /// ```
    var isHighlighted: Bool { get set }
}
