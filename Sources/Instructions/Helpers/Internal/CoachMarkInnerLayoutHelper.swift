// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

class CoachMarkInnerLayoutHelper {
    func makeHorizontalPointerConstraints(
        content: CoachMarkContent,
        pointer: CoachMarkPointer,
        alignment: HorizontalAlignment,
        offset: CGFloat
    ) -> NSLayoutConstraint {
        let adaptedOffset = self.adaptedOffset(for: alignment, offset: offset)
        return pointer.centerXAnchor.constraint(equalTo: content.centerXAnchor,
                                                constant: adaptedOffset)
    }

    func makeVerticalConstraints(
        content: CoachMarkContent,
        pointer: CoachMarkPointer,
        parent: UIView,
        position: ComputedVerticalPosition,
        offset: CGFloat
    ) -> [NSLayoutConstraint] {
        switch position {
        case .above:
            return makeAbovePositionConstraints(content: content, pointer: pointer,
                                                parent: parent, position: position,
                                                offset: offset)
        case .below:
            return makeBelowPositionConstraints(content: content, pointer: pointer,
                                                parent: parent, position: position,
                                                offset: offset)
        case .over:
            return []
        }
    }
}

private extension CoachMarkInnerLayoutHelper {
    func makeBelowPositionConstraints(
        content: CoachMarkContent,
        pointer: CoachMarkPointer,
        parent: UIView,
        position: ComputedVerticalPosition,
        offset: CGFloat
    ) -> [NSLayoutConstraint] {
        let offset = adaptedOffset(for: .below, offset: offset)

        return [
            pointer.bottomAnchor.constraint(equalTo: content.topAnchor, constant: offset),
            parent.topAnchor.constraint(equalTo: pointer.topAnchor),
            content.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ]
    }

    func makeAbovePositionConstraints(
        content: CoachMarkContent,
        pointer: CoachMarkPointer,
        parent: UIView,
        position: ComputedVerticalPosition,
        offset: CGFloat
    ) -> [NSLayoutConstraint] {
        let offset = adaptedOffset(for: .above, offset: offset)

        return [
            pointer.topAnchor.constraint(equalTo: content.bottomAnchor, constant: offset),
            parent.bottomAnchor.constraint(equalTo: pointer.bottomAnchor),
            content.topAnchor.constraint(equalTo: parent.topAnchor)
        ]
    }

    func adaptedOffset(for alignment: HorizontalAlignment, offset: CGFloat) -> CGFloat {
        switch alignment {
        case .leading: return offset
        case .center: return -offset
        case .trailing: return -offset
        }
    }

    func adaptedOffset(for position: ComputedVerticalPosition, offset: CGFloat) -> CGFloat {
        switch position {
        case .above:
            return -offset
        case .below:
            return offset
        case .over:
            return 0
        }
    }
}
