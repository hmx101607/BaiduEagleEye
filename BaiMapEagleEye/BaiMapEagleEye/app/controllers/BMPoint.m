//
//  BMPoint.m
//  BaiMapEagleEye
//
//  Created by mason on 2017/6/29.
//
//

#import "BMPoint.h"

@implementation BMPoint

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
             @"createTime" : @"create_time",
             @"locTime" : @"loc_time"
             };
}

- (BMCustomAnnotation *)pointToAnnotation {
    BMCustomAnnotation *annotation = [[BMCustomAnnotation alloc] init];
    
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake([self.latitude floatValue], [self.longitude floatValue]);
    annotation.coordinate = locationCoordinate;
    return annotation;
}

@end
