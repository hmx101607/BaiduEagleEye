//
//  BMCustomAnnotationView.h
//  BaiMapEagleEye
//
//  Created by mason on 2017/7/12.
//
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface BMGISAnnotationView : BMKAnnotationView

@property (strong, nonatomic) NSString *content;
- (CGFloat)titleLengthWithContent:(NSString *)content;

@end
