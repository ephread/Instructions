// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// This class deals with the layout of the "skip" view.
public class SkippingManager {
    // MARK: - Public Properties
    public var view: TutorialSkipper? {
        willSet {
            view?.removeFromSuperview()
            view?.control?.removeTarget(self, action: #selector(didTapSkipControl),
                                        for: .touchUpInside)
        }

        didSet {
            guard view != nil else { return }
            addSkipView()
        }
    }

    @objc func didTapSkipControl() {

    }

    // MARK: - Internal Properties
    var presentationStyle: PresentationStyle = .separateWindow

    // MARK: - Private Properties
    private var configureSkipper: ((_ skipper: UIView) -> Void)?
    private let instructionsRootView: InstructionsRootView

    // MARK: - Initialization
    init(instructionsRootView: InstructionsRootView) {
        self.instructionsRootView = instructionsRootView
    }

    // MARK: - Public Methods
    public func configure(_ configure: @escaping (_ skipper: UIView) -> Void) {
        self.configureSkipper = configure
    }

    // MARK: - Internal Methods
    internal func configure() {
        guard let skipper = view else { return }

        skipper.removeFromSuperview()
        skipper.translatesAutoresizingMaskIntoConstraints = false

        instructionsRootView.addSubview(skipper)

        if let configureSkipper = configureSkipper {
            configureSkipper(skipper)
        } else {
            configureSkipperWithDefaultConstraints()
        }
    }

    /// Hide the given Skip View with a fading effect.
    ///
    /// - Parameter skipView: the skip view to hide.
    /// - Parameter duration: the duration of the fade.
    internal func hideSkipper(duration: TimeInterval = 0) {
        guard let view = view else { return }
        UIView.animate(withDuration: duration) {
            view.alpha = 0.0
        }
    }

    /// Show the given Skip View with a fading effect.
    ///
    /// - Parameter skipView: the skip view to show.
    /// - Parameter duration: the duration of the fade.
    internal func showSkipper(duration: TimeInterval = 0) {
        guard let view = view, view.superview != nil else {
            print(ErrorMessage.Info.skipViewNoSuperviewNotShown)
            return
        }

        view.superview?.bringSubviewToFront(view)

        UIView.animate(withDuration: duration) { () -> Void in
            view.alpha = 1.0
        }
    }

    // MARK: - Private Methods
    private func configureSkipperWithDefaultConstraints() {
        guard let skipper = view else { return }

        let trailingAnchor: NSLayoutXAxisAnchor
        if #available(iOS 11.0, *) {
            trailingAnchor = instructionsRootView.safeAreaLayoutGuide.trailingAnchor
        } else {
            trailingAnchor = instructionsRootView.trailingAnchor
        }

        var topConstant: CGFloat = 0.0
        let topAnchor: NSLayoutYAxisAnchor
        switch presentationStyle {
        case .separateWindow:
            if #available(iOS 11.0, *) {
                topAnchor = instructionsRootView.safeAreaLayoutGuide.topAnchor
            } else {
                topAnchor = instructionsRootView.topAnchor
                topConstant = updateTopConstant(from: topConstant)
            }
        case .sameWindow:
            if #available(iOS 11.0, *), let window = instructionsRootView.window,
               let safeAreaInsets = window.rootViewController?.view.safeAreaInsets {
                // For some reasons I don't fully understand, window.safeAreaInsets.top is
                // correctly set for the iPhone X, but not for other iPhones. That's why we
                // have this awkward "hack", whereby the top inset is added manually.
                topAnchor = instructionsRootView.topAnchor
                topConstant = safeAreaInsets.top
            } else {
                topAnchor = instructionsRootView.topAnchor
                topConstant = updateTopConstant(from: topConstant)
            }
        case .viewController:
            if #available(iOS 11.0, *) {
                topAnchor = instructionsRootView.safeAreaLayoutGuide.topAnchor
            } else {
                topAnchor = instructionsRootView.topAnchor
            }
        }

        topConstant += 2

        skipper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        skipper.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
    }

    private func updateTopConstant(from original: CGFloat) -> CGFloat {
        #if !INSTRUCTIONS_APP_EXTENSIONS
        let statusBarManager = UIApplication.shared.activeScene?.statusBarManager

        if let statusBarManager = statusBarManager, !statusBarManager.isStatusBarHidden {
            return statusBarManager.statusBarFrame.size.height
        }
        #endif
        return original
    }

    /// Add a the "Skip view" to the main view container.
    private func addSkipView() {
        guard let view = view else { return }

        view.alpha = 0.0
        view.control?.addTarget(self, action: #selector(didTapSkipControl), for: .touchUpInside)

        instructionsRootView.addSubview(view)
    }
}
