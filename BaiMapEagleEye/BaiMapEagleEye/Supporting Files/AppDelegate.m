//
//  AppDelegate.m
//  BaiMapEagleEye
//
//  Created by mason on 2017/6/29.
//
//

#import "AppDelegate.h"
#import <FLEXManager.h>
#import <AFNetworkReachabilityManager.h>
#import "BMHomeViewController.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>


@interface AppDelegate()
<
BMKGeneralDelegate
>
@property (strong, nonatomic) BMKMapManager *mapManager;

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    BMHomeViewController *homeVC = [BMHomeViewController create];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    [self.window makeKeyAndVisible];
    
    [self addFlexTapGestureIfNeed];
    [self startNotifierNetWork];
    [self showBuildsNumber];
    
    [self configAMap];

    return YES;
}

- (void)configAMap
{
    if (!self.mapManager) {
        self.mapManager = [[BMKMapManager alloc]init];
    }
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [self.mapManager start:@"p28qGatn6SuGRQwOZAktXM3StRzSREP5"  generalDelegate:self];
    [BMKMapManager logEnable:NO module:BMKMapModuleTile];
    if (!ret) {
        DLog(@"manager start failed!");
    }
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        DLog(@"联网成功");
    }
    else{
        DLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        DLog(@"授权成功");
    }
    else {
        DLog(@"onGetPermissionState %d",iError);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark -------------------- About FLEX ---------------------
- (void)addFlexTapGestureIfNeed{
#ifdef DEBUG
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFlex:)];
    tapGR.numberOfTapsRequired = 2;
    tapGR.numberOfTouchesRequired = 2;
    [self.window addGestureRecognizer:tapGR];
#endif
}

- (void)didTapFlex:(UITapGestureRecognizer*)tapGR
{
    if (tapGR.state == UIGestureRecognizerStateRecognized) {
#if DEBUG
        [[FLEXManager sharedManager] showExplorer];
#endif
    }
}

- (void)showBuildsNumber{
    
    if (![[NSString infoByKey:@"CFBundleIdentifier" NeedEbg:NO] isEqualToString:FinalBundleID]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20)];
        label.text = [NSString stringWithFormat:@"Builds %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
        label.font = [UIFont systemFontOfSize:9];
        label.textAlignment = NSTextAlignmentCenter;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.window addSubview:label];
        });
    }
    
}


#pragma mark -
#pragma mark -------------------- Reachability ---------------------
- (void)startNotifierNetWork
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"已连接上wifi");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"正在使用蜂窝网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"网络已断开");
                break;
            default:
                break;
        }

    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

}


@end
