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

- (void) startService;
- (void) stopService;
- (void) startGather;
- (void) stopGather;

- (void)queryTrackLatestPoint;
- (void)queryTrackDistance;
/**
 轨迹查询
 */
- (void)queryTrackHistory;

@end
