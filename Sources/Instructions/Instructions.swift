// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

struct Constants {
    static let overlayFadeAnimationDuration: TimeInterval = 0.3
    static let coachMarkFadeAnimationDuration: TimeInterval = 0.3
}

struct InstructionsColor {
    static let overlay: UIColor = {
        let defaultColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 0.65)

        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                if traits.userInterfaceStyle == .dark {
                    return #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 0.75)
                } else {
                    return defaultColor
                }
            }
        } else {
            return defaultColor
        }
    }()

    static let coachMarkInner: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                if traits.userInterfaceStyle == .dark {
                    let lightTraits = UITraitCollection(userInterfaceStyle: .light)
                    return UIColor.systemGray4.resolvedColor(with: lightTraits)
                } else {
                    return .white
                }
            }
        } else {
            return .white
        }
    }()

    static let coachMarkHighlightedInner: UIColor = {
        let defaultColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)

        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                if traits.userInterfaceStyle == .dark {
                    let lightTraits = UITraitCollection(userInterfaceStyle: .light)
                    return UIColor.systemGray2.resolvedColor(with: lightTraits)
                } else {
                    return defaultColor
                }
            }
        } else {
            return defaultColor
        }
    }()

    static let coachMarkOuter: UIColor = {
        let defaultColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)

        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                if traits.userInterfaceStyle == .dark {
                    return .systemGray
                } else {
                    return defaultColor
                }
            }
        } else {
            return defaultColor
        }
    }()

    static let coachMarkLabel: UIColor = {
        let defaultColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)

        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                if traits.userInterfaceStyle == .dark {
                    return .black
                } else {
                    return defaultColor
                }
            }
        } else {
            return defaultColor
        }
    }()
}
