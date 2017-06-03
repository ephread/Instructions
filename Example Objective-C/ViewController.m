// ViewController.m
//
// Copyright (c) 2015 Frédéric Maquin <fred@ephread.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ViewController.h"
#import "InstructionsExampleObjectiveC-Swift.h"

@interface ViewController ()

#pragma mark - IBOutlet
@property (nonatomic, weak) IBOutlet UILabel *handleLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *postsLabel;
@property (nonatomic, weak) IBOutlet UILabel *reputationLabel;

#pragma mark - Private properties
@property (nonatomic, strong) InstructionsManager *instructionsManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.instructionsManager = [[InstructionsManager alloc] initWithParentViewController: self];

    self.instructionsManager.handleLabel = self.handleLabel;
    self.instructionsManager.emailLabel = self.emailLabel;
    self.instructionsManager.postsLabel = self.postsLabel;
    self.instructionsManager.reputationLabel = self.reputationLabel;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];

    [self.instructionsManager startTour];
}

@end
