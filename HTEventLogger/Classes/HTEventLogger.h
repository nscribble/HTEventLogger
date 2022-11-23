//
//  HTEventLogger.h
//  HTEventLogger
//
//  Created by Jason on 2022/7/12.
//

#import <Foundation/Foundation.h>
#import "HTEventLogBuilder.h"
#import "HTEventTrackerProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@interface HTEventLogger : NSObject

/// 建议App通过IoC等方式持有实例
+ (instancetype)sharedLogger;

/// 指定底层埋点库
/// @note 请在埋点前初始化
/// @param eventTracker 埋点库实例
- (void)setEventTracker:(id<HTEventTracker>)eventTracker;

/// 初始化配置
/// @note 请注意此为示例，请根据实际初始化提供接口
/// @param config 配置字符串
/// @param launchOptions 启动参数
- (void)startWithTrackConfig:(NSString *)config
               launchOptions:(NSDictionary *)launchOptions;

/// 配置基础属性等
/// @param properties $appVersion、$buildVersioin、$ip、$deviceId...
- (void)registerCommonProperties:(NSDictionary *)properties;

// MARK: -

/// 埋点
/// @param buildBlock 埋点构建代码块
- (void)logWithBuilder:(void(^)(HTEventLogBuilder *builder))buildBlock;

@end

NS_ASSUME_NONNULL_END
