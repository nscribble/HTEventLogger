//
//  HTEventLogger.m
//  HTEventLogger
//
//  Created by Jason on 2022/7/12.
//

#import "HTEventLogger.h"
#import "HTEventLogBuilder.h"

@interface HTEventLogger ()

@property (nonatomic, strong) id<HTEventTracker> eventTracker;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *commonProperties;

@end

@implementation HTEventLogger

/// 建议App持有实例
+ (instancetype)sharedLogger {
    static HTEventLogger *logger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logger = [[self alloc] init];
    });
    
    return logger;
}

- (void)setEventTracker:(id<HTEventTracker>)eventTracker {
    _eventTracker = eventTracker;
}

- (void)startWithTrackConfig:(NSString *)config launchOptions:(NSDictionary *)launchOptions {
    
}

- (void)registerCommonProperties:(NSDictionary *)properties {
    self.commonProperties = properties;
}

// MARK: -

- (void)logWithBuilder:(void (^)(HTEventLogBuilder * _Nonnull))buildBlock {
    HTEventLogBuilder *builder = [HTEventLogBuilder new];
    
    buildBlock(builder);
    
    [builder build];
    
    NSString *eventId = builder.trackEventId;
    NSMutableDictionary *properties = @{}.mutableCopy;
    [properties addEntriesFromDictionary:self.commonProperties];
    [properties addEntriesFromDictionary:builder.trackProperties];
    
#if DEBUG
    NSAssert(self.eventTracker != nil, @"请初始化配置`-setEventTracker:`");
#endif
    
    [self.eventTracker trackEvent:eventId properties:properties];
}



@end
