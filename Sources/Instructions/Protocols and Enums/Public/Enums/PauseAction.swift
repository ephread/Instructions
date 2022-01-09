// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import Foundation

/// The action to undertake when pausing Instructions.
public enum PauseAction {
    /// Hides instructions, allowing the user to full interact
    /// with the content under it.
    case hideInstructions

    /// Hide the overlay, but keep the coach marks on screen.
    case hideOverlay

    /// Keep both the overlay and the coach marks on screen.
    /// This is the default behaviour.
    case doNothing

    // TODO: [MIGRATION] Remove
    @available(*, unavailable, renamed: "doNothing")
    case hideNothing
}
