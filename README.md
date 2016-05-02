# ![Instructions](http://i.imgur.com/2Wy44G6.png)

[![Travis build status](https://img.shields.io/travis/ephread/Instructions.svg)](https://travis-ci.org/ephread/Instructions) [![CocoaPods Shield](https://img.shields.io/cocoapods/v/Instructions.svg)](https://cocoapods.org/pods/Instructions) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Join the chat at https://gitter.im/ephread/Instructions](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/ephread/Instructions?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Add customizable coach marks into you iOS project. Instructions will makes your life easier, I promise. Available for both iPhone and iPad.

## Overview
![Instructions Demo](http://i.imgur.com/JUlQH9F.gif)

⚠️ **Until Instructions reaches 1.0.0, the API is subject to change. Please see the Features section for more information about the roadmap.**

## Features
- [x] Customizable views
- [x] Customizable positions
- [x] Customizable highlight system
- [x] Skipable tour
- [x] Full right-to-left support
- [x] Size transition support (orientation and multi-tasking)
- [x] Skipable tour
- [x] Pilotable from code
- [ ] Cross controllers walkthrough
- [ ] Good test coverage • **Once done, it should bump version to 1.0.0**
- [ ] Full support of UIVisualEffectView blur in overlay
- [ ] Objective-C bridging
- [ ] Coach marks animation

## Requirements
- Xcode 7 / Swift 2
- iOS 8.0+

## Asking Questions / Contributing

### Asking questions

If you need help with something in particular, ask a question on [Stack Overflow](https://stackoverflow.com) with the tag `instructions-swift` (make sure the question hasn't already been asked and answered).

If you have other questions, use the [Gitter room](https://gitter.im/ephread/Instructions).

### Contributing

If you found a bug, open issue **or** fix it yourself and submit a pull request!

If you have an idea for a missing feature, open an issue.

If you want to develop a specific feature and merge it back, it's better to notify me beforehand. You can either open a issue, poke me on gitter or send me an email, I'll respond as fast as possible!

And don't forget to credit yourself! :clap:

## Installation

### CocoaPods
Add Instructions to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Instructions', '~> 0.4'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage
Add Instructions to your Cartfile:

```
github "ephread/Instructions" ~> 0.4
```

You can then update, build and drag the generated framework into your project:

```bash
$ carthage update
$ carthage build
```

### Manually
If you rather stay away from both CocoaPods and Carthage, you can also install Instructions manually, with the cost of managing updates yourself.

#### Embedded Framework
1. Drag the Instructions.xcodeproj into the project navigator of your application's Xcode project.
2. Still in the project navigator, select your application project. The target configuration panel should show up.
3. Select the appropriate target and in the "General" panel, scroll down to the section named "Embedded Binaries".
4. Click on the + button and select the "Instructions.framework" under the "Product" directory.

## Usage

### Getting started
Open up the controller for which you wish to display coach marks and instanciate a new `CoachMarksViewController`. You should also provide a `dataSource`, which is an object conforming to the `CoachMarksControllerDataSource` protocol.

```swift
class DefaultViewController: UIViewController, CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    let coachMarksController = CoachMarksController()
	 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coachMarksController.dataSource = self
    }
}
```

#### Data Source
`CoachMarksControllerDataSource` declares three mandatory methods.

The first one asks for the number of coach marks to display. Let's pretend that you want to display only one coach mark. Note that the `CoachMarksController` requesting the information is supplied, allowing you to supply data for mutiple `CoachMarksController`, within a single dataSource.

```swift
func numberOfCoachMarksForCoachMarksController(coachMarkController: CoachMarksController)
-> Int {
    return 1
}
```

The second one asks for metadata. This allows you to customize how a coach mark will position and appear, but won't let you define its look (more on this later). Metadata are packaged in a struct named `CoachMark`. Note the parameter `coachMarksForIndex`, it gives you the coach mark logical position, much like and `IndexPath` would do. `coachMarksController` provides you with an easy way to create a default `CoachMark` object, from a given view.

```swift
let pointOfInterest = UIView()

func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex: Int)
-> CoachMark {
    return coachMarksController.coachMarkForView(self.pointOfInterest)
}
```

The third one supplies two views (much like `cellForRowAtIndexPath`) in the form a Tuple. The _body_ view is mandatory, as it's the core of the coach mark. The _arrow_ view is optional.

But for now, lets just return the default views provided by Instructions.

```swift
func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark)
-> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
    let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)

    coachViews.bodyView.hintLabel.text = "Hello! I'm a Coach Mark!"
    coachViews.bodyView.nextLabel.text = "Ok!"

    return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
}
```

#### Starting the coach marks flow
Once the `dataSource` is set up, you can start displaying the coach marks. You will most likely supply `self` to `startOn`. While the overlay adds itself as a child of the current window (to be on top of everything), the `CoachMarksController` will add itself as a child of the view controller you provide. That way, the `CoachMarksController` will receive size change events and react accordingly. Be careful, you can't call `startOn` in the `viewDidLoad` method, since the view hierarchy has to be set up and ready for Instructions to work properly.

```swift
override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    self.coachMarksController.startOn(self)
}
```

You're all set. For more examples you can check the `Examples/` directory provided with the library.

### Advanced Usage

#### Customizing general properties
You can customized the background color of the overlay using this property:

- `overlayBackgroundColor`

You can also make the overlay blur the content sitting behind it. Setting this property to anything else than `nil` will disable the `overlayBackgroundColor`:

- `overlayBlurEffectStyle: UIBlurEffectStyle?`

Last, you can make the overlay tappable. A tap on the overlay will hide the current coach mark and display the next one.

- `allowOverlayTap: Bool`

#### Providing a custom cutout path
If you dislike how the default cutout path looks like, you can customize it by providing a block to `coachMarkForView`. The cutout path will automatically be stored in the `cutoutPath` property of the returning `CoachMark` object:

```swift
var coachMark = coachMarksController.coachMarkForView(customView) {
(frame: CGRect) -> UIBezierPath in
    // This will create an oval cutout a bit larger than the view.
    return UIBezierPath(ovalInRect: CGRectInset(frame, -4, -4))
}
```

`frame` will be the frame of `customView` converted in the `coachMarksController.view` referential, so don't have to worry about making sure the coordinates are in the appropriate referential. You can provide any kind of shape, from a simple rectangle to a complex star.

#### Providing custom views
You can (and you should) provide custom views. A coach mark is composed of two views, a _body_ view and an _arrow_ view. Note that the term _arrow_ might be misleading. It doesn't have to be an actual arrow, it can be anything you want.

A _body_ view must conform to the `CoachMarkBodyView` protocol. An _arrow_ view must conform to the `CoachMarkArrowView` protocol. Both of them must also be subclasses of `UIView`.

Returning a `CoachMarkBodyView` view is mandatory, while returning a `CoachMarkArrowView` is optional.

##### CoachMarkBodyView Protocol #####
This protocol defines two properties.

- `nextControl: UIControl? { get }` you must implement a getter method for this property in your view, this will let the `CoachMarkController` know which control should be tapped, to display the next coach mark. Note that it doesn't have to be a subview, you can return the view itself.

- `highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate?` in case the view itself is the control receiving taps, you might want to forward its highlight state to the _arrow_ view (so they can look as if they are the same component). The `CoachMarkController` will automatically set an appropriate delegate to this property. You'll then be able to do this:

```swift
override var highlighted: Bool {
	didSet {
	    self.highlightArrowDelegate?.highlightArrow(self.highlighted)
	}
}
```

##### Taking orientation into account #####
Remember the following method, from the dataSource?

```swift
func coachMarksController(coachMarkController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark) {
	let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
}
```

When providing a customized view, you need to provide an _arrow_ view with the approriate orientation (i. e. in the case of an actual arrow, pointing upward or downward). The `CoachMarkController` will tell you which orientation it expects, through the following property: `CoachMark.arrowOrientation`.

Browse the `Example/` directory for more details.

#### Customizing how the coach mark will show
You can customize the following properties:

- `animationDuration: NSTimeInterval`: the time it will take for a coach mark to appear or disappear on the screen.

- `gapBetweenBodyAndArrow: CGFloat`: the vertical gap between the _body_ and the _arrow_ in a given coach mark.

- `pointOfInterest: CGPoint?`: the point toward which the arrow will face. At the moment, it's only used to shift the arrow horizontally and make it sits above or below the point of interest.

- `gapBetweenCoachMarkAndCutoutPath: CGFloat`: the gap between the coach mark and the cutout path.

- `maxWidth: CGFloat`: the maximum width a coach mark can take. You don't want your coach marks to be too wide, especially on iPads.

- `horizontalMargin: CGFloat` is the margin (both leading and trailing) between the edges of the overlay view and the coach mark. Note that if the max width of your coach mark is less than the width of the overlay view, you view will either stack on the left or on the right, leaving space on the other side.

- `arrowOrientation: CoachMarkArrowOrientation?` is the orientation of the arrow (not the coach mark, meaning setting this property to `.Top` will display the coach mark below the point of interest). Although it's usually pre-computed by the library, you can override it in `coachMarksForIndex:` or in `coachMarkWillShow:`.

- `disableOverlayTap: Bool` is property used to disable the ability to tap on the overlay to show the next coach mark, on a case-by-case basis.

#### Let users skip the tour
##### Control
You can provide the user with a mean to skip the coach marks. First, you will need to set 
`skipView` with a `UIView` conforming to the `CoachMarkSkipView` protocol. This protocol defines a single property:

```swift
public protocol CoachMarkSkipView : class {
    var skipControl: UIControl? { get }
}
```

You must implement a getter method for this property in your view. This will let the `CoachMarkController` know which control should be tapped, to skip the tour. Note that, again, it doesn't have to be a subview, you can return the view itself.

As usual, Instructions provides a default implementation of `CoachMarkSkipView` named `CoachMarkSkipDefaultView`.

##### dataSource
To define how the view will position itself, you can use a method from the `CoachMarkControllerDataSource` protocol. This method is optional.

```swift
func coachMarksController(coachMarksController: CoachMarksController, constraintsForSkipView skipView: UIView, inParentView parentView: UIView) -> [NSLayoutConstraint]?
```

This method will be called by the `CoachMarksController` before starting the tour and whenever there is a size change. It gives you the _skip button_ and the view in which it will be positioned and expects an array of `NSLayoutConstraints` in return. These constraints will define how the _skip button_ will be positioned in its parent. You should not add the constraints yourself, just return them.

Returning `nil` will tell the `CoachMarksController` to use the defaults constraints, which will position the _skip button_ at the top of the screen. Returning an empty array is discouraged, as it will most probably lead to an akward positioning.

For more information about the skip mechanism, you can check the `Example/` directory.

#### Piloting the flow from the code
Should you ever need to programmatically show the coach mark, `CoachMarkController` also provides the following method:

```swift
func showNext(numberOfCoachMarksToSkip numberToSkip: Int = 0)
```

You can specify a number of coach marks to skip (effectively jumping to a further index).

Take a look at `TransitionFromCodeViewController`, in the `Example/` directory, to get an idea of how you can leverage this method, in order to ask the user to perform certain actions.

#### Using a delegate
The `CoachMarkController` will notify the delegate on three occasions. All those methods are optionals.

First, when a coach mark will show. You might want to change something about the view. For that reason, the `CoachMark` metadata structure is passed as an `inout` object, so you can update it with new parameters.

```swift
func coachMarksController(coachMarksController: CoachMarksController, inout coachMarkWillShow: CoachMark, forIndex: Int)
```

Second, when a coach mark disappears.

```swift    
func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillDisappear: CoachMark, forIndex: Int)
```
Third, when all coach marks have been displayed. 

```swift    
func didFinishShowingFromCoachMarksController(coachMarksController: CoachMarksController)
```

##### Performing animations before showing coach marks #####
You can perform animation on views, before or after showing a given coach mark.
For instance, you might want to collapse a table view and show only its header, before referring to those headers with a coach mark. Instructions offers a simple way to insert your own animations into the flow.

For instance, let's say you want to perform an animation _before_ a coach mark shows.
You'll implement some logic into the `coachMarkWillShow` delegate method.
To ensure you don't have to hack something up and turn asynchronous animation blocks into synchronous ones, you can pause the flow, perform the animation and then start the flow again. This will ensure your UI never get stalled.

```swift
func coachMarksController(coachMarksController: CoachMarksController, inout coachMarkWillShow: CoachMark, forIndex: Int) {
	 // Pause to be able to play the animation and then show the coach mark.
    coachMarksController.pause()

    // Run the animation
    UIView.animateWithDuration(1, animations: { () -> Void in
        …
    }, completion: { (finished: Bool) -> Void in
        // Once the animation is completed, we update the coach mark,
        // and start the display again. Since inout parameters cannot be
        // captured by the closure, you can use the following method to update
        // the coachmark. It will only work if you paused the flow.
        coachMarksController.updateCurrentCoachMarkForView(myView)
        coachMarksController.resume()
    })
}
```

##### Skipping a coach mark

You can skip a given coach mark by implementing the following method defined in `CoachMarksControllerDelegate`:

```swift
func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillLoadForIndex index: Int) -> Bool
```

`coachMarkWillLoadForIndex:` is called right before a given coach mark will show. To prevent a CoachMark from showing, you can return `false` from this method.

## License

Instructions is released under the MIT license. See LICENSE for details.
