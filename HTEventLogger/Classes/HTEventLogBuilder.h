//
//  HTEventLogBuilder.h
//  HTEventLogger
//
//  Created by Jason on 2022/7/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 单条埋点构建器
/// @note 需根据项目需要调整
@interface HTEventLogBuilder : NSObject

/// 点击事件
@property (nonatomic, strong, readonly) HTEventLogBuilder *(^click)(NSString *eventId);
/// 页面曝光事件「开始」
@property (nonatomic, strong, readonly) HTEventLogBuilder *(^pageExposureEnter)(NSString *pageId);
/// 页面曝光事件「结束」
@property (nonatomic, strong, readonly) HTEventLogBuilder *(^pageExposureQuit)(NSString *pageId);
/// 曝光事件（比如Cell曝光）
@property (nonatomic, strong, readonly) HTEventLogBuilder *(^exposure)(NSString *eventId);


/// 自定义事件
@property (nonatomic, strong, readonly) HTEventLogBuilder *(^event)(NSString *eventId);


/// 事件类型：可自定义click/exposure/quit之外类型
@property (nonatomic, strong, readonly) HTEventLogBuilder *(^eventType)(NSString *eventType);
/// 页面id：对于需要附加pageId的事件可以指定，比如click事件
@property (nonatomic, strong, readonly) HTEventLogBuilder *(^pageId)(NSString *pageId);
/// sessionKey：对于需要附加sessionKey的事件可以指定，比如VC的页面曝光的关联sessionKey
@property (nonatomic, strong, readonly) HTEventLogBuilder *(^sessionKey)(NSString *sessionKey);

/// properties：埋点自定义参数
@property (nonatomic, strong, readonly) HTEventLogBuilder *(^properties)(NSDictionary<NSString *, NSString *> *properties);

/// ext：拓展埋点参数，请见埋点文档需求
@property (nonatomic, strong, readonly) HTEventLogBuilder *(^ext)(NSDictionary<NSString *, NSString *> *ext);
/// event_ext：请见埋点文档需求
@property (nonatomic, strong, readonly) HTEventLogBuilder *(^eventExt)(NSString *eventExt);

/// 构建参数
- (void)build;

/// 事件id
- (NSString *)trackEventId;

/// 除了eventId之外的其他埋点属性
- (NSDictionary *)trackProperties;

@end

NS_ASSUME_NONNULL_END
