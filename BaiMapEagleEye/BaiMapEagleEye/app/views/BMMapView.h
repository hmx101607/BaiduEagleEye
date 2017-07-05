//
//  BMMapView.h
//  BaiMapEagleEye
//
//  Created by mason on 2017/7/4.
//
//

#import <UIKit/UIKit.h>
#import "BaiduTraceSDK/BaiduTraceSDK.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface BMMapView : UIView

- (void)updateAnnotationViewWithPointArray:(NSArray *)pointArray;

/**
 必须在controller中调用这两个方法，避免mapview无法释放问题
 */
- (void)mapViewWillAppear;
- (void)mapViewWillDisappear;

- (void)startUserLocationService;
- (void)stopUserLocationService;

@end
