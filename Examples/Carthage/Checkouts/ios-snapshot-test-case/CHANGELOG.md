# Change Log

All notable changes to this project will be documented in this file.

## 6.2.0

- Fixed issue where images without the screen scale in the file name were failing. ([#100](https://github.com/uber/ios-snapshot-test-case/pull/100))
- Add convenience FBSnapshotVerifyViewController() function for Swift users ([#101](https://github.com/uber/ios-snapshot-test-case/pull/101))
- Updated for Xcode 11.1 and Swift 5.1.

## 6.1.0

- Added support for Xcode 9 attachments. ([#86](https://github.com/uber/ios-snapshot-test-case/pull/86))
- Updated the default suffixes to only contain the currently targetted architecture. ([#87](https://github.com/uber/ios-snapshot-test-case/pull/87))
- Use [UIGraphicsImageRenderer](https://developer.apple.com/documentation/uikit/uigraphicsimagerenderer) to generate the image for a UIView instead of a custom graphics context ([#95](https://github.com/uber/ios-snapshot-test-case/pull/95))
- Use the main screen instead of the key window to calculate the correct size in tests that do not have a host application. ([#79](https://github.com/uber/ios-snapshot-test-case/pull/79))
- Display the correct error message when tests are run in record mode. ([#65](https://github.com/uber/ios-snapshot-test-case/pull/65))
- Updated for Xcode 10.2.1 and Swift 5.0.1.

## 6.0.3

  - This is a compatibility release for Swift 5 — we're building the Carthage pre–compiled framework with Xcode 10.2 and the Swift 5 compiler. If you haven't updated to Xcode 10.2, you don't need to worry about this version.

## 6.0.2

  - Update for Swift 5 compiler.

## 6.0.0

  - We deleted the `agnosticOptions` and `deviceAgnostic` properties. We didn't want to do this initially but we thought it was good to make a clean break from the old properties that had incorrect naming, as well as adding a new property (`fileNameOptions`) that includes screen scale as an option, so users of the library can choose to omit the screen scale from their file names.
  - Deployment Target set to iOS 10.0. For our own sanity, we only want to support three major versions of iOS at a time. If you need to support iOS 8 and/or 9, you need to use version 5.0 of the library.

## 5.0.2

  - Adds the ability to allow color changes for pixels. You can now set a 'pixel tolerance', which is a percentage for how much of a shift from any given color you allow on a per pixel basis. This can be useful for Xcode upgrades, when you change the iOS version (Base SDK) you use in your Simulator, or even to allow tests to run on multiple iOS versions at the same time. It can be used with `FBSnapshotVerifyViewWithPixelOptions` and `FBSnapshotVerifyLayerWithPixelOptions` (Thanks to @JerryTheIntern).

## 4.0.0

  - Adds the ability to override the folder name where snapshots are going to be saved for each test class.
  - Support for library test bundles.
  - Support for setting `IMAGE_DIFF_DIR` using preprocessor or a property on `FBSnapshotTestController`.
  - Formatted the project using clang-format to escape two space indentation hell.
  - Added nullability annotations to the entire project to improve portability with Swift and the clang analyzer.
  - Deprecated `deviceAgnostic` in favour of `agnosticOptions`.
  - Remove dead Swift code in `SwiftSupport.swift`

  Apologies for the churn in this version. We realised after we had merged #14 that we broke semantic versioning with `3.1.0` so we unpublished that podspec and then merged all of the breaking changes we had on the backlog that were pressing.

## 3.0.0

  - Project has been relicensed to MIT via the original project and Facebook's PATENTS file has been removed with their blessing. Thank you Facebook!
  - Deployment Target is now iOS 8.1, Base SDK is 11.2.
  - Updated for CocoaPods 1.4.0.

## 2.2.0

  - Added ability to have more fine–grained control over snapshot file names using deviceAgnostic with a new flag 'agnosticOptions'.
  - Updated for Xcode 9.2 and Swift 4.
  - Fixed a bug where the bounds of a snapshot would be incorrect after UIAppearance triggers a change in the intrinsic content size of the UIView being snapshotted.

## 2.1.6

  - Fixes to podspec

## 2.1.5

  - Project transferred to Uber; license changed from BSD to MIT
  - Swift 3.1 support
  - Fixed broken FB_REFERENCE_IMAGE_DIR preprocessor macro

## 2.1.4

  - Swift 3 support (#194)
  - Replace big macro with Objective-C method for easier debugging (#180)

## 2.1.3

  - Allow to compile with Xcode 7 and Xcode 8 Swift 2.3 (#179)

## 2.1.2

  - Disabled Bitcode for tvOS target (#169)
  - Added user target in podspec (#165)

## 2.1.1

  - Added tvOS support for cocoapods (#163)
  - Remove custom module map for cocoapods (#141)

## 2.1.0

  - Changed FBSnapshotTestController from private to public in the xcodeproj (#135)
  - Added device agnostic tests and assertions (#137)
  - Fixed fb_imageForView edge cases (#138, #153)
  - Changed project setting to match the code style (#139)
  - Fixed propagating the correct file name and line number on Swift (#140)
  - Added framework support for tvOS (#143)
  - Added optional tolerance parameter on Swift (#145)
  - Added images to comparison errors (#146)
  - Fixed build for Xcode 7.3 (#152)

## 2.0.7

  - Change FBSnapshotTestController from private to public (#129)

## 2.0.6

  - Added modulemap and podspec fixes to build with Xcode 7.1 (#127)

## 2.0.5

  - Swift 2.0 (#111, #120) (Thanks to @pietbrauer and @grantjk)
  - Fix pod spec by disabling bitcode (#115) (Thanks to @soleares)
  - Fix for incorrect errors with multiple suffixes (#119) (Thanks to @Grubas7)
  - Support for Model and OS in image names (#121 thanks to @esttorhe)

## 2.0.4

  - Support loading reference images from the test bundle (#104) (Thanks to @yiding)
  - Fix for retina tolerance comparisons (#107)

## 2.0.3

  - New property added `usesDrawViewHierarchyInRect` to handle cases like `UIVisualEffect` (#70), `UIAppearance` (#91) and Size Classes (#92) (#100)

## 2.0.2

  - Fix for retina comparisons (#96)

## 2.0.1

  - Allow usage of Objective-C subspec only, for projects supporting iOS 7 (#93) (Thanks to @x2on)

## 2.0.0

  - Approximate comparison (#88) (Thanks to @nap-sam-dean)
  - Swift support (#87) (Thanks to @pietbrauer)

## 1.8.1

  - Prevent mangling of C function names when compiled with a C++ compiler. (#79)

## 1.8.0

  - The default directories for snapshots images are now **ReferenceImages_32** (32bit) and **ReferenceImages_64** (64bit) and the suffix depends on the architecture when the test is running. (#77)
  	- If a test fails for a given suffix, it will try to load and compare all other suffixes before failing.
  - Added assertion on setRecordMode. (#76)
