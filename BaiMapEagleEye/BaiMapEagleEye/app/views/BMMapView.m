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
BMKLocationServiceDelegate
>

/** 定位服务 */
@property (strong, nonatomic) BMKLocationService *locService;
/** 定位点集合 */
@property (strong, nonatomic) NSArray *pointArray;
/** 轨迹 */
@property (strong, nonatomic) BMKPolyline *polyline;

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

- (void)mapViewWillAppear {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)mapViewWillDisappear {
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)setKeepOnLocation:(BOOL)keepOnLocation {
    _keepOnLocation = keepOnLocation;
    if (keepOnLocation) {
        [self stopUserLocationService];
        [self startUserLocationService];
    }
}


- (void)updateAnnotationViewWithPointArray:(NSArray *)pointArray {
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.pointArray = [pointArray copy];
    [self.mapView addAnnotations:pointArray];
}

- (void)drawPolygonWithCotionCoordinateds:(NSArray <BMCustomAnnotation *>*)array {
    CLLocationCoordinate2D paths[array.count];
    for (NSInteger i = 0; i < array.count; i++) {
        BMCustomAnnotation *point = array[i];
        CLLocationCoordinate2D coordinated = CLLocationCoordinate2DMake(point.coordinate.latitude, point.coordinate.longitude);
        paths[i] = coordinated;
    }
    
    self.polyline = [BMKPolyline polylineWithCoordinates:paths count:array.count];
    [self.mapView addOverlay:self.polyline];
    
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

- (void)addAnnotations:(NSArray *)annotations {
    [self.mapView addAnnotations:annotations];
}

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

//添加标注代理
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

//根据overlay生成对应的View:轨迹
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


- (NSArray *)pointArray {
    if (!_pointArray) {
        _pointArray = @[];
    }
    return _pointArray;
}


@end
