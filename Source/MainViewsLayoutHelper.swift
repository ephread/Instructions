//
//  MainViewsLayoutHelper.swift
//  Instructions
//
//  Created by Frédéric Maquin on 07/08/16.
//  Copyright © 2016 Ephread. All rights reserved.
//

import Foundation

class MainViewsLayoutHelper {
    func fullSizeConstraintsForView(view: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[view]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["view": view]
        ))

        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[view]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["view": view]
        ))

        return constraints
    }
}
