//
//  OverlayViewController.swift
//  Instructions
//
//  Created by Frédéric Maquin on 27/09/15.
//  Copyright © 2015 Ephread. All rights reserved.
//

import Foundation

class OverlayViewController: NSObject {
    let overlayView: OverlayView

    private(set) var coachViewConstraint: [NSLayoutConstraint] = []
    private(set) var coachMarks: [CoachMark] = []
    private(set) var coachMarkViews: [CoachMarkView] = []

    //MARK: - Private properties
    private var overlayLayers: [CALayer] = []
    private var fullMaskLayers: [CAShapeLayer] = []

    private let backgroundView: UIView = {
        let backgroundView = UIView()

        backgroundView.translatesAutoresizingMaskIntoConstraints = false;
        backgroundView.backgroundColor = UIColor.clearColor()
        backgroundView.userInteractionEnabled = false;

        return backgroundView
        }()

    // MARK: - Public methods
    func prepareForFadeAnimation() {
        self.backgroundView.layer.opacity = 0.0
        self.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.65) //TODO: Let user choose color.
    }


    func reset() {
        self.coachMark = nil
        self.coachMarkView = nil

        self.backgroundView.layer.opacity = 1.0
        self.backgroundColor = UIColor.clearColor()
    }

    func respondtoChangeWithNewCoachMark() {

    }

    func addCoachMarkView(coachMarkView: CoachMarkView?) {
        guard coachMarkView = coachMarkView else {
            return
        }

        guard let coachView = newCoachMarkView else {
            return
        }

        self.addSubview(coachView)

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(10)-[coachView]-(10)-|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["coachView": coachView]))

        self.hintViewFromTopConstraint = NSLayoutConstraint(item: coachView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        self.hintViewFromBottomConstraint = NSLayoutConstraint(item: coachView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)

        self.addConstraint(self.hintViewFromTopConstraint!)
        self.addConstraint(self.hintViewFromBottomConstraint!)

        self.hintViewFromTopConstraint!.active = false
        self.hintViewFromBottomConstraint!.active = true
    }



    // - Private methods
    private func prepareForDisplay() {
        guard let coachMark = self.privateCoachMark else {
            return
        }

        if (coachMark.arrowCenterXPosition != nil) {
            self.coachMarkView?.changearrowOrientationTo(self.center.x - coachMark.arrowCenterXPosition!)
        }

        if let cutoutPath = coachMark.cutoutPath {
            if cutoutPath.bounds.origin.y > self.backgroundView.center.y {
                self.hintViewFromBottomConstraint?.constant = -(self.backgroundView.frame.size.height - cutoutPath.bounds.origin.y + 2)

                self.hintViewFromBottomConstraint?.active = true
                self.hintViewFromTopConstraint?.active = false
            } else {
                self.hintViewFromTopConstraint?.constant = (cutoutPath.bounds.origin.y + cutoutPath.bounds.size.height) + 2

                self.hintViewFromBottomConstraint?.active = false
                self.hintViewFromTopConstraint?.active = true
            }
        } else {

        }

        self.setNeedsUpdateConstraints()
    }
}