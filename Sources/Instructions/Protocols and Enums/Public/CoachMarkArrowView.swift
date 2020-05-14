// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// A protocol to which all the "arrow views" of a coach mark must conform.
public protocol CoachMarkArrowView: AnyObject {
    /// A method to change the arrow highlighted state.
    /// If you feel the arrow should mirror the state of the "body view",
    /// You will most likely change the background color of the view here.
    var isHighlighted: Bool { get set }
}
