// CoachMarkBodyDefaultViewHelper.swift
//
// Copyright (c) 2015 - 2017 Frédéric Maquin <fred@ephread.com>
//                           Esteban Soto <esteban.soto.dev@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

// MARK: - Main Class
/// A concrete implementation of the coach mark body view and the
/// default one provided by the library.
open class CoachMarkBodyDefaultViewHelper {
    func makeHorizontalConstraints(for views: CoachMarkBodyDefaultSubViews)
    -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(10)-[hintLabel]-(10)-[separator(==1)][nextLabel(==55)]|",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: nil,
            views: ["hintLabel": views.hintLabel, "separator": views.separator,
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
        hint.textColor = UIColor.darkGray
        hint.font = UIFont.systemFont(ofSize: 15.0)
        hint.textAlignment = .justified
        hint.layoutManager.hyphenationFactor = 1.0
        hint.isEditable = false
    }

    private func configureTextPropertiesOfNext(_ next: UILabel) {
        next.textColor = UIColor.darkGray
        next.font = UIFont.systemFont(ofSize: 17.0)
        next.textAlignment = .center
    }
}

typealias CoachMarkBodyDefaultSubViews =
    (hintLabel: UITextView, nextLabel: UILabel, separator: UIView)
