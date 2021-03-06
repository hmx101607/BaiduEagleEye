//
//  BMAnnotationViewController.m
//  BaiMapEagleEye
//
//  Created by mason on 2017/6/29.
//
//

#import "BMAnnotationViewController.h"
#import "BMMapView.h"
#import "BMGISAnnotation.h"
#import "BMIconAnnotation.h"

@interface BMAnnotationViewController ()

/** 自定义地图视图 */
@property (strong, nonatomic) BMMapView *mapView;

@end

@implementation BMAnnotationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"标注";
    
    BMMapView *mapView = [[BMMapView alloc] init];
    mapView.frame = CGRectMake(0, 200.f, SCREEN_WIDTH , SCREEN_HEIGHT - 200.f);
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
//    [self.mapView handleDistrictSearchWithCity:@"长沙" district:nil];
}

- (IBAction)addStartPoint:(UIButton *)sender {
    //icon_nav_start.png
    BMIconAnnotation *annotation = [[BMIconAnnotation alloc] init];
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(28.200097 - 0.01, 113.050133 - 0.01);
    annotation.coordinate = locationCoordinate;
    annotation.imageName = @"QXLocationViewController-Annotation-normel";
    [self.mapView addAnnotations:@[annotation]];
}

- (IBAction)addEndPoint:(UIButton *)sender {
    BMIconAnnotation *annotation = [[BMIconAnnotation alloc] init];
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(28.200097 + 0.03, 113.050133 + 0.03);
    annotation.coordinate = locationCoordinate;
    annotation.imageName = @"QXLocationViewController-Annotation-selected";
    [self.mapView addAnnotations:@[annotation]];
}

- (IBAction)addNormalPoint:(UIButton *)sender {
    BMIconAnnotation *annotation = [[BMIconAnnotation alloc] init];
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(28.200097 + 0.08, 113.050133 + 0.08);
    annotation.coordinate = locationCoordinate;
    annotation.imageName = @"cell_nearby";
    [self.mapView addAnnotations:@[annotation]];
}

- (IBAction)addRiverPointAction:(UIButton *)sender {
    
    BMGISAnnotation *annotation = [[BMGISAnnotation alloc] init];
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(28.200097, 113.050133);
    annotation.coordinate = locationCoordinate;
    annotation.path = @"四方井";
    [self.mapView addAnnotations:@[annotation]];
}

- (IBAction)SwitchTopographicMapAction:(UIButton *)sender {
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1001:
        {
            self.mapView.mapView.mapType = BMKMapTypeNone;
            break;
        }
        case 1002:
        {
            self.mapView.mapView.mapType = BMKMapTypeStandard;
            break;
        }
        case 1003:
        {
            self.mapView.mapView.mapType = BMKMapTypeSatellite;
            break;
        }
        default:
            break;
    }
}


@end


















