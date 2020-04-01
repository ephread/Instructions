// Copyright (c)  2020-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

public protocol CoachMarkBackgroundStyle {
    var innerColor: UIColor { mutating get set }
    var borderColor: UIColor { mutating get set }
    var highlightedInnerColor: UIColor { mutating get set }
    var highlightedBorderColor: UIColor { mutating get set }
}

public protocol CoachMarkBodyBackgroundStyle: CoachMarkBackgroundStyle {
    var isHighlighted: Bool { get set }
    var cornerRadius: CGFloat { get set }
}
