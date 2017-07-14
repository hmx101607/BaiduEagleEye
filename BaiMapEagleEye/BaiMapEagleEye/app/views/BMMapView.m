//
//  BMMapView.m
//  BaiMapEagleEye
//
//  Created by mason on 2017/7/4.
//
//

#import "BMMapView.h"
#import "BMCustomAnnotation.h"
#import "BMGISAnnotationView.h"
#import "BMIconAnnotationView.h"
#import "BMGISAnnotation.h"
#import "BMIconAnnotation.h"
#import "BMPoint.h"

@interface BMMapView()
<
BMKMapViewDelegate,
BMKLocationServiceDelegate,
BMKDistrictSearchDelegate
>

/** 定位服务 */
@property (strong, nonatomic) BMKLocationService *locService;
/** 定位点集合 */
@property (strong, nonatomic) NSArray *pointArray;
/** 轨迹 */
@property (strong, nonatomic) BMKPolyline *polyline;

/** <##> */
@property (strong, nonatomic) BMKDistrictSearch *districtSearch;


@end

@implementation BMMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.keepOnLocation = NO;
        [self setupUI];
        
    }
    return self;
}

#pragma mark - setup UI
- (void)setupUI {
    BMKMapView *mapView = [[BMKMapView alloc] init];
    [mapView setMapType:BMKMapTypeStandard];
    [self addSubview:mapView];
    [mapView autoPinEdgesToSuperviewMargins];
    mapView.delegate = self;
    mapView.zoomEnabledWithTap = YES;
    mapView.rotateEnabled = NO;
    [self.mapView setBackgroundColor:[UIColor whiteColor]];
    BMKMapStatus *status = self.mapView.getMapStatus;
    status.fLevel = 16.f;
    [self.mapView setMapStatus:status withAnimation:YES];
    self.mapView = mapView;
    
    [self startUserLocationService];
}

#pragma mark - Private Method
- (void)mapViewWillAppear {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.districtSearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)mapViewWillDisappear {
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.districtSearch.delegate = nil;
}

- (void)setKeepOnLocation:(BOOL)keepOnLocation {
    _keepOnLocation = keepOnLocation;
    if (keepOnLocation) {
        [self stopUserLocationService];
        [self startUserLocationService];
    }
}

- (void)startUserLocationService {
    if (self.locService) {
        [self.locService startUserLocationService];
    } else {
        BMKLocationService *locService = [[BMKLocationService alloc]init];
        locService.delegate = self;
        //启动LocationService
        dispatch_async(dispatch_get_main_queue(), ^{
            [locService startUserLocationService];
        });
        self.locService = locService;
    }
}

- (void)stopUserLocationService {
    if (self.locService) {
        [self.locService stopUserLocationService];
    }
}

- (void)startUpdateLocation:(BMKUserLocation *)userLocation {
    if (userLocation) {
        [self.mapView updateLocationData:userLocation];
    } else {
        [self startUserLocationService];
    }
}

- (void)stopUpdateLocation:(BMKUserLocation *)userLocation {
    [self stopUserLocationService];
}

#pragma mark - +++++++++++++++++++++ 定位信息代理 Start ++++++++++++++++++++++++++++++
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    self.mapView.showsUserLocation = YES;//显示定位图层
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView updateLocationData:userLocation];
    });
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    DLog(@"userLocation.coordinate latitude : %lf , longitude: %lf", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    self.mapView.showsUserLocation = YES;//显示定位图层
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView updateLocationData:userLocation];
    });
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    if (!self.keepOnLocation) {
        [self stopUserLocationService];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    DLog(@"error : %@", error);
}
#pragma mark - +++++++++++++++++++++ 定位信息代理 end ++++++++++++++++++++++++++++++


#pragma mark - +++++++++++++++++++++ 添加或更新标注 Start ++++++++++++++++++++++++++++++
#pragma mark - 添加标注
- (void)addAnnotations:(NSArray *)annotations {
    [self.mapView addAnnotations:annotations];
}

- (void)updateAnnotationViewWithPointArray:(NSArray *)pointArray {
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.pointArray = [pointArray copy];
    [self.mapView addAnnotations:pointArray];
}

