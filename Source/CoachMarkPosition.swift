//
//  CoachMarkPosition.swift
//  Instructions
//
//  Created by Frédéric Maquin on 03/10/15.
//  Copyright © 2015 Ephread. All rights reserved.
//

import Foundation

/// Define the horizontal position of the coach mark.
enum CoachMarkPosition {
    case Leading
    case Center
    case Trailing
}

/// Define the horizontal position of the arrow.
typealias ArrowPosition = CoachMarkPosition