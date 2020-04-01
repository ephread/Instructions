// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// MARK: - Main Class
/// A concrete implementation of the coach mark body view and the
/// default one provided by the library.
open class CoachMarkBodyDefaultViewHelper {
    func makeHorizontalConstraints(for views: CoachMarkBodyDefaultSubViews)
    -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(10)-[hintLabel]-(10)-[separator(==1)][nextLabel(==55)]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil,
            views: ["hintLabel": views.hintLabel,
                    "separator": views.separator,
                    "nextLabel": views.nextLabel]
        )
    }

    func makeVerticalConstraints(for hint: UITextView) -> [NSLayoutConstraint] {
        guard let superview = hint.superview else { return [] }

        return [
            hint.topAnchor.constraint(equalTo: superview.topAnchor, constant: 5),
            superview.bottomAnchor.constraint(equalTo: hint.bottomAnchor, constant: 5)
        ]
    }

    func configureBackground(_ background: UIView, addTo parent: UIView) {
        background.translatesAutoresizingMaskIntoConstraints = false
        background.isUserInteractionEnabled = false

        parent.addSubview(background)
        background.fillSuperview()
    }

    func configureHint(_ hint: UITextView, addTo parent: UIView) {
        hint.translatesAutoresizingMaskIntoConstraints = false
        hint.isUserInteractionEnabled = false
        hint.backgroundColor = UIColor.clear
        hint.isScrollEnabled = false

        configureTextPropertiesOfHint(hint)
        parent.addSubview(hint)
        parent.addConstraints(makeVerticalConstraints(for: hint))
    }

    func configureSimpleHint(_ hint: UITextView, addTo parent: UIView) {
        configureHint(hint, addTo: parent)

        hint.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 10).isActive = true
        parent.trailingAnchor.constraint(equalTo: hint.trailingAnchor, constant: 10).isActive = true
    }

    func configureNext(_ next: UILabel, addTo parent: UIView) {
        next.translatesAutoresizingMaskIntoConstraints = false
        next.isUserInteractionEnabled = false

        configureTextPropertiesOfNext(next)

        parent.addSubview(next)
        next.fillSuperviewVertically()
    }

    func configureSeparator(_ separator: UIView, addTo parent: UIView) {
        separator.backgroundColor = UIColor.gray
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.isUserInteractionEnabled = false

        parent.addSubview(separator)

        separator.topAnchor.constraint(equalTo: parent.topAnchor,
                                       constant: 15).isActive = true
        parent.bottomAnchor.constraint(equalTo: separator.bottomAnchor,
                                       constant: 15).isActive = true
    }

    private func configureTextPropertiesOfHint(_ hint: UITextView) {
        hint.textColor = InstructionsColor.coachMarkLabel
        hint.font = UIFont.systemFont(ofSize: 15.0)
        hint.textAlignment = .justified
        hint.layoutManager.hyphenationFactor = 1.0
        hint.isEditable = false
    }

    private func configureTextPropertiesOfNext(_ next: UILabel) {
        next.textColor = InstructionsColor.coachMarkLabel
        next.font = UIFont.systemFont(ofSize: 17.0)
        next.textAlignment = .center
    }
}

typealias CoachMarkBodyDefaultSubViews =
    (hintLabel: UITextView, nextLabel: UILabel, separator: UIView)
