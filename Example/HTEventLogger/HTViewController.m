//
//  HTViewController.m
//  HTEventLogger
//
//  Created by nscribble on 11/23/2022.
//  Copyright (c) 2022 nscribble. All rights reserved.
//

#import "HTViewController.h"
#import <HTEventLogger/HTEventLogger.h>
#import "HTEventLogger_Example-Swift.h"

@interface HTViewController ()

@end

@implementation HTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[HTEventLogger sharedLogger] logWithBuilder:^(HTEventLogBuilder * _Nonnull builder) {
        builder.event(@"pageload")
            .eventType(@"any");
    }];
    
    HTTestViewController *vc = [HTTestViewController new];
    [self.view addSubview:vc.view];
    vc.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [vc.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [vc.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [vc.view.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [vc.view.heightAnchor constraintEqualToAnchor:self.view.heightAnchor]
    ]];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
}



@end
