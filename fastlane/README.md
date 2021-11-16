fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios build_all
```
fastlane ios build_all
```
Build all targets
### ios build_frameworks
```
fastlane ios build_frameworks
```
Build frameworks
### ios build_examples
```
fastlane ios build_examples
```
Build examples
### ios build
```
fastlane ios build
```
Build the given scheme
### ios generate_snapshots
```
fastlane ios generate_snapshots
```
Generate new snapshots for all simulators
### ios test_all
```
fastlane ios test_all
```
Run full test suite
### ios test_snapshots
```
fastlane ios test_snapshots
```
Run snapshot tests
### ios test_unit_and_ui
```
fastlane ios test_unit_and_ui
```
Run Unit & UI tests

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
