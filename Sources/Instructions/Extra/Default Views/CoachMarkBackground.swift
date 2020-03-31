// Copyright (c)  2020-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

public protocol CoachMarkBackground {
    var innerColor: UIColor { mutating get set }
    var borderColor: UIColor { mutating get set }
    var highlightedInnerColor: UIColor { mutating get set }
    var highlightedBorderColor: UIColor { mutating get set }
}

public protocol CoachMarkBodyBackground: CoachMarkBackground {
    var isHighlighted: Bool { get set }
    var cornerRadius: CGFloat { get set }
}

extension CoachMarkBackground {
    func makeInnerColor() -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                if traits.userInterfaceStyle == .light {
                    return .white
                } else {
                    return .systemGroupedBackground
                }
            }
        } else {
            return .white
        }
    }

    func makeHighlightedInnerColor() -> UIColor {
        let defaultColor = UIColor(displayP3Red: 242.0 / 255.0,
                                   green: 242.0 / 255.0,
                                   blue: 242.0 / 255.0,
                                   alpha: 1.0)

        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                if traits.userInterfaceStyle == .light {
                    return defaultColor
                } else {
                    return UIColor(displayP3Red: 13.0 / 255.0,
                                   green: 13.0 / 255.0,
                                   blue: 13.0 / 255.0,
                                   alpha: 1.0)
                }
            }
        } else {
            return defaultColor
        }
    }

    func makeBorderColor() -> UIColor {
        let defaultColor = UIColor(displayP3Red: 227.0 / 255.0,
                                   green: 227.0 / 255.0,
                                   blue: 227.0 / 255.0,
                                   alpha: 1.0)

        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                if traits.userInterfaceStyle == .light {
                    return defaultColor
                } else {
                    return UIColor(displayP3Red: 28.0 / 255.0,
                                   green: 28.0 / 255.0,
                                   blue: 28.0 / 255.0,
                                   alpha: 1.0)
                }
            }
        } else {
            return defaultColor
        }
    }
}
