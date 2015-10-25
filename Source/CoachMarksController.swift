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

// TODO: Refactor the Mega Controller!
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

    /// The view holding the "Skip" control
    public var skipView: CoachMarkSkipView? {
        // Again, we test the protocol/UIView combination
        // at runtime.
        
        get {
            return self.skipViewAsView as! CoachMarkSkipView?
        }

        set {
            guard let validSkipView = newValue else {
                self.skipViewAsView = nil
                return
            }

            if !(validSkipView is UIView) {
                fatalError("skipView must conform to CoachMarkBodyView but also be a UIView.")
            }

            self.skipViewAsView = validSkipView as? UIView

            self.skipViewDisplayManager = SkipViewDisplayManager(skipView: skipViewAsView!, instructionsTopView: self.instructionsTopView)
        }
    }

    //MARK: - Private properties
    private lazy var coachMarkDisplayManager: CoachMarkDisplayManager! = {
        return CoachMarkDisplayManager(overlayView: self.overlayView, instructionsTopView: self.instructionsTopView)
    }()

    private var skipViewDisplayManager: SkipViewDisplayManager?

    /// The total number of coach marks, supplied by the `datasource`.
    private var numberOfCoachMarks = 0

    /// The index (in `coachMarks`) of the coach mark being currently displayed.
    private var currentIndex = -1

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

    /// This view will be added to the current `UIWindow` and cover everything.
    /// The overlay and the coachmarks will all be subviews of this property.
    private var instructionsTopView = UIView()

    /// Sometimes, the chain of coach mark display can be paused
    /// to let animations be performed. `true` to pause the execution,
    /// `false` otherwise.
    private var paused = false

    /// Since changing size calls asynchronous completion blocks,
    /// we might end up firing multiple times the methods adding coach
    /// marks to the view. To prevent that from happening we use the guard
    /// property.
    ///
    /// Everything is normally happening on the main thread, atomicity should
    /// not be a problem. Plus, a size change is a very long process compared to
    /// subview addition.
    ///
    /// `true` when the controller is performing a size change, `false` otherwise.
    private var changingSize = false

    /// The view holding the "Skip" control.
    private var skipViewAsView: UIView?

    /// Constraints defining the SKipView position.
    private var skipViewConstraints: [NSLayoutConstraint] = []

    //MARK: - View lifecycle
    // Called after the view was loaded.
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.translatesAutoresizingMaskIntoConstraints = false

        self.addOverlayView()
    }

    //MARK: - Overrides
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {

        self.overlayView.updateCutoutPath(nil)
        self.prepareForSizeTransition()

        self.changingSize = true

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext) -> Void in

        }, completion: { (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.changingSize = false
            self.overlayView.alpha = 1.0
            self.updateSkipViewConstraints()
            self.skipViewAsView?.alpha = 1.0
            self.retrieveCoachMarkFromDataSource(shouldCallDelegate: false)
        })
    }

    //MARK: - Protocol Conformance | OverlayViewDelegate
    internal func didReceivedSingleTap() {
        if self.paused { return }

        self.showNextCoachMark()
    }

    //MARK: - Public handlers
    /// Will be called when the user perform an action requiring the display of the next coach mark.
    ///
    /// - Parameter sender: the object sending the message
    public func performShowNextCoachMark(sender:AnyObject?) {
        self.showNextCoachMark()
    }

    /// Will be called when the user choose to skip the coach mark tour.
    ///
    /// - Parameter sender: the object sending the message
    public func skipCoachMarksTour(sender: AnyObject?) {
        self.stop()
    }

    //MARK: - Public Helpers
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

        let convertedFrame = self.instructionsTopView.convertRect(view.frame, fromView:view.superview);

        var bezierPath: UIBezierPath

        if let bezierPathBlock = bezierPathBlock {
            bezierPath = bezierPathBlock(frame: convertedFrame)
        } else {
            bezierPath = UIBezierPath(roundedRect: CGRectInset(convertedFrame, -4, -4), byRoundingCorners: .AllCorners, cornerRadii: CGSize(width: 4, height: 4))
        }

        coachMark.cutoutPath = bezierPath

        if let pointOfInterest = pointOfInterest {
            let convertedPoint = self.instructionsTopView.convertPoint(pointOfInterest, fromView:view.superview);
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
        self.currentIndex = -1
        self.numberOfCoachMarks = datasource.numberOfCoachMarksForCoachMarksController(self)

        // The view was previously hidden, to prevent it from catching the user input.
        // Now, we want exactly the opposite. We want the overlay view to prevent events
        // from reaching down.
        self.view.userInteractionEnabled = true

        if let skipViewDisplayManager = self.skipViewDisplayManager {
            skipViewDisplayManager.addSkipView()
            updateSkipViewConstraints()
        }

        self.skipView?.skipControl?.addTarget(self, action: "skipCoachMarksTour:", forControlEvents: .TouchUpInside)

        self.overlayView.prepareForFade()

        UIView.animateWithDuration(self.overlayFadeAnimationDuration, animations: { () -> Void in
            self.overlayView.alpha = 1.0
            self.skipViewAsView?.alpha = 1.0
        }, completion: { (finished: Bool) -> Void in
            self.showNextCoachMark()
        })
    }

    /// Stop displaying the coach marks and perform some cleanup.
    public func stop() {
        UIView.animateWithDuration(self.overlayFadeAnimationDuration, animations: { () -> Void in
            self.overlayView.alpha = 0.0
            self.skipViewAsView?.alpha = 0.0
            self.currentCoachMarkView?.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
            self.skipView?.skipControl?.removeTarget(self, action: "skipCoachMarksTour:", forControlEvents: .TouchUpInside)
            self.reset()
            self.detachFromViewController()

            // Calling the delegate, maybe the user wants to do something?
            self.delegate?.didFinishShowingFromCoachMarksController(self)

        })
    }

    /// Pause the display.
    /// This method is expected to be used by the delegate to
    /// top the display, perform animation and resume display with `play()`
    public func pause() {
        self.paused = true
    }

    /// Resume the display.
    /// If the display wasn't paused earlier, this method won't do anything.
    public func resume() {
        if self.started && self.paused {
            self.paused = false
            self.createAndShowCoachMark()
        }
    }

    //MARK: - Private methods
    /// Return the controller into an idle state.
    private func reset() {
        self.numberOfCoachMarks = 0
        self.currentIndex = -1

        self.currentCoachMark = nil
        self.currentCoachMarkView = nil
    }

    /// Will attach the controller as a child of the given view controller. This will
    /// allow the coach mark controller to respond to size changes, though
    /// `instructionsTopView` will be a subview of `UIWindow`.
    ///
    /// - Parameter parentViewController: the controller of which become a child
    private func attachToViewController(parentViewController: UIViewController) {
        parentViewController.addChildViewController(self)
        parentViewController.view.addSubview(self.view)

        self.instructionsTopView.translatesAutoresizingMaskIntoConstraints = false;
        parentViewController.view?.window?.addSubview(self.instructionsTopView)

        parentViewController.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[overlayView]|", options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil, views: ["overlayView": self.view]))

        parentViewController.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[overlayView]|", options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil, views: ["overlayView": self.view]))

        parentViewController.view?.window?.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[instructionsTopView]|", options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil, views: ["instructionsTopView": self.instructionsTopView]))

        parentViewController.view?.window?.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[instructionsTopView]|", options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil, views: ["instructionsTopView": self.instructionsTopView]))

        self.instructionsTopView.backgroundColor = UIColor.clearColor()

        self.didMoveToParentViewController(parentViewController)
    }

    /// Detach the controller from its parent view controller.
    private func detachFromViewController() {
        self.instructionsTopView.removeFromSuperview()

        self.willMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

    /// Show the next coach mark and hide the current one.
    private func showNextCoachMark() {
        self.currentIndex++

        // if `currentIndex` is above 0, that means a previous coach mark
        // is displayed. We call the delegate to notify that the current coach
        // mark will disappear, and only then, we hide the coach mark.
        if self.currentIndex > 0 {
            self.delegate?.coachMarksController(self, coachMarkWillDisappear: self.currentCoachMark!, forIndex: self.currentIndex - 1)

            self.coachMarkDisplayManager.hideCoachMarkView(self.currentCoachMarkView, animationDuration: self.currentCoachMark!.animationDuration) {
                self.removeCurrentCoachView()

                if self.currentIndex < self.numberOfCoachMarks {
                    self.retrieveCoachMarkFromDataSource()
                } else {
                    self.stop()
                }
            }
        } else {
            self.retrieveCoachMarkFromDataSource()
        }
    }

    /// Add the overlay view which will blur/dim the background.
    private func addOverlayView() {
        self.instructionsTopView.addSubview(self.overlayView)

        self.instructionsTopView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[overlayView]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["overlayView": self.overlayView]))

        self.instructionsTopView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[overlayView]|", options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: ["overlayView": self.overlayView]))

        self.overlayView.alpha = 0.0
    }

    /// Ask the datasource, create the coach mark and display it. Also
    /// notifies the delegate. When this method is called during a size change,
    /// the delegate is not notified.
    ///
    /// - Parameter shouldCallDelegate: `true` to call delegate methods, `false` otherwise.
    private func retrieveCoachMarkFromDataSource(shouldCallDelegate shouldCallDelegate: Bool = true) {
        if changingSize { return }

        // Retrieves the current coach mark structure from the datasource.
        // It can't be nil, that's why we'll force unwrap it everywhere.
        self.currentCoachMark = self.datasource!.coachMarksController(self, coachMarksForIndex: self.currentIndex)

        // The coach mark will soon show, we notify the delegate, so it
        // can peform some things and, if required, update the coach mark structure.
        if shouldCallDelegate {
            self.delegate?.coachMarksController(self, coachMarkWillShow: &self.currentCoachMark!, forIndex: self.currentIndex)
        }

        if !self.paused {
            createAndShowCoachMark()
        }
    }

    /// Create display the coach mark view.
    private func createAndShowCoachMark() {
        if changingSize { return }

        // Once the coach mark structure is final, we'll compute the arrow
        // orientation, so the data source will know what king of views supply.
        self.currentCoachMark!.computeOrientationInFrame(self.view.frame)

        // Compute the point of interest, based on the cutOut path.
        self.currentCoachMark!.computePointOfInterestInFrame()

        // Asksthe data source for the appropriate tuple of views.
        let coachMarkComponentViews = self.datasource!.coachMarksController(self, coachMarkViewsForIndex: self.currentIndex, coachMark: self.currentCoachMark!)

        // Creates the CoachMarkView, from the supplied component views.
        // CoachMarkView() is not a failable initializer. We'll force unwrap
        // currentCoachMarkView everywhere.
        self.currentCoachMarkView = CoachMarkView(bodyView: coachMarkComponentViews.bodyView, arrowView: coachMarkComponentViews.arrowView, arrowOrientation: self.currentCoachMark!.arrowOrientation, arrowOffset: self.currentCoachMark!.gapBetweenBodyAndArrow)

        // Hook up the next coach control.
        self.currentCoachMarkView!.nextControl?.addTarget(self, action: "performShowNextCoachMark:", forControlEvents: .TouchUpInside)

        self.coachMarkDisplayManager.displayCoachMarkView(self.currentCoachMarkView!, coachMark: self.currentCoachMark!)
    }

    /// Will hide the current coach view and unbind events.
    private func removeCurrentCoachView() {
        self.currentCoachMarkView?.removeFromSuperview()
        self.currentCoachMarkView?.nextControl?.removeTarget(self, action: "performShowNextCoachMark:", forControlEvents: .TouchUpInside)
    }

    /// Will remove currently displayed coach mark.
    private func prepareForSizeTransition() {
        self.currentCoachMarkView?.layer.removeAllAnimations()
        self.removeCurrentCoachView()
        self.skipViewDisplayManager?.hideSkipView()
        self.currentCoachMarkView = nil
    }

    /// Update the constraints defining the position of the "Skip" view.
    private func updateSkipViewConstraints() {
        guard let skipView = self.skipViewAsView, let skipViewDisplayManager = self.skipViewDisplayManager else {
            return
        }

        let layoutConstraints = self.datasource?.coachMarksController(self, constraintsForSkipView: skipView, inParentView: self.instructionsTopView)

        skipViewDisplayManager.updateSkipViewConstraintsWithConstraints(layoutConstraints)
    }
}
