//
//  HTTestEventTracker.m
//  HTEventLogger_Example
//
//  Created by Jason on 2022/11/23.
//  Copyright © 2022 nscribble. All rights reserved.
//

#import "HTTestEventTracker.h"

@implementation HTTestEventTracker

- (void)trackEvent:(NSString *)eventId properties:(NSDictionary *)properties {
    NSLog(@"⚠️Track [%@] properties: %@", eventId, properties);
}

@end
