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

static NSUInteger serviceID = 144550;
static NSString *AK = @"p28qGatn6SuGRQwOZAktXM3StRzSREP5";
static NSString *mcode = @"com.dossen.app";
static NSString *entityName = @"hezhang1";

@interface BMPathViewController ()
<
BTKTraceDelegate,
BTKTrackDelegate
>

@property (weak, nonatomic) IBOutlet UIView *baseView;

/** 地图 */
@property (strong, nonatomic) BMMapView *mapView;
/**  */
@property (strong, nonatomic) NSMutableArray *pointArray;
/**  */
@property (strong, nonatomic) NSString *entityName;

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
    [self configEagleEyeService];
    
    BMMapView *mapView = [[BMMapView alloc] init];
    [self.baseView addSubview:mapView];
    [mapView autoPinEdgesToSuperviewMargins];
    self.mapView = mapView;
}

#pragma mark - 配置地图服务
- (void)configEagleEyeService {
    // 使用SDK的任何功能前，都需要先调用initInfo:方法设置基础信息。
    BTKServiceOption *sop = [[BTKServiceOption alloc] initWithAK:AK mcode:mcode serviceID:serviceID keepAlive:true];
    [[BTKAction sharedInstance] initInfo:sop];
    //修改采集周期 ： 鹰眼iOS SDK默认的采集周期为5秒，上传周期为30秒
    //[[BTKAction sharedInstance] changeGatherAndPackIntervals:2 packInterval:10 delegate:self];
}


- (IBAction)startServiceAction:(UIButton *)sender {
    NSString *timeStr = [DateUtil showTimeYYYYMMDDWithDate:[NSDate date] format:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeInterval entityNameSuffix = [DateUtil timeIntervalFromTimeString:timeStr];
    NSString *entityNameStr = [NSString stringWithFormat:@"%@%.0f", entityName, entityNameSuffix];
    self.entityName = entityNameStr;
    DLog(@"entityNameStr : %@", entityNameStr);
    BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:entityNameStr];
//    [[BTKAction sharedInstance] setLocationAttributeWithActivityType:CLActivityTypeFitness desiredAccuracy:50 distanceFilter:5];
    // 开启服务
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BTKAction sharedInstance] startService:op delegate:self];
    });
}

- (IBAction)stopServiceAction:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{

    [[BTKAction sharedInstance] stopService:self];
        [self queryHitstoryTrack];
    });
}

- (IBAction)startGather:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BTKAction sharedInstance] startGather:self];
    });
    //创建定时器，每隔一定的时间去绘制轨迹
    
}

- (IBAction)stopGather:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BTKAction sharedInstance] stopGather:self];
    });
    //停止定时器，并去查询此次轨迹的所有点，并绘制完整的轨迹
}

#pragma mark - service轨迹服务 回调
-(void)onStartService:(BTKServiceErrorCode)error {
    NSLog(@"开启服务start service response: %lu", (unsigned long)error);
}

-(void)onStopService:(BTKServiceErrorCode)error {
    NSLog(@"停止服务stop service response: %lu", (unsigned long)error);
}

-(void)onStartGather:(BTKGatherErrorCode)error {
    NSLog(@"开始收集start gather response: %lu", (unsigned long)error);
}

-(void)onStopGather:(BTKGatherErrorCode)error {
    NSLog(@"停止收集stop gather response: %lu", (unsigned long)error);
}

-(void)onChangeGatherAndPackIntervals:(BTKChangeIntervalErrorCode)error {
    NSLog(@"change gather and pack intervals response: %lu", (unsigned long)error);
}

- (IBAction)queryTrackLatestPointAction:(UIButton *)sender {
    BTKQueryTrackProcessOption *option = [[BTKQueryTrackProcessOption alloc] init];
    option.denoise = FALSE;
    option.mapMatch = FALSE;
    option.radiusThreshold = 55;
    option.transportMode = BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_RIDING;
    BTKQueryTrackLatestPointRequest *request = [[BTKQueryTrackLatestPointRequest alloc] initWithEntityName:self.entityName processOption:option outputCootdType:BTK_COORDTYPE_BD09LL serviceID:serviceID tag:11];
    [[BTKTrackAction sharedInstance] queryTrackLatestPointWith:request delegate:self];
}

