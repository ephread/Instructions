// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// A compound element containing the two views necessary to build a coach mark.
public protocol CoachMarkViewComponents {
    /// The content of the coach also known as its _body_.
    var content: CoachMarkContent { get }

    /// The pointer of the coach also known as its _arrow_.
    ///
    /// Pointers are an optional feature.
    var pointer: CoachMarkPointer? { get }
}

public struct CoachMarkDefaultViewComponents: CoachMarkViewComponents {
    public let contentView: DefaultCoachMarkContentView
    public let pointerView: DefaultCoachMarkPointerView?

    public var content: CoachMarkContent { contentView }
    public var pointer: CoachMarkPointer? { pointerView }

    init(content: DefaultCoachMarkContentView, pointer: DefaultCoachMarkPointerView?) {
        contentView = content
        pointerView = pointer
    }
}

struct InternalCoachMarkViewComponents: CoachMarkViewComponents {
    let content: CoachMarkContent
    let pointer: CoachMarkPointer?
}
