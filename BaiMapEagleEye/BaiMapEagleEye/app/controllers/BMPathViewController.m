//
//  BMPathViewController.m
//  BaiMapEagleEye
//
//  Created by mason on 2017/6/29.
//
//

#import "BMPathViewController.h"
#import "DateUtil.h"
#import "BMPoint.h"
#import "BMMapView.h"
#import "BMTraceHelper.h"

static NSUInteger serviceID = 144550;
static NSString *AK = @"p28qGatn6SuGRQwOZAktXM3StRzSREP5";
static NSString *mcode = @"com.dossen.app";
static NSString *entityName = @"hezhang1";

@interface BMPathViewController ()
<
BTKTraceDelegate,
BTKTrackDelegate,
BMTraceHelperDelegate
>

@property (weak, nonatomic) IBOutlet UIView *baseView;

/** 地图 */
@property (strong, nonatomic) BMMapView *mapView;
/**  */
@property (strong, nonatomic) NSMutableArray *pointArray;
/**  */
@property (strong, nonatomic) NSString *entityName;

/** 轨迹跟踪帮助类 */
@property (strong, nonatomic) BMTraceHelper *traceHelper;


@end

@implementation BMPathViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView mapViewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView mapViewWillDisappear];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"轨迹";
    
    [self.traceHelper configEagleEyeService];
    
    BMMapView *mapView = [[BMMapView alloc] init];
    [self.baseView addSubview:mapView];
    [mapView autoPinEdgesToSuperviewMargins];
    self.mapView = mapView;
}

- (IBAction)startServiceAction:(UIButton *)sender {
    [self.traceHelper startService];
}

- (IBAction)stopServiceAction:(UIButton *)sender {
    [self.traceHelper stopService];
}

- (IBAction)startGather:(UIButton *)sender {
    //创建定时器，每隔一定的时间去绘制轨迹
    [self.traceHelper startGather];
}

- (IBAction)stopGather:(UIButton *)sender {
    //停止定时器，并去查询此次轨迹的所有点，并绘制完整的轨迹
    [self.traceHelper stopGather];
}


- (IBAction)queryTrackLatestPointAction:(UIButton *)sender {

}

- (IBAction)queryTrackDistanceAction:(UIButton *)sender {

}

- (IBAction)queryTrackHistoryAction:(UIButton *)sender {
    [self.traceHelper queryTrackHistory];
}


- (void)queryHistoryTrackWithPointArray:(NSArray<BMPoint *> *)pointArray {
    DLog(@"pointArray : %@", pointArray);
    [self.mapView updateAnnotationViewWithPointArray:pointArray];
}

- (BMTraceHelper *)traceHelper {
    if (!_traceHelper) {
        _traceHelper = [[BMTraceHelper alloc] init];
    }
    return _traceHelper;
}

@end