#pragma mark - Delegate 添加标注代理
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMGISAnnotation class]]) {
        NSString *identitier = @"BMCustomAnnotationView";
        BMGISAnnotation *gisAnnotation = (BMGISAnnotation *)annotation;
        BMGISAnnotationView *customView = (BMGISAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identitier];
        if (!customView) {
            customView = [[BMGISAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identitier];
        }
        NSString *content = gisAnnotation.path;
        customView.content = content;
        customView.canShowCallout = NO;
        customView.centerOffset = CGPointMake(-12.f, -48.f);
        return customView;
    } else if ([annotation isKindOfClass:[BMIconAnnotation class]]){
        
        NSString *identifier = @"BMIconAnnotationView";
        BMIconAnnotation *iconAnnotation = (BMIconAnnotation *)annotation;
        BMIconAnnotationView *iconAnnotationView = (BMIconAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!iconAnnotationView) {
            iconAnnotationView = [[BMIconAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        iconAnnotationView.imageName = iconAnnotation.imageName;
        return iconAnnotationView;
    } else {
        NSString *annotationViewID = @"DCAddressAnnotationView";
        BMKPinAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID];
            annotationView.animatesDrop = YES;
        }
        return annotationView;
    }
}
#pragma mark - +++++++++++++++++++++ 添加或更新标注 end ++++++++++++++++++++++++++++++


#pragma mark - +++++++++++++++++++++ 绘制轨迹 Start ++++++++++++++++++++++++++++++
#pragma mark - 绘制转换方法
- (void)drawPolygonWithCotionCoordinateds:(NSArray <BMCustomAnnotation *>*)array {
    CLLocationCoordinate2D paths[array.count];
    for (NSInteger i = 0; i < array.count; i++) {
        BMCustomAnnotation *point = array[i];
        CLLocationCoordinate2D coordinated = CLLocationCoordinate2DMake(point.coordinate.latitude, point.coordinate.longitude);
        paths[i] = coordinated;
    }
    
    self.polyline = [BMKPolyline polylineWithCoordinates:paths count:array.count];
    [self.mapView addOverlay:self.polyline];
    BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:paths count:array.count];
    [self mapViewFitPolygon:polygon];
    
    //添加起始点
    BMIconAnnotation *iconAnnotation1 = [[BMIconAnnotation alloc] init];
    BMCustomAnnotation *point1 = array.firstObject;
    iconAnnotation1.coordinate = point1.coordinate;
    iconAnnotation1.imageName = @"QXLocationViewController-Annotation-normel";
    [self.mapView addAnnotation:iconAnnotation1];
    
    //添加终点
    BMIconAnnotation *iconAnnotation2 = [[BMIconAnnotation alloc] init];
    BMCustomAnnotation *point2 = array.lastObject;
    iconAnnotation2.coordinate = point2.coordinate;
    iconAnnotation2.imageName = @"QXLocationViewController-Annotation-selected";
    [self.mapView addAnnotation:iconAnnotation2];
}


#pragma mark - Delegate 根据overlay生成对应的View:轨迹
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0.5 blue:0.0 alpha:0.6];
        polygonView.lineWidth = 2.0;
        polygonView.lineDash = YES;
        return polygonView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0.5 blue:0.0 alpha:0.6];
        polylineView.lineWidth = 2.0;
        polylineView.lineDash = YES;
        return polylineView;
    }
    return nil;
}
#pragma mark - +++++++++++++++++++++ 绘制轨迹 end ++++++++++++++++++++++++++++++

#pragma mark - +++++++++++++++++++++ 行政区划 Start ++++++++++++++++++++++++++++++
- (void) handleDistrictSearchWithCity:(NSString * _Nonnull)city district:(NSString * _Nullable)district {
    BMKDistrictSearchOption *option = [[BMKDistrictSearchOption alloc] init];
    option.city = city;
    option.district = district;
    BOOL flag = [self.districtSearch districtSearch:option];
    if (flag) {
        NSLog(@"district检索发送成功");
    } else {
        NSLog(@"district检索发送失败");
    }
}

