//
//  HTEventTrackerProtocol.h
//  HTEventLogger
//
//  Created by Jason on 2022/7/12.
//

#import <Foundation/Foundation.h>

/// 底层埋点库接口
/// @note 根据需要调整接口
@protocol HTEventTracker <NSObject>

/// 记录事件
/// @param eventId 事件id
/// @param properties 事件属性
- (void)trackEvent:(NSString *)eventId properties:(NSDictionary *)properties;

@end

typedef NS_ENUM(NSUInteger, HTTrackEventType) {
    HTTrackEventTypeUnkown,
    HTTrackEventTypeLoad,           // 未用
    HTTrackEventTypePageExposure,   // 页面曝光
    HTTrackEventTypePageQuit,       // 页面曝光结束
    HTTrackEventTypeClick,          // 点击
    HTTrackEventTypeExposure,       // 曝光（非页面，独立UI元素曝光事件）
    
    HTTrackEventTypeCustom,         // 自定义事件
};
