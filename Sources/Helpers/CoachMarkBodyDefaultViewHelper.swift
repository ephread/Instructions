// CoachMarkBodyDefaultViewHelper.swift
//
// Copyright (c) 2015, 2016 Frédéric Maquin <fred@ephread.com>
//                          Esteban Soto <esteban.soto.dev@gmail.com>
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

// swiftlint:disable line_length
//MARK: - Main Class
/// A concrete implementation of the coach mark body view and the
/// default one provided by the library.
public class CoachMarkBodyDefaultViewHelper {
    func horizontalConstraintsForSubViews(views: CoachMarkBodyDefaultSubViews)
    -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(10)-[hintLabel]-(10)-[separator(==1)][nextLabel(==55)]|",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: nil,
            views: ["hintLabel": views.hintLabel, "separator": views.separator,
                    "nextLabel": views.nextLabel]
        )
    }

    func verticalConstraintsForHint(hint: UITextView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(0)-[hint]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hint": hint]
        )
    }

    func configureBackground(background: UIView, addTo parent: UIView) {
        background.translatesAutoresizingMaskIntoConstraints = false
        background.userInteractionEnabled = false

        parent.addSubview(background)

        var constraints = [NSLayoutConstraint]()

        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[background]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["background": background])

        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[background]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["background": background])

        parent.addConstraints(constraints)
    }

    func configureHint(hint: UITextView, addTo parent: UIView) {
        hint.translatesAutoresizingMaskIntoConstraints = false
        hint.userInteractionEnabled = false
        hint.backgroundColor = UIColor.clearColor()
        hint.scrollEnabled = false

        configureHintTextProperties(hint)
        parent.addSubview(hint)
        parent.addConstraints(verticalConstraintsForHint(hint))
    }

    func configureSimpleHint(hint: UITextView, addTo parent: UIView) {
        configureHint(hint, addTo: parent)

        parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(5)-[hintLabel]-(5)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["hintLabel": hint]
        ))
    }

    func configureNext(next: UILabel, addTo parent: UIView) {
        next.translatesAutoresizingMaskIntoConstraints = false
        next.userInteractionEnabled = false

        configureNextTextProperties(next)

        parent.addSubview(next)

        parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[nextLabel]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["nextLabel": next]
        ))
    }

    func configureSeparator(separator: UIView, addTo parent: UIView) {
        separator.backgroundColor = UIColor.grayColor()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.userInteractionEnabled = false

        parent.addSubview(separator)

        parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(15)-[separator]-(15)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["separator": separator]
        ))
    }

    private func configureHintTextProperties(hint: UITextView) {
        hint.textColor = UIColor.whiteColor()
        hint.font = UIFont.systemFontOfSize(12.0)
        hint.textAlignment = .Justified
        hint.layoutManager.hyphenationFactor = 1.0
        hint.editable = false
    }

    private func configureNextTextProperties(next: UILabel) {
        next.textColor = UIColor.whiteColor()
        next.font = UIFont.systemFontOfSize(17.0)
        next.textAlignment = .Center
    }
}

typealias CoachMarkBodyDefaultSubViews =
    (hintLabel: UITextView, nextLabel: UILabel, separator: UIView)
