= How to Release =
1. Update the CHANGELOG.md
2. Update iOSSnapshotTestCase.podspec version number
3. `pod install` inside FBSnapshotTestCaseDemo/
4. Commit all the changes
5. Tag the commit in master with `git tag version-number`; e.g., `git tag 0.0.1`
6. Push the tag with `git push --tags`
7. `pod trunk push iOSSnapshotTestCase.podspec`
8. `carthage build --archive --configuration Debug`
9. Upload the `FBSnapshotTestCase.framework.zip` to the tagged release on Github for the version number
