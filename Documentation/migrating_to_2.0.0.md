# Migrating from Instructions 1.4.0 to 2.0.0

Instructions 2.0.0 brings a few breaking changes that are listed below.

## `CoachMarksControllerDataSource`

**1.4.0**

```swift
func coachMarksController(
    _ coachMarksController: CoachMarksController,
    coachMarkViewsAt index: Int,
    madeFrom coachMark: CoachMark
) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?)
```
**2.0.0**

```swift
func coachMarksController(
    _ coachMarksController: CoachMarksController,
    coachMarkViewsAt index: Int,
    madeFrom coachMark: CoachMark
) -> (bodyView: UIView & CoachMarkBodyView, arrowView: (UIView & CoachMarkArrowView)?)
```

## `CoachMark`

**1.4.0**

```swift
public var displayOverCutoutPath: Bool = false
public var disableOverlayTap: Bool = true
public var allowTouchInsideCutoutPath: Bool = false
```
**2.0.0**

```swift
public var isDisplayedOverCutoutPath: Bool = false
public var isOverlayInteractionEnabled: Bool = true
public var isUserInteractionEnabledInsideCutoutPath: Bool = false
```
⚠️ migrating `disableOverlayTap` to `isOverlayInteractionEnabled` requires inverting its boolean value.

## `OverlayManager` (`CoachMarkController.overlay`)

**1.4.0**

```swift
public var color: UIColor
public var allowTap: Bool 
public var allowTouchInsideCutoutPath: Bool
public var forwardTouchEvents: Bool
```
**2.0.0**

```swift
public var backgroundColor: UIColor
public var isUserInteractionEnabled: Bool 
public var isUserInteractionEnabledInsideCutoutPath: Bool
public var areTouchEventsForwarded: Bool
```

## `FlowManager` (`CoachMarkController.flow`)

**1.4.0**

```swift
public var started: Bool
public var paused: Bool
```
**2.0.0**

```swift
public var isStarted: Bool
public var isPaused: Bool
```
