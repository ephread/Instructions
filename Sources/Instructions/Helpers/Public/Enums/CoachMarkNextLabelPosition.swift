// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

/// Available positions for the nextLabel.
/// A nextLabel can either be positioned right beside the hintLabel (.trailing / .leading) with a separator in between, or
/// be positioned at the corner of the body (.topTrailing / .topLeading / .bottomTrailing / .bottomLeading) without a separator.
public enum CoachMarkNextLabelPosition {
    case trailing
    case leading
    case topTrailing
    case topLeading
    case bottomTrailing
    case bottomLeading
}
