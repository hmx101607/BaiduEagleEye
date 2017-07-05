//
//  BMMapView.m
//  BaiMapEagleEye
//
//  Created by mason on 2017/7/4.
//
//

#import "BMMapView.h"

@interface BMMapView()
<
BMKMapViewDelegate,
BMKLocationServiceDelegate
>
/** 地图 */
@property (strong, nonatomic) BMKMapView* mapView;
/** 定位服务 */
@property (strong, nonatomic) BMKLocationService *locService;
/** 定位点集合 */
@property (strong, nonatomic) NSArray *pointArray;

@end

@implementation BMMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    mapView.zoomEnabledWithTap = NO;
    mapView.rotateEnabled = NO;
    [self.mapView setBackgroundColor:[UIColor whiteColor]];
    BMKMapStatus *status = self.mapView.getMapStatus;
    status.fLevel = 16.f;
    [self.mapView setMapStatus:status withAnimation:YES];
    self.mapView = mapView;
    
    [self startUserLocationService];
}

- (void)updateAnnotationViewWithPointArray:(NSArray *)pointArray {
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.pointArray = [pointArray copy];
    [self.mapView addAnnotations:pointArray];
}

- (void)mapViewWillAppear {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)mapViewWillDisappear {
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
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
    self.mapView.showsUserLocation = YES;//显示定位图层
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView updateLocationData:userLocation];
    });
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    DLog(@"error : %@", error);
}

//添加标注代理
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *annotationViewID = @"DCAddressAnnotationView";
    BMKPinAnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID];
        annotationView.animatesDrop = YES;
    }
    return annotationView;
}

- (NSArray *)pointArray {
    if (!_pointArray) {
        _pointArray = @[];
    }
    return _pointArray;
}


@end
