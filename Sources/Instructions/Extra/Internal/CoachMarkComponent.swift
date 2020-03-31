// Copyright (c)  2020-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

protocol CoachMarkComponent {
    var frame: CGRect { get set }
}

extension CoachMarkComponent {
    func makeInnerTrianglePath(orientation: CoachMarkArrowOrientation) -> CGPath {
        let path = CGMutablePath()

        if orientation == .top {
            path.move(to: CGPoint(x: 0, y: frame.height))
            path.addLine(to: CGPoint(x: frame.width / 2, y: 1))
            path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        } else {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: frame.width / 2, y: frame.height - 1))
            path.addLine(to: CGPoint(x: frame.width, y: 0))
        }

        path.closeSubpath()

        return path
    }

    func makeOuterTrianglePath(orientation: CoachMarkArrowOrientation) -> CGPath {
        let path = CGMutablePath()

        if orientation == .top {
            path.move(to: CGPoint(x: 0, y: frame.height - 1))
            path.addLine(to: CGPoint(x: frame.width / 2, y: 0))
            path.addLine(to: CGPoint(x: frame.width, y: frame.height - 1))
        } else {
            path.move(to: CGPoint(x: 0, y: 1))
            path.addLine(to: CGPoint(x: frame.width / 2, y: frame.height))
            path.addLine(to: CGPoint(x: frame.width, y: 1))
        }

        path.closeSubpath()

        return path
    }

    func makeInnerRoundedPath(cornerRadius: CGFloat) -> CGPath {
        let rect = frame.inset(by: UIEdgeInsets(top: 1, left: 1, bottom: 2, right: 1))
        let bezierPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        return bezierPath.cgPath
    }

    func makeOuterRoundedPath(cornerRadius: CGFloat) -> CGPath {
        let bezierPath = UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius)
        return bezierPath.cgPath
    }
}
