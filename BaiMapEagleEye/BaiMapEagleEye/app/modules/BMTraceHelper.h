//
//  BMTraceHelper.h
//  BaiMapEagleEye
//
//  Created by mason on 2017/7/5.
//
//

#import <Foundation/Foundation.h>
#import "BMPoint.h"

@protocol BMTraceHelperDelegate <NSObject>

- (void)queryHistoryTrackWithPointArray:(NSArray *)pointArray;

@end

@interface BMTraceHelper : NSObject

@property (weak, nonatomic) id<BMTraceHelperDelegate>delegate;

/**
 配置鹰眼服务
 */
- (void)configEagleEyeService;

/**
 轨迹服务（完整的周期）
 */
- (void) startService;
- (void) stopService;
- (void) startGather;
- (void) stopGather;

/**
 实时位置查询的回调方法
 
 @param response 查询结果
 */
- (void)queryTrackLatestPoint;

/**
 里程查询的回调方法
 
 @param response 查询结果
 */
- (void)queryTrackDistance;

/**
 轨迹查询的回调方法
 
 @param response 查询结果
 */
- (void)queryTrackHistory;

@end
