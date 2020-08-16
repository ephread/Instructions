// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// This class deals with the layout of the "skip" view.
class SkipViewDisplayManager {
    // MARK: - Internal properties
    /// Datasource providing the constraints to use.
    weak var dataSource: CoachMarksControllerProxyDataSource?

    var presentationFashion: PresentationFashion = .window

    // MARK: - Private properties
    /// Constraints defining the position of the "Skip" view
    private var skipViewConstraints: [NSLayoutConstraint] = []

    // MARK: - Internal methods
    /// Hide the given Skip View with a fading effect.
    ///
    /// - Parameter skipView: the skip view to hide.
    /// - Parameter duration: the duration of the fade.
    func hide(skipView: (UIView & CoachMarkSkipView), duration: TimeInterval = 0) {
        if duration == 0 {
            skipView.asView?.alpha = 0.0
        } else {
            UIView.animate(withDuration: duration) { () -> Void in
                skipView.asView?.alpha = 0.0
            }
        }
    }

    /// Show the given Skip View with a fading effect.
    ///
    /// - Parameter skipView: the skip view to show.
    /// - Parameter duration: the duration of the fade.
    func show(skipView: (UIView & CoachMarkSkipView), duration: TimeInterval = 0) {
        guard let parentView = skipView.asView?.superview else {
            print(ErrorMessage.Info.skipViewNoSuperviewNotShown)
            return
        }

        let constraints = self.dataSource?.constraintsForSkipView(skipView.asView!,
                                                                  inParent: parentView)

        update(skipView: skipView, withConstraints: constraints)

        skipView.asView?.superview?.bringSubviewToFront(skipView.asView!)

        if duration == 0 {
            skipView.asView?.alpha = 1.0
        } else {
            UIView.animate(withDuration: duration) { () -> Void in
                skipView.asView?.alpha = 1.0
            }
        }
    }

    /// Update the constraints defining the location of given s view.
    ///
    /// - Parameter skipView: the skip view to position.
    /// - Parameter constraints: the constraints to use.
    func update(skipView: (UIView & CoachMarkSkipView),
                withConstraints constraints: [NSLayoutConstraint]?) {
        guard let parentView = skipView.asView?.superview else {
            print(ErrorMessage.Info.skipViewNoSuperviewNotUpdated)
            return
        }

        skipView.asView?.translatesAutoresizingMaskIntoConstraints = false
        parentView.removeConstraints(self.skipViewConstraints)

        self.skipViewConstraints = []

        if let constraints = constraints {
            self.skipViewConstraints = constraints
        } else {
            self.skipViewConstraints = defaultConstraints(for: skipView, in: parentView)
        }

        parentView.addConstraints(self.skipViewConstraints)
    }

    private func defaultConstraints(for skipView: (UIView & CoachMarkSkipView), in parentView: UIView)
    -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        let trailingAnchor: NSLayoutXAxisAnchor
        if #available(iOS 11.0, *) {
            trailingAnchor = parentView.safeAreaLayoutGuide.trailingAnchor
        } else {
            trailingAnchor = parentView.trailingAnchor
        }

        constraints.append(skipView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                              constant: -10))

        var topConstant: CGFloat = 0.0
        let topAnchor: NSLayoutYAxisAnchor

        switch presentationFashion {
        case .window:
            if #available(iOS 11.0, *) {
                topAnchor = parentView.safeAreaLayoutGuide.topAnchor
            } else {
                topAnchor = parentView.topAnchor
                topConstant = updateTopConstant(from: topConstant)
            }
        case .viewControllerWindow:
            if #available(iOS 11.0, *), let window = parentView.window,
               let safeAreaInsets = window.rootViewController?.view.safeAreaInsets {
                // For some reasons I don't fully understand, window.safeAreaInsets.top is correctly
                // set for the iPhone X, but not for other iPhones. That's why we have this
                // awkward "hack", whereby the top inset is added manually.
                topAnchor = parentView.topAnchor
                topConstant = safeAreaInsets.top
            } else {
                topAnchor = parentView.topAnchor
                topConstant = updateTopConstant(from: topConstant)
            }
        case .viewController:
            if #available(iOS 11.0, *) {
                topAnchor = parentView.safeAreaLayoutGuide.topAnchor
            } else {
                topAnchor = parentView.topAnchor
            }
        }

        topConstant += 2

        constraints.append(skipView.topAnchor.constraint(equalTo: topAnchor,
                                                         constant: topConstant))

        return constraints
    }

    func updateTopConstant(from original: CGFloat) -> CGFloat {
#if !INSTRUCTIONS_APP_EXTENSIONS
        if !UIApplication.shared.isStatusBarHidden {
            return UIApplication.shared.statusBarFrame.size.height
        }
#endif

        return original
    }
}
