//
//  BMHomeViewController.m
//  BaiMapEagleEye
//
//  Created by mason on 2017/6/29.
//
//

#import "BMHomeViewController.h"
#import "BMAnnotationViewController.h"
#import "BMPathViewController.h"

static NSUInteger serviceID = 144550;
static NSString *AK = @"p28qGatn6SuGRQwOZAktXM3StRzSREP5";
static NSString *entityName = @"河长";

@interface BMHomeViewController ()

@end

@implementation BMHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (IBAction)annotationAction:(UIButton *)sender {
    BMAnnotationViewController *annotationVC = [BMAnnotationViewController create];
    [self.navigationController pushViewController:annotationVC animated:YES];
}


- (IBAction)pathAction:(UIButton *)sender {
    BMPathViewController *pathVC = [BMPathViewController create];
    
    [self.navigationController pushViewController:pathVC animated:YES];
}

@end
