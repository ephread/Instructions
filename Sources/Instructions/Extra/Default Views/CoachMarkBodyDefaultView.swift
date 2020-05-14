// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

// MARK: - Main Class
/// A concrete implementation of the coach mark body view and the
/// default one provided by the library.
public class CoachMarkBodyDefaultView: UIControl,
                                       CoachMarkBodyView {
    // MARK: Overriden Properties
    public override var isHighlighted: Bool {
        didSet {
            bodyBackground.isHighlighted = isHighlighted
            highlightArrowDelegate?.highlightArrow(isHighlighted)
        }
    }

    // MARK: Public Properties
    public var nextControl: UIControl? {
        return self
    }

    public lazy var nextLabel: UILabel = makeNextLabel()
    public lazy var hintLabel: UITextView = makeHintTextView()
    public lazy var separator: UIView = makeSeparator()

    public var background: CoachMarkBodyBackgroundStyle {
        get { return bodyBackground }
        set { bodyBackground.updateValues(from: newValue) }
    }

    // MARK: Delegates
    public weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate?

    // MARK: Private Properties
    private lazy var labelStackView: UIStackView = makeStackView()

    private var bodyBackground = CoachMarkBodyBackgroundView().preparedForAutoLayout()

    // MARK: - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initializeViewHierarchy()
    }

    public init(frame: CGRect, hintText: String, nextText: String?) {
        super.init(frame: frame)
        initializeViewHierarchy()

        separator.isHidden = (nextText == nil)
        nextLabel.isHidden = (nextText == nil)

        nextLabel.text = nextText
        hintLabel.text = hintText
    }

    convenience public init(hintText: String, nextText: String?) {
        self.init(frame: CGRect.zero, hintText: hintText, nextText: nextText)
    }

    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding.")
    }
}

// MARK: - Private Methods
private extension CoachMarkBodyDefaultView {
    func initializeViewHierarchy() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false

        initializeAccessibilityIdentifier()

        addSubview(bodyBackground)
        addSubview(labelStackView)

        bodyBackground.fillSuperview()
        labelStackView.fillSuperview(insets: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))

        labelStackView.addArrangedSubview(hintLabel)
        labelStackView.addArrangedSubview(separator)
        labelStackView.addArrangedSubview(nextLabel)

        separator.heightAnchor.constraint(equalTo: labelStackView.heightAnchor,
                                          constant: -10).isActive = true
    }

    func initializeAccessibilityIdentifier() {
        accessibilityIdentifier = AccessibilityIdentifiers.coachMarkBody
        nextLabel.accessibilityIdentifier = AccessibilityIdentifiers.coachMarkNext
        hintLabel.accessibilityIdentifier = AccessibilityIdentifiers.coachMarkHint
    }

    // MARK: Builders
    func makeHintTextView() -> UITextView {
        let textView = UITextView().preparedForAutoLayout()

        textView.layoutManager.hyphenationFactor = 1.0
        textView.textAlignment = .justified
        textView.textColor = InstructionsColor.coachMarkLabel
        textView.font = UIFont.systemFont(ofSize: 15.0)

        textView.backgroundColor = .clear

        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0

        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false

        textView.setContentCompressionResistancePriority(UILayoutPriority.required,
                                                         for: .horizontal)
        textView.setContentCompressionResistancePriority(UILayoutPriority.required,
                                                         for: .vertical)
        textView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        textView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)

        return textView
    }

    func makeNextLabel() -> UILabel {
        let label = UILabel().preparedForAutoLayout()

        label.textAlignment = .center
        label.textColor = InstructionsColor.coachMarkLabel
        label.font = UIFont.systemFont(ofSize: 17.0)

        label.isUserInteractionEnabled = false

        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        label.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)

        return label
    }

    func makeSeparator() -> UIView {
        let separator = UIView().preparedForAutoLayout()

        separator.backgroundColor = InstructionsColor.coachMarkLabel

        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true

        return separator
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView().preparedForAutoLayout()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.isUserInteractionEnabled = false
        stackView.alignment = .center

        return stackView
    }
}
