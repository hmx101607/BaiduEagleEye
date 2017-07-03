//
//  TimeUtil.h
//  xiutai_ios
//
//  Created by mason on 16/4/21.
//
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

#pragma mark
#pragma mark - 全局日期时间显示格式

+ (NSString *)showTimeYYYYMMDDWithDate:(NSDate *)date;
+ (NSString *)showTimeYYYYMMDDWithDate:(NSDate *)date format:(NSString *)format;

+ (NSString *)showTimeYYYYMMDDWithDateString:(NSString *)dateStr;

+ (NSDate *)showDateWithDateString:(NSString *)dateStr format:(NSString *)format;
+ (NSDate *)showDateWithDateString:(NSString *)dateStr;
+ (NSString *)showFriendTimeWithDateStr:(NSString *)dateStr;

+ (NSString *)invalidTimeWithNum:(NSNumber *)invalidNum;

+ (NSString *)timeStringWithAMOrPMFromString:(NSString *)time;

+ (NSString *)timeStringFromTimeInterval:(NSTimeInterval)timeInterval;
+ (NSTimeInterval)timeIntervalFromTimeString:(NSString *)timeString;

+ (BOOL)compareTimeWithCurrentIsBigger:(NSString *)time;
+ (BOOL)compareTimeWithCurrentIsBiggerTwentyFourHour:(NSString *)time;

+ (NSString *)obtainCurrentTime;

+ (NSString *)obtainCurrentTimeBeforeSecond:(NSInteger)beforeTime;

+ (NSArray *) calcDaysFromBegin:(NSString *)inBegin end:(NSString *)inEnd dateByAddingDays:(NSInteger)days;

+ (NSTimeInterval)isBeforeSecond:(NSInteger)second time:(NSString *)time format:(NSString *)format;

//东呈
+ (NSString *)stringShowHHMMWithTime:(NSString *)time;

+ (NSString *)stringShowMMDDWithTime:(NSString *)time;

+ (NSNumber *)getWeekWithTime:(NSString *)time;

+ (NSString *)getWeek:(NSNumber *)weekDay;
@end
