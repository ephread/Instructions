// CoachMarksController.swift
//
// Copyright (c) 2015 Frédéric Maquin <fred@ephread.com>
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

/// Handles a set of coach marks, and display them successively.
public class CoachMarksController: UIViewController, OverlayViewDelegate {
    //MARK: - Public properties

    /// `true` if coach marks are curently being displayed, `false` otherwise.
    public var started: Bool {
        return currentIndex != -1
    }

    /// An object implementing the data source protocol and supplying the coach marks to display.
    public weak var datasource: CoachMarksControllerDataSource?

    /// An object implementing the delegate data source protocol, which methods will be called at various points.
    public weak var delegate: CoachMarksControllerDelegate?

    /// Overlay fade animation duration
    public var overlayFadeAnimationDuration = kOverlayFadeAnimationDuration

    /// Background color of the overlay.
    public var overlayBackgroundColor: UIColor {
        get {
            return self.overlayView.overlayColor
        }

        set {
            self.overlayView.overlayColor = newValue
        }
    }

    /// Blur effect style for the overlay view. Keeping this property
    /// `nil` will disable the effect. This property
    /// is mutually exclusive with `overlayBackgroundColor`.
    public var overlayBlurEffectStyle: UIBlurEffectStyle? {
        get {
            return self.overlayView.blurEffectStyle
        }

        set {
            self.overlayView.blurEffectStyle = newValue
        }
    }

    /// `true` to let the overlay catch tap event and forward them to the
    /// CoachMarkController, `false` otherwise.
    /// After receiving a tap event, the controller will show the next coach mark.
    public var allowOverlayTap: Bool {
        get {
            return self.overlayView.allowOverlayTap
        }

        set {
            self.overlayView.allowOverlayTap = newValue
        }
    }

    //MARK: - Private properties

    /// The total number of coach marks, supplied by the `datasource`.
    private var numberOfCoachMarks = 0;

    /// The index (in `coachMarks`) of the coach mark being currently displayed.
    private var currentIndex = -1;

    /// Reference to the currently displayed coach mark, supplied by the `datasource`.
    private var currentCoachMark: CoachMark?

    /// Reference to the currently displayed coach mark, supplied by the `datasource`.
    private var currentCoachMarkView: CoachMarkView?

    /// The overlay view dim the background, handle the cutout path
    /// showing the point of interest and also show up the coach marks themselve.
    private lazy var overlayView: OverlayView = {
        var overlayView = OverlayView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.delegate = self

        return overlayView
    }()

    /// Sometimes, the chain of coach mark display can be paused
    /// to let animations be performed. `true` to pause the execution,
    /// `false` otherwise.
    private var paused = false

    //MARK: - View lifecycle

    // Called after the view was loaded.
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.translatesAutoresizingMaskIntoConstraints = false;