/**
 *返回行政区域搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKDistrictSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDistrictResult:(BMKDistrictSearch *)searcher result:(BMKDistrictResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetDistrictResult error: %d", error);
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"\nname:%@\ncode:%d\ncenter latlon:%lf,%lf", result.name, (int)result.code, result.center.latitude, result.center.longitude);
        
        BOOL flag = YES;
        for (NSString *path in result.paths) {
            BMKPolygon* polygon = [self transferPathStringToPolygon:path];
            BMKPolyline *polyline = [self transferPathStringToPolyline:path];
            if (polygon) {
                [_mapView addOverlay:polyline]; // 添加overlay
                if (flag) {
                    [self mapViewFitPolygon:polygon];
                    flag = NO;
                }
            }
        }
    }
}


//根据polygone设置地图范围
- (void)mapViewFitPolygon:(BMKPolygon *) polygon {
    CGFloat ltX, ltY, rbX, rbY;
    if (polygon.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polygon.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polygon.pointCount; i++) {
        BMKMapPoint pt = polygon.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    
    CGFloat zoomLevel = _mapView.zoomLevel - 0.3;
    BMKMapStatus *mapStatus = [_mapView getMapStatus];
    mapStatus.fLevel = zoomLevel;
    [_mapView setMapStatus:mapStatus withAnimation:NO];
//    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

- (BMKPolygon*)transferPathStringToPolygon:(NSString*) path {
    if (path == nil || path.length < 1) {
        return nil;
    }
    NSArray *pts = [path componentsSeparatedByString:@";"];
    if (pts == nil || pts.count < 1) {
        return nil;
    }
    BMKMapPoint points[pts.count];
    NSInteger index = 0;
    for (NSString *ptStr in pts) {
        if (ptStr && [ptStr rangeOfString:@","].location != NSNotFound) {
            NSRange range = [ptStr rangeOfString:@","];
            NSString *xStr = [ptStr substringWithRange:NSMakeRange(0, range.location)];
            NSString *yStr = [ptStr substringWithRange:NSMakeRange(range.location + range.length, ptStr.length - range.location - range.length)];
            if (xStr && xStr.length > 0 && [xStr respondsToSelector:@selector(doubleValue)]
                && yStr && yStr.length > 0 && [yStr respondsToSelector:@selector(doubleValue)]) {
                points[index] = BMKMapPointMake(xStr.doubleValue, yStr.doubleValue);
                index++;
            }
        }
    }
    BMKPolygon *polygon = nil;
    if (index > 0) {
        polygon = [BMKPolygon polygonWithPoints:points count:index];
    }
    return polygon;
}

- (BMKPolyline*)transferPathStringToPolyline:(NSString*) path {
    if (path == nil || path.length < 1) {
        return nil;
    }
    NSArray *pts = [path componentsSeparatedByString:@";"];
    if (pts == nil || pts.count < 1) {
        return nil;
    }
    BMKMapPoint points[pts.count];
    NSInteger index = 0;
    for (NSString *ptStr in pts) {
        if (ptStr && [ptStr rangeOfString:@","].location != NSNotFound) {
            NSRange range = [ptStr rangeOfString:@","];
            NSString *xStr = [ptStr substringWithRange:NSMakeRange(0, range.location)];
            NSString *yStr = [ptStr substringWithRange:NSMakeRange(range.location + range.length, ptStr.length - range.location - range.length)];
            if (xStr && xStr.length > 0 && [xStr respondsToSelector:@selector(doubleValue)]
                && yStr && yStr.length > 0 && [yStr respondsToSelector:@selector(doubleValue)]) {
                points[index] = BMKMapPointMake(xStr.doubleValue, yStr.doubleValue);
                index++;
            }
        }
    }
    BMKPolyline *polyline = nil;
    if (index > 0) {
        polyline = [BMKPolyline polylineWithPoints:points count:pts.count];
    }
    return polyline;
}

#pragma mark - +++++++++++++++++++++ 行政区划 end ++++++++++++++++++++++++++++++
- (NSArray *)pointArray {
    if (!_pointArray) {
        _pointArray = @[];
    }
    return _pointArray;
}

- (BMKDistrictSearch *)districtSearch {
    if (!_districtSearch) {
        _districtSearch = [[BMKDistrictSearch alloc] init];
        _districtSearch.delegate = self;
    }
    return _districtSearch;
}

@end
