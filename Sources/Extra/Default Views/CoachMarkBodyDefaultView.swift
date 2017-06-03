// CoachMarkBodyDefaultView.swift
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

// MARK: - Main Class
/// A concrete implementation of the coach mark body view and the
/// default one provided by the library.
public class CoachMarkBodyDefaultView: UIControl, CoachMarkBodyView {
    // MARK: - Public properties
    override public var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.views.backgroundImageView.image = self.views.highlightedBackgroundImage
            } else {
                self.views.backgroundImageView.image = self.views.backgroundImage
            }

            self.highlightArrowDelegate?.highlightArrow(self.isHighlighted)
        }
    }

    public var nextControl: UIControl? {
        return self
    }

    public var nextLabel: UILabel { return views.nextLabel }
    public var hintLabel: UITextView { return views.hintLabel }

    public weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate?

    fileprivate var views = CoachMarkBodyDefaultViewHolder()

    // MARK: - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)

        let helper = CoachMarkBodyDefaultViewHelper()

        self.setupInnerViewHierarchy(using: helper)
    }

    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }

    public init(frame: CGRect, hintText: String, nextText: String?) {
        super.init(frame: frame)

        let helper = CoachMarkBodyDefaultViewHelper()

        if let next = nextText {
            views.hintLabel.text = hintText
            views.nextLabel.text = next
            setupInnerViewHierarchy(using: helper)
        } else {
            views.hintLabel.text = hintText
            setupSimpleInnerViewHierarchy(using: helper)
        }
    }

    convenience public init(hintText: String, nextText: String?) {
        self.init(frame: CGRect.zero, hintText: hintText, nextText: nextText)
    }
}

// MARK: - Private Inner Hierarchy Setup
private extension CoachMarkBodyDefaultView {
    //Configure the CoachMark view with a hint message and a next message
    func setupInnerViewHierarchy(using helper: CoachMarkBodyDefaultViewHelper) {
        translatesAutoresizingMaskIntoConstraints = false

        helper.configureBackground(self.views.backgroundImageView, addTo: self)
        helper.configureHint(hintLabel, addTo: self)
        helper.configureNext(nextLabel, addTo: self)
        helper.configureSeparator(self.views.separator, addTo: self)

        let views = (hintLabel: self.views.hintLabel, nextLabel: self.views.nextLabel,
                     separator: self.views.separator)

        self.addConstraints(helper.makeHorizontalConstraints(for: views))
    }

    func setupSimpleInnerViewHierarchy(using helper: CoachMarkBodyDefaultViewHelper) {
        translatesAutoresizingMaskIntoConstraints = false

        let helper = CoachMarkBodyDefaultViewHelper()

        helper.configureBackground(self.views.backgroundImageView, addTo: self)
        helper.configureSimpleHint(hintLabel, addTo: self)
    }
}

// MARK: - View Holder
private struct CoachMarkBodyDefaultViewHolder {
    let nextLabel = UILabel()
    let hintLabel = UITextView()
    let separator = UIView()

    lazy var backgroundImageView: UIImageView = {
        return UIImageView(image: self.backgroundImage)
    }()

    let backgroundImage = UIImage(namedInInstructions: "background")
    let highlightedBackgroundImage = UIImage(namedInInstructions: "background-highlighted")

    init() { }
}
