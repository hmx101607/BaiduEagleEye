//
//  BMGISAnnotation.h
//  BaiMapEagleEye
//
//  Created by mason on 2017/7/12.
//
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface BMGISAnnotation : BMKPointAnnotation

/** 名称 */
@property (strong, nonatomic) NSString *path;

@end
