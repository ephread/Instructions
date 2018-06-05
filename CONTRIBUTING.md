# How to contribute

We're very happy to hear that you wish to contribute! 🎊

Instructions is a fairly small project, so the rules aren't particularly tight. There are a few things to know, however.
For one, the current project maintainer is usually not very responsive and wishes to extend their apologies in that regard. 🤪

## Asking question / Reporting issues / Getting in touch

### I have a question

1. Check whether it has been asked before or not. You can either search through [issues] or use the search feature of [Gitter].
2. If it hasn't been asked before (or if you couldn't find it), ask a question in the Gitter room.
3. If you don't get feedback after a few days, open an issue instead.

If it's about getting help, please avoid sending e-mails directly to the project maintainer.
It's better to ask out in the open, the community greatly benefits when questions and answers are readily available.

Don't forget, asking questions is nothing to be ashamed of.

[issues]: https://github.com/ephread/Instructions/issues
[Gitter]: https://gitter.im/ephread/Instructions

### I encountered a bug

Open an issue or fix the bug yourself and submit a pull request!

### I think Instructions would be better with feature X

If you have an idea for a missing feature, open an issue.

### I want to code feature X

If you want to develop a specific feature and merge it back, it's better to notify the project maintainer beforehand.
You don't want to put in a significant amount of work and see your pull request refused because it doesn't fit the project's
vision. To get in touch with the project manager, you can either open a issue, poke them on Gitter or send them an email,
they will try to respond as quickly as possible!

## Adding code to Instructions

If you're tackling new code, here are a few things to remember.

### Style guide & linting

Instructions doesn't really have a style guide. We simply expect you to follow the existing style
(which more or less matches Apple recommendations). Instructions does come, however, with a [Swiftlint] configuration.

Swiftlint is integrated using a script phase, so you just need to install it (preferably with Homebrew). Make
sure that Swiflint is available on your computer and fix any linting error/warning it may output. The worst offenders
are usually trailing spaces and long lines.

All in all, make sure there are neither warnings nor error before submitting the pull request.

On a side note, don't forget that English is the current lingua franca, so variables, function names, comments, etc. are all
expected to be written in English 😉. Speaking of comments, they look better when they start with a capital and end
with a period. 🤘

[Swiftlint]: https://github.com/realm/SwiftLint

### License & contribution

Instructions is licensed under the MIT License. Save for oversights, the license is reproduced at the top of each file,
giving copyright to whomever wrote it. This MIT header must replace Xcode's default one. If the list of authors for a
given file starts to grow too much, it can be replaced by _Instructions contributors_.

We expect you to follow that convention. Instructions isn't a giant project with a hefty number of contributors,
so please don't be shy and credit yourself when you make a pull request. 👏

### Documentation

If you're adding a new feature, you should most likely update the README with a quick description of the feature.