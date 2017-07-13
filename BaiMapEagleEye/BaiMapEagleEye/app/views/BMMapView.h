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
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "BMCustomAnnotation.h"

@interface BMMapView : UIView

/** 地图 */
@property (strong, nonatomic, nullable) BMKMapView* mapView;

/** 持续定位: 默认为 NO */
@property (assign, nonatomic) BOOL keepOnLocation;
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
- (void)addAnnotations:(NSArray *_Nonnull)annotations;

- (void)updateAnnotationViewWithPointArray:(NSArray *_Nonnull)pointArray;

/**
 绘制轨迹

 @param array 轨迹集合
 */
- (void)drawPolygonWithCotionCoordinateds:(NSArray <BMCustomAnnotation *>*_Nonnull)array;


/**
 行政区划

 @param city 城市名字（必须）
 @param district 区县名字（可选）
 */
- (void) handleDistrictSearchWithCity:(NSString * _Nonnull)city district:(NSString * _Nullable)district;

@end













