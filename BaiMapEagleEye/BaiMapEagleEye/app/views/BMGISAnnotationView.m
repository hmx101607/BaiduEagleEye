//
//  BMCustomAnnotationView.m
//  BaiMapEagleEye
//
//  Created by mason on 2017/7/12.
//
//

#import "BMGISAnnotationView.h"
#import "BMGISView.h"

@interface BMGISAnnotationView()

/** <##> */
@property (strong, nonatomic) BMGISView *customView;


@end

@implementation BMGISAnnotationView

- (id)initWithAnnotation:(id <BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        BMGISView *customView = [BMGISView loadFromNib];
        [self addSubview:customView];
        self.customView = customView;
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.customView.titleLabel.text = content;
    self.customView.size = CGSizeMake([self titleLengthWithContent:content], 48.f);
    
}

- (CGFloat)titleLengthWithContent:(NSString *)content {
    return [content boundingRectWithSize:CGSizeMake(MAXFLOAT, 14.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]} context:nil].size.width;
}

@end
