//
//  BMPoint.h
//  BaiMapEagleEye
//
//  Created by mason on 2017/6/29.
//
//

#import <Foundation/Foundation.h>
#import "BMCustomAnnotation.h"

@interface BMPoint : NSObject<YYModel>

/** 时间 */
@property (copy, nonatomic) NSString *createTime;
/** direction */
@property (assign, nonatomic) CGFloat direction;
/** height */
@property (assign, nonatomic) CGFloat height;
/** latitude */
@property (copy, nonatomic) NSString *latitude;
/** longitude */
@property (copy, nonatomic) NSString *longitude;
/** radius */
@property (assign, nonatomic) CGFloat radius;
/** speed */
@property (copy, nonatomic) NSString *speed;
/** loc_time */
@property (assign, nonatomic) CGFloat locTime;

/** <##> */
@property (strong, nonatomic) BMCustomAnnotation *pointToAnnotation;


@end
