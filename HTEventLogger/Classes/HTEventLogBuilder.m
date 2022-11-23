//
//  HTEventLogBuilder.m
//  HTEventLogger
//
//  Created by Jason on 2022/7/12.
//

#import "HTEventLogBuilder.h"
#import "HTEventTrackerProtocol.h"

@interface HTEventLogBuilder ()

@property (nonatomic, assign) HTTrackEventType HTTrackEventType;

@property (nonatomic, strong) NSString *paramEventType;
@property (nonatomic, strong) NSString *paramEventId;

@property (nonatomic, strong) NSString *paramPageId;
@property (nonatomic, strong) NSString *paramSessionKey;

@property (nonatomic, strong) NSString *paramEventExt;
@property (nonatomic, strong) NSDictionary *paramExt;

@property (nonatomic, strong) NSDictionary *paramProperties;

/// 用户自定义的属性（放在event_type、ext同一层级）
@property (nonatomic, strong) NSDictionary *extraProperties;

@end

@implementation HTEventLogBuilder

// MARK: - Build

- (void)build {
    
}

- (NSString *)trackEventId {
    switch (self.HTTrackEventType) {
        case HTTrackEventTypeUnkown: {
            NSAssert(NO, @"未明确的事件⚠️请指定click或exposure或自定义event");
            return @"";
        }
            
        case HTTrackEventTypeLoad: {
            NSAssert(NO, @"unsupported HTTrackEventTypeLoad");
            return @"unsupported";
        }
            
        case HTTrackEventTypePageExposure:
        case HTTrackEventTypePageQuit:
        case HTTrackEventTypeExposure: {
            return self.paramEventId ?: self.paramPageId;
        }
            
        case HTTrackEventTypeClick: {
            return self.paramEventId;
        }
        case HTTrackEventTypeCustom: {
            return self.paramEventId;
        }
    }
    return self.paramEventId ?: @"";
}

- (NSDictionary *)trackProperties {
    NSMutableDictionary *properties = @{}.mutableCopy;
    
    if (self.paramProperties) {
        [properties addEntriesFromDictionary:self.paramProperties];
    }
    
    NSString *eventType = self.paramEventType ?: [self paramEventTypeFromHTTrackEventType];
    NSString *pageId = self.paramPageId ?: @"";
    NSString *sessionKey = self.paramSessionKey ?: @"";
    NSString *extString = [self extString] ?: @"";
    
    properties[@"page_id"] = pageId;
    properties[@"event_type"] = eventType;
    properties[@"session_key"] = sessionKey;
    properties[@"ext"] = extString;
    
    return properties;
}

// MARK: - Private

- (NSString *)paramEventTypeFromHTTrackEventType {
    switch (self.HTTrackEventType) {
        case HTTrackEventTypeUnkown:
        case HTTrackEventTypeLoad:
            return @"";
            
        case HTTrackEventTypePageExposure:
            return @"exposure";
        case HTTrackEventTypePageQuit:
            return @"quit";
        case HTTrackEventTypeClick:
            return @"click";
        case HTTrackEventTypeExposure:
            return @"exposure";
            
        case HTTrackEventTypeCustom: {// 自定义事件类型需要指定
            NSAssert(NO, @"未指定`eventType`字段⚠️请指定 [%@] 事件的类型", self.paramEventId);
            return @"";
        }
    }
    
    return @"";
}

- (NSString *)extString {
    if (![self.paramExt isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.paramExt options:kNilOptions error:&error];
    if (error || !jsonData) {
        return nil;
    }
    
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return result;
}

// MARK: - Configuration

- (HTEventLogBuilder * _Nonnull (^)(NSString * _Nonnull))click {
    return ^HTEventLogBuilder *(NSString *eventId) {
        self.paramEventId = eventId;
        self.HTTrackEventType = HTTrackEventTypeClick;
        return self;
    };
}

- (HTEventLogBuilder * _Nonnull (^)(NSString * _Nonnull))pageExposureEnter {
    return ^HTEventLogBuilder *(NSString *pageId) {
        self.paramPageId = pageId;
        self.HTTrackEventType = HTTrackEventTypePageExposure;
        return self;
    };
}

- (HTEventLogBuilder * _Nonnull (^)(NSString * _Nonnull))pageExposureQuit {
    return ^HTEventLogBuilder *(NSString *pageId) {
        self.paramPageId = pageId;
        self.HTTrackEventType = HTTrackEventTypePageQuit;
        return self;
    };
}

- (HTEventLogBuilder * _Nonnull (^)(NSString * _Nonnull))exposure {
    return ^HTEventLogBuilder *(NSString *eventId) {
        self.paramEventId = eventId;
        self.HTTrackEventType = HTTrackEventTypeExposure;
        return self;
    };
}

- (HTEventLogBuilder * _Nonnull (^)(NSString * _Nonnull))event {
    return ^HTEventLogBuilder *(NSString *eventId) {
        self.paramEventId = eventId;
        self.HTTrackEventType = HTTrackEventTypeCustom;
        return self;
    };
}

// MARK: -

- (HTEventLogBuilder * _Nonnull (^)(NSString * _Nonnull))sessionKey {
    return ^HTEventLogBuilder *(NSString *sessionKey) {
        self.paramSessionKey = sessionKey;
        return self;
    };
}

- (HTEventLogBuilder * _Nonnull (^)(NSString * _Nonnull))pageId {
    return ^HTEventLogBuilder *(NSString *pageId) {
        self.paramPageId = pageId;
        return self;
    };
}

- (HTEventLogBuilder * _Nonnull (^)(NSString * _Nonnull))eventType {
    return ^HTEventLogBuilder *(NSString *eventType) {
        self.paramEventType = eventType;
        return self;
    };
}

- (HTEventLogBuilder * _Nonnull (^)(NSDictionary<NSString *,NSString *> * _Nonnull))properties {
    return ^HTEventLogBuilder *(NSDictionary<NSString *,NSString *> *properties) {
        self.paramProperties = properties;
        return self;
    };
}

- (HTEventLogBuilder * _Nonnull (^)(NSDictionary<NSString *,NSString *> * _Nonnull))ext {
    return ^HTEventLogBuilder *(NSDictionary<NSString *,NSString *> *ext) {
        self.paramExt = ext;
        return self;
    };
}

- (HTEventLogBuilder * _Nonnull (^)(NSString * _Nonnull))eventExt {
    return ^HTEventLogBuilder *(NSString *eventExt) {
        self.paramEventExt = eventExt;
        return self;
    };
}

@end
