// Copyright (c)  2020-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

public protocol CoachMarkBackgroundStyle {
    var innerColor: UIColor { get set }
    var borderColor: UIColor { get set }
    var highlightedInnerColor: UIColor { get set }
    var highlightedBorderColor: UIColor { get set }
}

public protocol CoachMarkBodyBackgroundStyle: AnyObject, CoachMarkBackgroundStyle {
    var isHighlighted: Bool { get set }
    var cornerRadius: CGFloat { get set }
}
