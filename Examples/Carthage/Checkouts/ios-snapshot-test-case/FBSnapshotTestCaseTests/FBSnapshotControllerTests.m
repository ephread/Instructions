/*
 *  Copyright (c) 2017-2018, Uber Technologies, Inc.
 *  Copyright (c) 2015-2018, Facebook, Inc.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

#import "FBSnapshotTestCasePlatform.h"
#import "FBSnapshotTestController.h"
#import <XCTest/XCTest.h>

@interface FBSnapshotControllerTests : XCTestCase

@end

@implementation FBSnapshotControllerTests

#pragma mark - Tests

- (void)testCompareReferenceImageToImageShouldBeEqual
{
    UIImage *referenceImage = [self _bundledImageNamed:@"square" type:@"png"];
    XCTAssertNotNil(referenceImage);
    UIImage *testImage = [self _bundledImageNamed:@"square-copy" type:@"png"];
    XCTAssertNotNil(testImage);

    id testClass = nil;
    FBSnapshotTestController *controller = [[FBSnapshotTestController alloc] initWithTestClass:testClass];
    NSError *error = nil;
    XCTAssertTrue([controller compareReferenceImage:referenceImage toImage:testImage overallTolerance:0 error:&error]);
    XCTAssertNil(error);
}

- (void)testCompareReferenceImageToImageShouldNotBeEqual
{
    UIImage *referenceImage = [self _bundledImageNamed:@"square" type:@"png"];
    XCTAssertNotNil(referenceImage);
    UIImage *testImage = [self _bundledImageNamed:@"square_with_text" type:@"png"];
    XCTAssertNotNil(testImage);

    id testClass = nil;
    FBSnapshotTestController *controller = [[FBSnapshotTestController alloc] initWithTestClass:testClass];
    NSError *error = nil;
    XCTAssertFalse([controller compareReferenceImage:referenceImage toImage:testImage overallTolerance:0 error:&error]);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, FBSnapshotTestControllerErrorCodeImagesDifferent);
}

- (void)testCompareReferenceImageWithVeryLowToleranceShouldNotMatch
{
    UIImage *referenceImage = [self _bundledImageNamed:@"square" type:@"png"];
    XCTAssertNotNil(referenceImage);
    UIImage *testImage = [self _bundledImageNamed:@"square_with_pixel" type:@"png"];
    XCTAssertNotNil(testImage);

    id testClass = nil;
    FBSnapshotTestController *controller = [[FBSnapshotTestController alloc] initWithTestClass:testClass];
    // With virtually no margin for error, this should fail to be equal
    NSError *error = nil;
    XCTAssertFalse([controller compareReferenceImage:referenceImage toImage:testImage overallTolerance:.0001 error:&error]);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, FBSnapshotTestControllerErrorCodeImagesDifferent);
}

- (void)testCompareReferenceImageWithVeryLowToleranceShouldMatch
{
    UIImage *referenceImage = [self _bundledImageNamed:@"square" type:@"png"];
    XCTAssertNotNil(referenceImage);
    UIImage *testImage = [self _bundledImageNamed:@"square_with_pixel" type:@"png"];
    XCTAssertNotNil(testImage);

    id testClass = nil;
    FBSnapshotTestController *controller = [[FBSnapshotTestController alloc] initWithTestClass:testClass];
    // With some tolerance these should be considered the same
    NSError *error = nil;
    XCTAssertTrue([controller compareReferenceImage:referenceImage toImage:testImage overallTolerance:.001 error:&error]);
    XCTAssertNil(error);
}

- (void)testCompareReferenceImageWithDifferentSizes
{
    UIImage *referenceImage = [self _bundledImageNamed:@"square" type:@"png"];
    XCTAssertNotNil(referenceImage);
    UIImage *testImage = [self _bundledImageNamed:@"rect" type:@"png"];
    XCTAssertNotNil(testImage);

    id testClass = nil;
    FBSnapshotTestController *controller = [[FBSnapshotTestController alloc] initWithTestClass:testClass];
    // With some tolerance these should be considered the same
    NSError *error = nil;
    XCTAssertFalse([controller compareReferenceImage:referenceImage toImage:testImage overallTolerance:0 error:&error]);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, FBSnapshotTestControllerErrorCodeImagesDifferentSizes);
}

- (void)testFailedImageWithFileNameOptionShouldHaveEachOptionInName
{
    UIImage *referenceImage = [self _bundledImageNamed:@"square" type:@"png"];
    XCTAssertNotNil(referenceImage);
    UIImage *testImage = [self _bundledImageNamed:@"square_with_pixel" type:@"png"];
    XCTAssertNotNil(testImage);
    
    NSUInteger FBSnapshotTestCaseFileNameIncludeOptionMaxOffset = 4;
    for (NSUInteger i = 0; i <= FBSnapshotTestCaseFileNameIncludeOptionMaxOffset; i++) {
        FBSnapshotTestCaseFileNameIncludeOption options = 1 << i;
        id testClass = nil;
        FBSnapshotTestController *controller = [[FBSnapshotTestController alloc] initWithTestClass:testClass];
        [controller setFileNameOptions:options];
        
        NSString *referenceImagesDirectory = @"/dev/null/";
        [controller setReferenceImagesDirectory:referenceImagesDirectory];
        NSError *error = nil;
        SEL selector = @selector(fileNameOptions);
        [controller referenceImageForSelector:selector identifier:@"" error:&error];
        XCTAssertNotNil(error);
        NSString *deviceIncludedReferencePath = FBFileNameIncludeNormalizedFileNameFromOption(NSStringFromSelector(selector), options);
        NSString *filePath = (NSString *)[error.userInfo objectForKey:FBReferenceImageFilePathKey];
        XCTAssertTrue([filePath containsString:deviceIncludedReferencePath]);
        
        NSString *expectedFilePath = [NSString stringWithFormat:@"%@%@.png", referenceImagesDirectory, deviceIncludedReferencePath];
        XCTAssertEqualObjects(expectedFilePath, filePath);
    }
}

- (void)testFailedImageWithFileNameOptionShouldHaveAllOptionsInName
{
    UIImage *referenceImage = [self _bundledImageNamed:@"square" type:@"png"];
    XCTAssertNotNil(referenceImage);
    UIImage *testImage = [self _bundledImageNamed:@"square_with_pixel" type:@"png"];
    XCTAssertNotNil(testImage);
    
    FBSnapshotTestCaseFileNameIncludeOption options = (FBSnapshotTestCaseFileNameIncludeOptionDevice | FBSnapshotTestCaseFileNameIncludeOptionOS | FBSnapshotTestCaseFileNameIncludeOptionScreenSize | FBSnapshotTestCaseFileNameIncludeOptionScreenScale);
    
    id testClass = nil;
    FBSnapshotTestController *controller = [[FBSnapshotTestController alloc] initWithTestClass:testClass];
    [controller setFileNameOptions:options];
    
    NSString *referenceImagesDirectory = @"/dev/null/";
    [controller setReferenceImagesDirectory:referenceImagesDirectory];
    NSError *error = nil;
    SEL selector = @selector(fileNameOptions);
    [controller referenceImageForSelector:selector identifier:@"" error:&error];
    XCTAssertNotNil(error);
    NSString *allOptionsIncludedReferencePath = FBFileNameIncludeNormalizedFileNameFromOption(NSStringFromSelector(selector), options);
    NSString *filePath = (NSString *)[error.userInfo objectForKey:FBReferenceImageFilePathKey];
    XCTAssertTrue([filePath containsString:allOptionsIncludedReferencePath]);
    
    // Manually constructing expected filePath to make sure it looks correct
    NSString *expectedFilePath = [NSString stringWithFormat:@"%@%@_%@_%@_%.0fx%.0f@%.fx.png",
                                  referenceImagesDirectory,
                                  NSStringFromSelector(selector),
                                  [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                                  [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@"_"],
                                  [UIScreen mainScreen].bounds.size.width,
                                  [UIScreen mainScreen].bounds.size.height,
                                  [[UIScreen mainScreen] scale]];
    XCTAssertEqualObjects(expectedFilePath, filePath);
}

- (void)testCompareReferenceImageWithLowPixelToleranceShouldNotMatch
{
    UIImage *referenceImage = [self _bundledImageNamed:@"square" type:@"png"];
    XCTAssertNotNil(referenceImage);
    UIImage *testImage = [self _bundledImageNamed:@"square_with_pixel" type:@"png"];
    XCTAssertNotNil(testImage);

    id testClass = nil;
    FBSnapshotTestController *controller = [[FBSnapshotTestController alloc] initWithTestClass:testClass];
    // With virtually no margin for error, this should fail to be equal
    NSError *error = nil;
    XCTAssertFalse([controller compareReferenceImage:referenceImage toImage:testImage perPixelTolerance:.06 overallTolerance:0 error:&error]);
    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, FBSnapshotTestControllerErrorCodeImagesDifferent);
}

- (void)testCompareReferenceImageWithLowPixelToleranceShouldMatch
{
    UIImage *referenceImage = [self _bundledImageNamed:@"rect" type:@"png"];
    XCTAssertNotNil(referenceImage);
    UIImage *testImage = [self _bundledImageNamed:@"rect_shade" type:@"png"];
    XCTAssertNotNil(testImage);

    id testClass = nil;
    FBSnapshotTestController *controller = [[FBSnapshotTestController alloc] initWithTestClass:testClass];
    // With some tolerance these should be considered the same
    NSError *error = nil;
    XCTAssertTrue([controller compareReferenceImage:referenceImage toImage:testImage perPixelTolerance:.06 overallTolerance:0 error:&error]);
    XCTAssertNil(error);
}

#pragma mark - Private helper methods

- (UIImage *)_bundledImageNamed:(NSString *)name type:(NSString *)type
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:name ofType:type];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [[UIImage alloc] initWithData:data];
}

@end
