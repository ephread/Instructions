fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios build_all

```sh
[bundle exec] fastlane ios build_all
```

Build all targets

### ios build_frameworks

```sh
[bundle exec] fastlane ios build_frameworks
```

Build frameworks

### ios build_examples

```sh
[bundle exec] fastlane ios build_examples
```

Build examples

### ios build

```sh
[bundle exec] fastlane ios build
```

Build the given scheme

### ios generate_snapshots

```sh
[bundle exec] fastlane ios generate_snapshots
```

Generate new snapshots for all simulators

### ios test_all

```sh
[bundle exec] fastlane ios test_all
```

Run full test suite

### ios test_snapshots

```sh
[bundle exec] fastlane ios test_snapshots
```

Run snapshot tests

### ios test_unit_and_ui

```sh
[bundle exec] fastlane ios test_unit_and_ui
```

Run Unit & UI tests

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
