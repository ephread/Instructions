// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// A protocol to which all the "skip views" must conform.
public protocol CoachMarkSkipView: AnyObject {
    /// The control that will trigger the stop, in the display flow.
    var skipControl: UIControl? { get }
    var asView: UIView? { get }
}

public extension CoachMarkSkipView {
    var skipControl: UIControl? {
        return nil
    }
}

public extension CoachMarkSkipView where Self: UIView {
    var asView: UIView? {
        return self
    }
}
