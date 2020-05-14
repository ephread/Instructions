// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit
import Instructions

// Custom coach mark body (with the secret-like arrow)
internal class CustomCoachMarkArrowView: UIView, CoachMarkArrowView {
    // MARK: - Internal properties
    var topPlateImage = UIImage(named: "coach-mark-top-plate")
    var bottomPlateImage = UIImage(named: "coach-mark-bottom-plate")
    var plate = UIImageView()

    var isHighlighted: Bool = false

    // MARK: - Private properties
    private var column = UIView()

    // MARK: - Initialization
    init(orientation: CoachMarkArrowOrientation) {
        super.init(frame: CGRect.zero)

        if orientation == .top {
            self.plate.image = topPlateImage
        } else {
            self.plate.image = bottomPlateImage
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        self.column.translatesAutoresizingMaskIntoConstraints = false
        self.plate.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(plate)
        self.addSubview(column)

        plate.backgroundColor = UIColor.clear
        column.backgroundColor = UIColor.white

        plate.fillSuperviewHorizontally()
        NSLayoutConstraint.activate([
            column.widthAnchor.constraint(equalToConstant: 3),
            column.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        if orientation == .top {
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[plate(==5)][column(==10)]|",
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                    metrics: nil,
                    views: ["plate": plate, "column": column]
                )
            )
        } else {
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[column(==10)][plate(==5)]|",
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                    metrics: nil,
                    views: ["plate": plate, "column": column]
                )
            )
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }
}
