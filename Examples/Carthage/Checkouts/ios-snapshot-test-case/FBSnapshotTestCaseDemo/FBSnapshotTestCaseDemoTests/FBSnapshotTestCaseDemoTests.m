/*
 *  Copyright (c) 2017-2018, Uber Technologies, Inc.
 *  Copyright (c) 2013-2018, Facebook, Inc.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

@interface FBSnapshotTestCaseDemoTests : FBSnapshotTestCase

@end

@implementation FBSnapshotTestCaseDemoTests

- (void)setUp
{
    [super setUp];
    // Flip this to YES to record images in the reference image directory.
    // You need to do this the first time you create a test and whenever you change the snapshotted views.
    // Tests running in record mode will always fail so that you know that you have to do something here before you commit.
    self.recordMode = NO;
}

- (void)testViewSnapshot
{
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    redView.backgroundColor = [UIColor redColor];
    FBSnapshotVerifyView(redView, nil);
    FBSnapshotVerifyLayer(redView.layer, nil);
}

- (void)testViewSnapshotWithVisualEffects
{
    if ([UIVisualEffect class]) {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        redView.backgroundColor = [UIColor redColor];
        visualEffectView.frame = CGRectMake(0, 0, 40, 40);

        UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        parentView.backgroundColor = [UIColor whiteColor];
        [parentView addSubview:redView];
        [parentView addSubview:visualEffectView];

        self.usesDrawViewHierarchyInRect = YES;
        FBSnapshotVerifyViewWithPixelOptions(parentView, nil, FBSnapshotTestCaseDefaultSuffixes(), 0.09, 0); // lowest perPixelTolerance for iPhone X is 0.04, but for iPhone 7 is 0.09
    }
}

- (void)testViewSnapshotWithUIAppearance
{
    [[UISwitch appearance] setOnTintColor:[UIColor blueColor]];
    [[UISwitch appearance] setThumbTintColor:[UIColor lightGrayColor]];
    UISwitch *control = [[UISwitch alloc] init];
    control.on = YES;

    self.usesDrawViewHierarchyInRect = YES;
    FBSnapshotVerifyViewWithPixelOptions(control, nil, FBSnapshotTestCaseDefaultSuffixes(), 0.65, 0);
}

- (void)testViewSnapshotWithUIAppearanceResizing
{
    [[UIButton appearance] setContentEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Click me!" forState:UIControlStateNormal];

    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:0
                                                        constant:65]];
    [button sizeToFit];

    self.usesDrawViewHierarchyInRect = YES;
    FBSnapshotVerifyViewWithPixelOptions(button, nil, FBSnapshotTestCaseDefaultSuffixes(), 0.25, 0);
}

- (void)testViewSnapshotWithDifferentBackgroundColorPerArchitecture
{
    UIColor *color = FBSnapshotTestCaseIs64Bit() ? [UIColor magentaColor] : [UIColor cyanColor];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    view.backgroundColor = color;
    FBSnapshotVerifyView(view, nil);
}

@end
