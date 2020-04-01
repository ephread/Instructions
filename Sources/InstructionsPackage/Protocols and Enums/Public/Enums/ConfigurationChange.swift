// Copyright (c) 2018-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import Foundation

/// Define the type of change involved during a configuration change.
public enum ConfigurationChange {
    case nothing, size, statusBar
}
