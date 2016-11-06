# Migrating from Swift 2 to Swift 3

From version 0.6.0 onwards, Instructions will only support Swift 3. To follow more closely the   [API Design Guidelines], a number of methods have been renamed. Although the compiler will provide you with sugestions for most of the changes, they are highlighted below.  

[API Design Guidelines]: https://swift.org/documentation/api-design-guidelines/

## `CoachMarksControllerDataSource`

**Swift 2**

```swift
func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int

func coachMarksController(coachMarksController: CoachMarksController, coachMarkForIndex index: Int) -> CoachMark

func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?)

func coachMarksController(coachMarksController: CoachMarksController, constraintsForSkipView skipView: UIView, inParentView parentView: UIView) -> [NSLayoutConstraint]?
```
**Swift 3**

```swift
func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int

func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark

func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?)

func coachMarksController(_ coachMarksController: CoachMarksController, constraintsForSkipView skipView: UIView, inParent parentView: UIView) -> [NSLayoutConstraint]?
```

## `CoachMarksControllerDelegate`

**Swift 2**

```swift
func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillLoadForIndex index: Int) -> Bool

func coachMarksController(coachMarksController: CoachMarksController, inout coachMarkWillShow coachMark: CoachMark, forIndex index: Int)

func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillDisappear coachMark: CoachMark, forIndex index: Int)

func coachMarksController(coachMarksController: CoachMarksController, didFinishShowingAndWasSkipped skipped: Bool)
```
**Swift 3**

```swift
func coachMarksController(_ coachMarksController: CoachMarksController, willLoadCoachMarkAt index: Int) -> Bool

func coachMarksController(_ coachMarksController: CoachMarksController, willShow coachMark: inout CoachMark, at index: Int)

func coachMarksController(_ coachMarksController: CoachMarksController, willHide coachMark: CoachMark, at index: Int)

func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingBySkipping skipped: Bool)
```

## `CoachMarksController.helper`

**Swift 2**

```swift
public func coachMarkForView(view: UIView? = nil, pointOfInterest: CGPoint? = nil, bezierPathBlock: ((_ frame: CGRect) -> UIBezierPath)? = nil) -> CoachMark
                             
public func defaultCoachViewsWithArrow(arrow: Bool = true, withNextText nextText: Bool = true, arrowOrientation: CoachMarkArrowOrientation? = .Top) -> (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?)
                                       
public func updateCurrentCoachMarkForView(view: UIView? = nil, pointOfInterest: CGPoint? = nil , bezierPathBlock: ((_ frame: CGRect) -> UIBezierPath)? = nil)
```
**Swift 3**

```swift
public func makeCoachMark(for view: UIView? = nil, pointOfInterest: CGPoint? = nil,
                          cutoutPathMaker: ((_ frame: CGRect) -> UIBezierPath)? = nil) -> CoachMark
                          
public func makeDefaultCoachViews(withArrow arrow: Bool = true, withNextText nextText: Bool = true, arrowOrientation: CoachMarkArrowOrientation? = .top) -> (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?)

public func updateCurrentCoachMark(usingView view: UIView? = nil, pointOfInterest: CGPoint? = nil, cutoutPathMaker: CutoutPathMaker? = nil)
```