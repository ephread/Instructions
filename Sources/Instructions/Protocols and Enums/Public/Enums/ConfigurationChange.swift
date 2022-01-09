// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import Foundation

/// When the trait collection or the size change, Instructions is paused and
/// the coach marks currently on screen are redrawn. During this process,
/// certain delegate methods will be called again to make sure the coach
/// mark is up to date.
public enum ConfigurationChange {
    /// The size available to the app changed. This configuration change covers
    /// display rotations as well as size changes in a multitasking environment.
    case sizeChange

    /// The height of the status bar changed. For example, this might be the result
    /// of an incoming call in devices with a home button.
    case statusBarChange
}
