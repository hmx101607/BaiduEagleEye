//
//  BMIconAnnotationView.m
//  BaiMapEagleEye
//
//  Created by mason on 2017/7/12.
//
//

#import "BMIconAnnotationView.h"

@implementation BMIconAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.image = [UIImage imageNamed:imageName];

}

@end
