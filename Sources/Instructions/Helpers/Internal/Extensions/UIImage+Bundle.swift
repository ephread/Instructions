// Copyright (c) 2016-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

extension UIImage {
    convenience init?(namedInInstructions: String) {
        self.init(named: namedInInstructions, in: Bundle(for: CoachMarkView.self),
                  compatibleWith: nil)
    }
}
