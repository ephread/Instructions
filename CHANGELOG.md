# Change Log
Important changes to Instructions will be documented in this file.
Instructions follows [Semantic Versioning](http://semver.org/).
However, until it reaches 1.0.0, some breaking changes are to be expected.

## [0.4.2](https://github.com/ephread/Instructions/releases/tag/0.4.2)
Released on 2016-07-07.

### Fixed
- Fix an issue where the `skipped` parameter was not set properly on `didFinishShowingAndWasSkipped`.
- Fix most timing issues, leading to multiple coach marks being displayed.

## [0.4.1](https://github.com/ephread/Instructions/releases/tag/0.4.1)
Released on 2016-07-04.

### Removed
- Removed partial support for App Extensions (will be added back in full for 0.5.0).

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