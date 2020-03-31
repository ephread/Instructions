// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// MARK: - Main Class
/// A concrete implementation of the coach mark body view and the
/// default one provided by the library.
public class CoachMarkBodyDefaultView: UIControl,
                                       CoachMarkBodyView {
    // MARK: Public Properties
    public override var isHighlighted: Bool {
        didSet {
            bodyBackground.isHighlighted = isHighlighted
            highlightArrowDelegate?.highlightArrow(isHighlighted)
        }
    }

    public var nextControl: UIControl? {
        return self
    }

    public var nextLabel: UILabel { return views.nextLabel }
    public var hintLabel: UITextView { return views.hintLabel }
    public var background: CoachMarkBackground { return bodyBackground }

    public weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate?

    fileprivate var views = CoachMarkBodyDefaultViewHolder()

    private var bodyBackground: CoachMarkBodyBackground & UIView = CoachMarkBodyBackgroundView()

    // MARK: - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupAccessibilityIdentifier()

        let helper = CoachMarkBodyDefaultViewHelper()

        createInnerViewHierarchy(using: helper)
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
            createInnerViewHierarchy(using: helper)
        } else {
            views.hintLabel.text = hintText
            setupSimpleInnerViewHierarchy(using: helper)
        }
    }

    convenience public init(hintText: String, nextText: String?) {
        self.init(frame: CGRect.zero, hintText: hintText, nextText: nextText)
    }
}

// MARK: - Private Inner Hierarchy create
private extension CoachMarkBodyDefaultView {
    //Configure the CoachMark view with a hint message and a next message
    func createInnerViewHierarchy(using helper: CoachMarkBodyDefaultViewHelper) {
        translatesAutoresizingMaskIntoConstraints = false

        helper.configureBackground(bodyBackground, addTo: self)
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
        helper.configureBackground(bodyBackground, addTo: self)
        helper.configureSimpleHint(hintLabel, addTo: self)
    }

    func setupAccessibilityIdentifier() {
        accessibilityIdentifier = AccessibilityIdentifiers.coachMarkBody
    }
}

// MARK: - View Holder
private struct CoachMarkBodyDefaultViewHolder {
    let nextLabel: UILabel = {
        let nextLabel = UILabel()
        nextLabel.accessibilityIdentifier = AccessibilityIdentifiers.coachMarkNext
        return nextLabel
    }()

    let hintLabel: UITextView = {
        let nextLabel = UITextView()
        nextLabel.accessibilityIdentifier = AccessibilityIdentifiers.coachMarkHint
        return nextLabel
    }()

    let separator = UIView()
}
