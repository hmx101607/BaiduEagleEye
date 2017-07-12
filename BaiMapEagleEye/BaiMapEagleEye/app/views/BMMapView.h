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

/** 持续定位: 默认为 NO */
@property (assign, nonatomic) BOOL keepOnLocation;

- (void)updateAnnotationViewWithPointArray:(NSArray *)pointArray;
/**
 必须在controller中调用这两个方法，避免mapview无法释放问题
 */
- (void)mapViewWillAppear;
- (void)mapViewWillDisappear;

- (void)startUserLocationService;
- (void)stopUserLocationService;


/**
 添加标注

 @param annotations 标注集合
 */
- (void)addAnnotations:(NSArray *)annotations;

@end