- (IBAction)queryTrackDistanceAction:(UIButton *)sender {
    NSUInteger endTime = [[NSDate date] timeIntervalSince1970];
    BTKQueryTrackProcessOption *option = [[BTKQueryTrackProcessOption alloc] init];
    option.denoise = TRUE;
    option.mapMatch = FALSE;
    option.radiusThreshold = 55;
    BTKQueryTrackDistanceRequest *request = [[BTKQueryTrackDistanceRequest alloc] initWithEntityName:self.entityName startTime:endTime - 84400 endTime:endTime isProcessed:TRUE processOption:option supplementMode:BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING serviceID:serviceID tag:12];
    [[BTKTrackAction sharedInstance] queryTrackDistanceWith:request delegate:self];
}

- (IBAction)queryTrackHistoryAction:(UIButton *)sender {
    [self queryHitstoryTrack];
}

- (void)queryHitstoryTrack {
    [self.mapView stopUserLocationService];
    
    NSUInteger endTime = [[NSDate date] timeIntervalSince1970];
    BTKQueryTrackProcessOption *option = [[BTKQueryTrackProcessOption alloc] init];
    option.denoise = FALSE;
    option.vacuate = FALSE;//抽稀属性只有查询历史轨迹时才有作用
    option.mapMatch = FALSE;
    option.radiusThreshold = 55;
    
    BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:@"hezhang11499169032" startTime:endTime - 84400 endTime:endTime isProcessed:TRUE processOption:option supplementMode:BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING outputCoordType:BTK_COORDTYPE_BD09LL sortType:BTK_TRACK_SORT_TYPE_ASC pageIndex:1 pageSize:100 serviceID:serviceID tag:13];
    [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];
}

/**
 实时位置查询的回调方法
 
 @param response 查询结果
 */
-(void)onQueryTrackLatestPoint:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"onQueryTrackLatestPoint: %@", dict);
}

/**
 里程查询的回调方法
 
 @param response 查询结果
 */
-(void)onQueryTrackDistance:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"onQueryTrackDistance: %@", dict);
}

/**
 轨迹查询的回调方法
 
 @param response 查询结果
 */
-(void)onQueryHistoryTrack:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"onQueryHistoryTrack: %@", dict);
    //查询完整轨迹（？是否需要将轨迹信息上传到后台【所有点或者一个标识】）
    NSDictionary *startPoint = dict[@"start_point"];
    NSDictionary *endPoint = dict[@"end_point"];
    NSArray *points = dict[@"points"];
    
    BMPoint *startPointModel = [BMPoint modelWithJSON:startPoint];
    BMPoint *endPointModel = [BMPoint modelWithJSON:endPoint];
    NSArray *pointsModel = [NSArray modelArrayWithClass:[BMPoint class] json:points];
    
    [self.pointArray removeAllObjects];
    if (startPointModel) {
        [self.pointArray addObject:[startPointModel pointToAnnotation]];
    }
    for (BMPoint *point in pointsModel) {
        [self.pointArray addObject:[point pointToAnnotation]];
    }
    if (endPointModel) {
        [self.pointArray addObject:[endPointModel pointToAnnotation]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView updateAnnotationViewWithPointArray:self.pointArray];
    });
}

//SDK在每个采集周期会回调改方法，将其返回值作为当前采集周期采集的轨迹点的自定义字段的值
-(NSDictionary *)onGetCustomData {
    NSMutableDictionary *customData = [NSMutableDictionary dictionaryWithCapacity:3];
    customData[@"entityName"] = self.entityName;
    return [NSDictionary dictionaryWithDictionary:customData];
}

- (NSMutableArray *)pointArray {
    if (!_pointArray) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
