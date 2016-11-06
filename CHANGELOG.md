# Change Log
Important changes to Instructions will be documented in this file.
Instructions follows [Semantic Versioning](http://semver.org/).
However, until it reaches 1.0.0, some breaking changes are to be expected.

## 0.6.0
Released on 2016-XX-XX.

### Added
- Support for Swift 3

### Changed
- Renamed a number of methods to make them conform to the [API Design Guidelines]

### Fixed
- Fix [#74] possible build failure on Carthage due to unneeded build dependency (PR [#76]).
- Fix inability to detect if user has skipped the flow (PR [#81]).

[API Design Guidelines]: https://swift.org/documentation/api-design-guidelines/
[#74]: https://github.com/ephread/Instructions/issues/74
[#76]: https://github.com/ephread/Instructions/issues/76
[#81]: https://github.com/ephread/Instructions/issues/81

## [0.5.0](https://github.com/ephread/Instructions/releases/tag/0.5.0)
Released on 2016-09-06.

### Fixed
- Fix [#63] dataSource methods wrongly called during idle state.
- Fix [#58] inability to restart the flow.

[#63]: https://github.com/ephread/Instructions/issues/63
[#58]: https://github.com/ephread/Instructions/issues/58

### Changed
- Deprecate calling helper methods directly from `CoachMarkController`, methods are now available through the `CoachMarkController.helper` object.
- Deprecate calling flow state properties directly from `CoachMarkController`, properties are now available through the `CoachMarkController.flow` object.
- Deprecate settings overlay parameters directly from `CoachMarkController`, properties are now available through the `CoachMarkController.overlay` object.

### Added
- Full support of App Extensions.

## [0.4.3](https://github.com/ephread/Instructions/releases/tag/0.4.3)
Released on 2016-08-10.

### Fixed
- Fix [#57], [#60] – Duplicated coach marks on rotation.
- Fix crash occurring on index 0 when `coachMarkWillLoadForIndex` returns false.

[#57]: https://github.com/ephread/Instructions/issues/57
[#60]: https://github.com/ephread/Instructions/issues/60

## [0.4.2](https://github.com/ephread/Instructions/releases/tag/0.4.2)
Released on 2016-07-07.

### Fixed
- Fix an issue where the `skipped` parameter was not set properly on `didFinishShowingAndWasSkipped`.
- Fix most timing issues, leading to multiple coach marks being displayed.

## [0.4.1](https://github.com/ephread/Instructions/releases/tag/0.4.1)
Released on 2016-07-04.

### Removed
- Remove partial support for App Extensions (will be added back in full for 0.5.0).

### Fixed
- Fix a bug caused by always-enabled touch inside the cutout path.
- Fix a crash occuring during background fetches.
- Fix the shift of cutout paths occuring when toggling the in-call status bar.

### Changed
- Change completion method signature in delegate; it now provides a boolean notifying whether the flow was skipped by the user.

## [0.4.0](https://github.com/ephread/Instructions/releases/tag/0.4.0)
Released on 2016-02-21.

### Changed
- Change `datasource` to `dataSource`.

### Added
- Add ability to manually specify where the coach should sit.
- Add ability to pilot the transitions/the flow from the code.
- Add ability to skip coach marks.

## [0.3.0](https://github.com/ephread/Instructions/releases/tag/0.3.0)
Released on 2015-10-31.

### Added
- Add ability to skip a tour.

## [0.2.1](https://github.com/ephread/Instructions/releases/tag/0.2.1)
Released on 2015-10-03.

### Fixed
- Wrap unavailable method into `if #available` block.

## [0.2.0](https://github.com/ephread/Instructions/releases/tag/0.2.0)
Released on 2015-10-03. ⚠️ Defective version

### Added
- Add full size transition support
- Add full right-to-left language support

## [0.1.2](https://github.com/ephread/Instructions/releases/tag/0.1.2)
Released on 2015-10-01.

### Added
- Add Carthage support

## [0.1.1](https://github.com/ephread/Instructions/releases/tag/0.1.1)
Released on 2015-10-01.

### Added
- Add CocoaPods support

## [0.1.0](https://github.com/ephread/Instructions/releases/tag/0.1.0)
Released on 2015-10-01.

### Added
- Initial release of Instructions.
