//
//  TimeUtil.m
//  xiutai_ios
//
//  Created by mason on 16/4/21.
//
//

#import "DateUtil.h"

#define DefaultDateFormatter                    @"yyyy-MM-dd'T'HH:mm:ss.SSSz"  //"2015-10-29T19:14:57.231680+08:00"

@implementation DateUtil

+ (NSString *)showTimeYYYYMMDDWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

+ (NSString *)showTimeYYYYMMDDWithDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

+ (NSString *)showTimeYYYYMMDDWithDateString:(NSString *)dateStr{
    return [self showTimeYYYYMMDDWithDate:[self showDateWithDateString:dateStr]];
}

+ (NSString *)weekDay:(NSString *)timeStr{
    return nil;
}

+ (NSDate *)showDateWithDateString:(NSString *)dateStr format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:dateStr];
}

+ (NSDate *)showDateWithDateString:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = DefaultDateFormatter;
    return [dateFormatter dateFromString:dateStr];
}

+ (NSString *)showFriendTimeWithDateStr:(NSString *)dateStr
{
    NSDate *date = [self showDateWithDateString:dateStr];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    if ([date isToday]) {
        formatter.dateFormat = @"HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd hh:mm";
    }
    return [formatter stringFromDate:date];
}

+ (NSString *)invalidTimeWithNum:(NSNumber *)invalidNum{
    NSInteger day = invalidNum.integerValue/(24*3600);
    NSInteger hour = invalidNum.integerValue/3600;
    NSInteger minute = invalidNum.integerValue/60;
    if (invalidNum.integerValue<=0) {
        return nil;
    }
    
    if (day>2) {
        return [NSString stringWithFormat:@"%@天",@(day)];
    }else if (hour>0) {
        return [NSString stringWithFormat:@"%@小时",@(hour)];
    }else {
        return [NSString stringWithFormat:@"%@分钟",@(minute)];
    }
}

+ (NSString *)timeStringWithAMOrPMFromString:(NSString *)time
{
    NSTimeInterval timeInterval = [self timeIntervalFromTimeString:time];
    return [self timeStringFromTimeInterval:timeInterval];
}

#pragma mark -
#pragma mark timeStringFromTimeInterval
//时间戳-->时间
+ (NSString *)timeStringFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm a"];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"Australia"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *timeString = [formatter stringFromDate:date];
    
    return timeString;
}

#pragma mark -
#pragma mark timeIntervalFromTimeString
//时间-->时间戳
+ (NSTimeInterval)timeIntervalFromTimeString:(NSString *)timeString
{
    if ([timeString componentsSeparatedByString:@":"].count >= 3) {
        return [self timeIntervalFromTimeString:timeString format:@"YYYY-MM-dd HH:mm:ss"];
    } else {
        return [self timeIntervalFromTimeString:timeString format:@"YYYY-MM-dd HH:mm"];
    }
}

+ (NSTimeInterval)timeIntervalFromTimeString:(NSString *)timeString format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:format];
    
    NSDate *date = [dateFormatter dateFromString:timeString];
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
    return timeInterval;
}

+ (BOOL)compareTimeWithCurrentIsBigger:(NSString *)time
{
    NSInteger currentIntervael = [[self obtainCurrentTime] integerValue];
    NSTimeInterval timeInterval = [self timeIntervalFromTimeString:time];
    if (currentIntervael > timeInterval) {
        return YES;
    }
    return NO;
}

+ (BOOL)compareTimeWithCurrentIsBiggerTwentyFourHour:(NSString *)time
{
    NSInteger currentIntervael = [[self obtainCurrentTime] integerValue] + 24 * 60 * 60;
    NSTimeInterval timeInterval = [self timeIntervalFromTimeString:time];
    if (currentIntervael >= timeInterval) {
        return YES;
    }
    return NO;
}

//获取当前时间的时间戳，并转换成NSString
+ (NSString *)obtainCurrentTime
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger intervael = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:intervael];
    NSString *nowTime = [NSString stringWithFormat:@"%ld",(long)[localDate timeIntervalSince1970]];
    return nowTime;
}

+ (NSString *)obtainCurrentTimeBeforeSecond:(NSInteger)beforeTime
{
    NSDate *date = [[NSDate alloc] initWithTimeInterval:beforeTime sinceDate:[NSDate date]];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger intervael = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:intervael];
    NSString *nowTime = [NSString stringWithFormat:@"%ld",(long)[localDate timeIntervalSince1970]];
    return nowTime;
}


+ (NSArray *) calcDaysFromBegin:(NSString *)inBegin end:(NSString *)inEnd dateByAddingDays:(NSInteger)days
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *dateBegin = [dateFormatter dateFromString:inBegin];
    NSDate *dateEnd = [dateFormatter dateFromString:inEnd];
    
    NSInteger unitFlags = NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [cal components:unitFlags fromDate:dateBegin];
    NSDate *newBegin  = [[cal dateFromComponents:comps] dateByAddingDays:-days];
    
    NSCalendar *cal2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps2 = [cal2 components:unitFlags fromDate:dateEnd];
    NSDate *newEnd  = [[cal2 dateFromComponents:comps2] dateByAddingDays:days];
    
    NSTimeInterval interval = [newEnd timeIntervalSinceDate:newBegin];
    NSInteger beginDays=((NSInteger)interval)/(3600*24);

    NSMutableArray *dateArray = [NSMutableArray array];
    for (NSInteger i = 0; i < beginDays + 1; i++) {
        NSDate *date = [newBegin dateByAddingDays:i];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        [dateArray addObject:dateStr];
    }
    return [dateArray mutableCopy];
}

+ (NSTimeInterval)isBeforeSecond:(NSInteger)second time:(NSString *)time format:(NSString *)format
{
    NSTimeInterval timeInterval = [self timeIntervalFromTimeString:time format:format];
    timeInterval += second;
    
    return timeInterval;
}

+ (NSString *)stringShowHHMMWithTime:(NSString *)time
{
    NSTimeInterval timeInterval = [self timeIntervalFromTimeString:time format:@"YYYY-MM-dd HH:mm:ss"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    formatter.locale = [NSLocale systemLocale];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;

}

+ (NSString *)stringShowMMDDWithTime:(NSString *)time
{
    NSTimeInterval timeInterval = [self timeIntervalFromTimeString:time format:@"YYYY-MM-dd HH:mm:ss"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    formatter.locale = [NSLocale systemLocale];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

+ (NSNumber *)getWeekWithTime:(NSString *)time
{
    NSTimeInterval timeInterval = [self timeIntervalFromTimeString:time format:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];

    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    return @([comps weekday]);
}

+ (NSString *)getWeek:(NSNumber *)weekDay
{
    switch (weekDay.integerValue) {
        case 1:
            return @"周日";
        case 2:
            return @"周一";
        case 3:
            return @"周二";
        case 4:
            return @"周三";
        case 5:
            return @"周四";
        case 6:
            return @"周五";
        case 7:
            return @"周六";
    }
    return nil;
}


@end