        self.addOverlayView()
    }

    //MARK: - Public methods

    /// Start displaying the coach marks.
    public func startOn(parentViewController: UIViewController) {
        guard let datasource = self.datasource else {
            print("Snap! You didn't setup any datasource, the coach mark manager won't do anything.")
            return
        }

        // If coach marks are currently being displayed, calling `start()` doesn't do anything.
        if (self.started) { return }

        self.attachToViewController(parentViewController)

        // We make sure we are in a idle state and get the number of coach marks to display
        // from the datasource.
        self.currentIndex = -1;
        self.numberOfCoachMarks = datasource.numberOfCoachMarksForCoachMarksController(self)

        // The view was previously hidden, to prevent it from catching the user input.
        // Now, we want exactly the opposite. We want the overlay view to prevent events
        // from reaching down.
        self.view.userInteractionEnabled = true

        self.overlayView.prepareForFade()
        UIView.animateWithDuration(self.overlayFadeAnimationDuration, animations: { () -> Void in
            self.overlayView.alpha = 1.0
        }, completion: { (finished: Bool) -> Void in
            self.showNextCoachMark()
        })
    }

    /// Stop displaying the coach marks and perform some cleanup.
    public func stop() {
        UIView.animateWithDuration(self.overlayFadeAnimationDuration, animations: { () -> Void in
            self.overlayView.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
            self.reset()
            self.detachFromViewController()

            // Calling the delegate, maybe the user wants to do something?
            self.delegate?.didFinishShowingFromCoachMarksController(self)

        })
    }

    //MARK: - Protocol Conformance | OverlayViewDelegate

    internal func didReceivedSingleTap() {
        if self.paused { return }

        self.showNextCoachMark();
    }

    /// Will be called when the user perform an action requiring the display of the next coach mark.
    ///
    /// - Parameter sender: the object sending the message
    public func performShowNextCoachMark(sender:AnyObject?) {
        self.showNextCoachMark();
    }

    //MARK: - Private methods

    /// Show the next coach mark and hide the current one.
    private func showNextCoachMark() {
        self.currentIndex++

        // if `currentIndex` is above 0, that means a previous coach mark
        // is displayed. We call the delegate to notify that the current coach
        // mark will disappear, and only then, we hide the coach mark.
        if self.currentIndex > 0 {
            self.delegate?.coachMarksController(self, coachMarkWillDisappear: self.currentCoachMark!, forIndex: self.currentIndex - 1)

            self.overlayView.hideCutoutPathViewWithAnimationDuration(self.currentCoachMark!.animationDuration)

            UIView.animateWithDuration(self.currentCoachMark!.animationDuration, animations: { () -> Void in
                self.currentCoachMarkView?.alpha = 0.0
            }, completion: {(finished: Bool) -> Void in
                self.currentCoachMarkView?.removeFromSuperview()
                self.currentCoachMarkView?.nextControl?.removeTarget(self, action: "performShowNextCoachMark:", forControlEvents: .TouchUpInside)

                if self.currentIndex < self.numberOfCoachMarks {
                    self.retrieveCoachMarkFromDataSource()
                } else {
                    self.stop()
                }
            })
        } else {
            self.retrieveCoachMarkFromDataSource()
        }
    }

    /// Will attach the controller as a child of the given view controller. This will
    /// allow the coach mark controller to part of UIKit chain.
    ///
    /// - Parameter parentViewController: the controller of which become a child
    public func attachToViewController(parentViewController: UIViewController) {
        parentViewController.addChildViewController(self)
        parentViewController.view.addSubview(self.view)

        parentViewController.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[overlayView]|", options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil, views: ["overlayView": self.view]))

        parentViewController.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[overlayView]|", options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil, views: ["overlayView": self.view]))

        self.beginAppearanceTransition(true, animated: false)
        self.endAppearanceTransition()

        self.didMoveToParentViewController(parentViewController)
    }

    /// Detach the controller from its parent view controller.
    public func detachFromViewController() {
        self.beginAppearanceTransition(false, animated: false)
        self.endAppearanceTransition()

        self.willMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

    /// Returns a new coach mark with a cutout path set to be
    /// around the provided UIView. The cutout path will be slightly
    /// larger than the view and have rounded corners, however you can
    /// bypass the default creator by providing a block.
    ///
    /// The point of interest (defining where the arrow will sit, horizontally)
    /// will be set at the center of the cutout path.
    ///
    /// - Parameters view: the view around which create the cutoutPath
    /// - Parameters bezierPathBlock: a block customizing the cutoutPath
    public func coachMarkForView(view: UIView? = nil, bezierPathBlock: ((frame: CGRect) -> UIBezierPath)? = nil) -> CoachMark {
        return self.coachMarkForView(view, pointOfInterest: nil, bezierPathBlock: bezierPathBlock)
    }

    /// Returns a new coach mark with a cutout path set to be
    /// around the provided UIView. The cutout path will be slightly
    /// larger than the view and have rounded corners, however you can
    /// bypass the default creator by providing a block.
    ///
    /// The point of interest (defining where the arrow will sit, horizontally)
    /// will be the one provided.
    ///
    /// - Parameters view: the view around which create the cutoutPath
    /// - Parameters pointOfInterest: the point of interest toward which the arrow should point
    /// - Parameters bezierPathBlock: a block customizing the cutoutPath
    public func coachMarkForView(view: UIView? = nil, pointOfInterest: CGPoint?, bezierPathBlock: ((frame: CGRect) -> UIBezierPath)? = nil) -> CoachMark {
        var coachMark = CoachMark()

        guard let view = view else {
            return coachMark
        }

        self.updateCoachMark(&coachMark, forView: view, pointOfInterest: pointOfInterest, bezierPathBlock: bezierPathBlock)

        return coachMark
    }

    /// Updates the currently stored coach mark with a cutout path set to be
    /// around the provided UIView. The cutout path will be slightly
    /// larger than the view and have rounded corners, however you can
    /// bypass the default creator by providing a block.
    ///
    /// The point of interest (defining where the arrow will sit, horizontally)
    /// will be the one provided.
    ///
    /// This method is expected to be used in the delegate, after pausing the display.
    /// Otherwise, there might not be such a thing as a "current coach mark".
    ///
    /// - Parameters view: the view around which create the cutoutPath
    /// - Parameters pointOfInterest: the point of interest toward which the arrow should point
    /// - Parameters bezierPathBlock: a block customizing the cutoutPath
    public func updateCurrentCoachMarkForView(view: UIView? = nil, pointOfInterest: CGPoint? = nil, bezierPathBlock: ((frame: CGRect) -> UIBezierPath)? = nil) -> Void {
        if !self.paused || self.currentCoachMark == nil {
            print("Something is wrong, did you called updateCurrentCoachMarkForView without pausing the controller first?")
            return
        }

        self.updateCoachMark(&self.currentCoachMark!, forView: view, pointOfInterest: pointOfInterest, bezierPathBlock: bezierPathBlock)
    }

    /// Updates the given coach mark with a cutout path set to be
    /// around the provided UIView. The cutout path will be slightly
    /// larger than the view and have rounded corners, however you can
    /// bypass the default creator by providing a block.
    ///
    /// The point of interest (defining where the arrow will sit, horizontally)
    /// will be the one provided.
    ///
    /// - Parameters coachMark: the CoachMark to update
    /// - Parameters view: the view around which create the cutoutPath
    /// - Parameters pointOfInterest: the point of interest toward which the arrow should point
    /// - Parameters bezierPathBlock: a block customizing the cutoutPath
    public func updateCoachMark(inout coachMark: CoachMark, forView view: UIView? = nil, pointOfInterest: CGPoint?, bezierPathBlock: ((frame: CGRect) -> UIBezierPath)? = nil) -> Void {

        guard let view = view else {
            return
        }

        let convertedFrame = self.view.convertRect(view.frame, fromView:view.superview);

        var bezierPath: UIBezierPath;

        if let bezierPathBlock = bezierPathBlock {
            bezierPath = bezierPathBlock(frame: convertedFrame)
        } else {
            bezierPath = UIBezierPath(roundedRect: CGRectInset(convertedFrame, -4, -4), byRoundingCorners: .AllCorners, cornerRadii: CGSize(width: 4, height: 4))
        }

        coachMark.cutoutPath = bezierPath

        if let pointOfInterest = pointOfInterest {
            let convertedPoint = self.view.convertPoint(pointOfInterest, fromView:view.superview);
            coachMark.pointOfInterest = convertedPoint
        }
    }

    /// Provides default coach views.
    ///
    /// - Parameter withArrow: `true` to return an instance of `CoachMarkArrowDefaultView` as well, `false` otherwise.
    /// - Parameter arrowOrientation: orientation of the arrow (either .Top or .Bottom)
    ///
    /// - Returns: new instances of the default coach views.
    public func defaultCoachViewsWithArrow(withArrow: Bool = true, arrowOrientation: CoachMarkArrowOrientation? = .Top) -> (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?) {

        let coachMarkBodyView = CoachMarkBodyDefaultView()

        var coachMarkArrowView: CoachMarkArrowDefaultView? = nil

        if withArrow {
            var arrowOrientation = arrowOrientation

            if arrowOrientation == nil {
                arrowOrientation = .Top
            }

            coachMarkArrowView = CoachMarkArrowDefaultView(orientation: arrowOrientation!)
        }

        return (bodyView: coachMarkBodyView, arrowView: coachMarkArrowView)
    }

    /// Pause the display.
    /// This method is expected to be used by the delegate to
    /// top the display, perform animation and resume display with `play()`
    public func pause() {
        self.paused = true
    }

    /// Play the display.
    /// If the display wasn't paused earlier, this method won't do anything.
    public func play() {
        if self.started && self.paused {
            self.paused = false
            self.createAndShowCoachMark()
        }
    }

    //MARK: - Private methods
    /// Add the overlay view which will blur/dim the background.
    private func addOverlayView() {
        self.view.addSubview(self.overlayView)

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[overlayView]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["overlayView": self.overlayView]))

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[overlayView]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["overlayView": self.overlayView]))

        self.overlayView.alpha = 0.0
    }

    /// Return the controller into an idle state.
    private func reset() {
        self.numberOfCoachMarks = 0;
        self.currentIndex = -1;

        self.currentCoachMark = nil;
        self.currentCoachMarkView = nil;
    }

    /// Ask the datasource, create the coach mark and display it. Also
    /// notifies the delegate.
    private func retrieveCoachMarkFromDataSource() {
        // Retrieves the current coach mark structure from the datasource.
        // It can't be nil, that's why we'll force unwrap it everywhere.
        self.currentCoachMark = self.datasource!.coachMarksController(self, coachMarksForIndex: self.currentIndex)

        // The coach mark will soon show, we notify the delegate, so it
        // can peform some things and, if required, update the coach mark structure.
        self.delegate?.coachMarksController(self, coachMarkWillShow: &self.currentCoachMark!, forIndex: self.currentIndex)

        if !self.paused {
            createAndShowCoachMark()
        }
    }

    /// Create display the coach mark view.
    private func createAndShowCoachMark() {

        // Once the coach mark structure is final, we'll compute the arrow
        // orientation, so the data source will know what king of views supply.
        self.currentCoachMark!.computeOrientationInFrame(self.view.frame)

        // Compute the point of interest, based on the cutOut path.
        self.currentCoachMark!.computePointOfInterestInFrame()

        let coachMark = self.currentCoachMark!

        // Asksthe data source for the appropriate tuple of views.
        let coachMarkComponentViews = self.datasource!.coachMarksController(self, coachMarkViewsForIndex: self.currentIndex, coachMark: coachMark)

        // Creates the CoachMarkView, from the supplied component views.
        // CoachMarkView() is not a failable initializer. We'll force unwrap
        // currentCoachMarkView everywhere.
        self.currentCoachMarkView = CoachMarkView(bodyView: coachMarkComponentViews.bodyView, arrowView: coachMarkComponentViews.arrowView, arrowOrientation: coachMark.arrowOrientation, arrowOffset: coachMark.gapBetweenBodyAndArrow)

        let coachMarkView = self.currentCoachMarkView!

        // Hook up the next coach control.
        coachMarkView.nextControl?.addTarget(self, action: "performShowNextCoachMark:", forControlEvents: .TouchUpInside)

        // The view shall be invisible, 'cause we'll animate its entry.
        coachMarkView.alpha = 0.0

        self.prepareCurrentCoachMarkForDisplay()

        // Animate the view entry
        self.overlayView.showCutoutPathViewWithAnimationDuration(coachMark.animationDuration)

        UIView.animateWithDuration(coachMark.animationDuration) { () -> Void in
            self.currentCoachMarkView!.alpha = 1.0
        }
    }

    /// Add the current coach mark to the view, making sure it is
    /// properly positioned.
    private func prepareCurrentCoachMarkForDisplay() {
        guard let coachMark = self.currentCoachMark, coachMarkView = self.currentCoachMarkView else {
            return
        }

        // Add the view and compute its associated constraints.
        self.view.addSubview(coachMarkView)

        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:[currentCoachMarkView(<=\(coachMark.maxWidth))]", options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil, views: ["currentCoachMarkView": self.currentCoachMarkView!])
        )

        // No cutoutPath, no arrow.
        if let cutoutPath = coachMark.cutoutPath {
            let offset = coachMark.gapBetweenCoachMarkAndCutoutPath

            // Depending where the cutoutPath sits, the coach mark will either
            // stand above or below it.
            if coachMark.arrowOrientation! == .Bottom {
                let coachMarkViewConstraint = NSLayoutConstraint(item: coachMarkView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -(self.view.frame.size.height - cutoutPath.bounds.origin.y + offset))
                self.view.addConstraint(coachMarkViewConstraint)
            } else {
                let coachMarkViewConstraint = NSLayoutConstraint(item: coachMarkView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: (cutoutPath.bounds.origin.y + cutoutPath.bounds.size.height) + offset)
                self.view.addConstraint(coachMarkViewConstraint)
            }

            let horizontalMargin = coachMark.horizontalMargin
            let maxWidth = coachMark.maxWidth

            let pointOfInterest = coachMark.pointOfInterest!
            let segmentNumber = 3 * pointOfInterest.x / self.view.bounds.size.width

            if segmentNumber < 1 {
                self.view.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat("H:|-(==\(horizontalMargin))-[currentCoachMarkView(<=\(maxWidth))]-(>=\(horizontalMargin))-|", options: NSLayoutFormatOptions(rawValue: 0),
                        metrics: nil, views: ["currentCoachMarkView": coachMarkView])
                )

                coachMarkView.changeArrowPositionTo(CoachMarkView.ArrowPosition.Leading, offset: pointOfInterest.x - coachMark.horizontalMargin)

            } else if segmentNumber < 2 {
                self.view.addConstraint(NSLayoutConstraint(item: coachMarkView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))

                self.view.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=\(horizontalMargin))-[currentCoachMarkView(<=\(maxWidth)@1000)]-(>=\(horizontalMargin))-|", options: NSLayoutFormatOptions(rawValue: 0),
                        metrics: nil, views: ["currentCoachMarkView": coachMarkView])
                )

                coachMarkView.changeArrowPositionTo(CoachMarkView.ArrowPosition.Center, offset: self.view.center.x - pointOfInterest.x)

            } else if segmentNumber < 3 {
                self.view.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=\(horizontalMargin))-[currentCoachMarkView(<=\(maxWidth))]-(==\(horizontalMargin))-|", options: NSLayoutFormatOptions(rawValue: 0),
                        metrics: nil, views: ["currentCoachMarkView": coachMarkView])
                )

                coachMarkView.changeArrowPositionTo(CoachMarkView.ArrowPosition.Trailing, offset: self.view.bounds.size.width - pointOfInterest.x - coachMark.horizontalMargin)
            }

            self.overlayView.updateCutoutPath(cutoutPath)
        } else {
            self.overlayView.updateCutoutPath(nil)
        }
    }
}
