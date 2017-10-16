//
//  WJPCircleProgressView.m
//  环形进度条
//
//  Created by use on 16/4/12.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "WJPCircleProgressView.h"


#define DefaultBackColor [UIColor customBackgroundColor]
#define DefaultFinishColor [UIColor themeColor]
#define DefaultUnFinishColor [UIColor themeColor]
#define DefaultCenterColor [UIColor clearColor]

@interface WJPCircleProgressView ()

@property (strong, nonatomic) CAShapeLayer *jp_backgroundLayer;
@property (strong, nonatomic) CAShapeLayer *jp_runningLayer;
@property (nonatomic, weak) UIImageView *stateImageView;

@end

@implementation WJPCircleProgressView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _percent = 0;
        _width = 0;
        
        [self.layer addSublayer:self.jp_backgroundLayer];
        [self.layer addSublayer:self.jp_runningLayer];
                
        //中间图片

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:@"btn_infolearning_nodownload.png"];
        [self addSubview:imageView];
        _stateImageView = imageView;
    }
    
    return self;
}

- (void)setPercent:(float)percent{
    if (percent > 1) {
        percent = 1;
    }
    self.jp_runningLayer.strokeEnd = percent;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(_percent);
    animation.toValue = @(percent);
    animation.duration = 0.3;
    [self.jp_runningLayer addAnimation:animation forKey:@"strokeEnd"];
    _percent = percent;

    if (percent == 1) {
        _stateImageView.image = [UIImage imageNamed:@"btn_infolearning_download.png"];
    } else {
        _stateImageView.image = [UIImage imageNamed:@"btn_infolearning_nodownload.png"];
    }
}

// 画 背景 层
- (CAShapeLayer *)jp_backgroundLayer
{
    if (!_jp_backgroundLayer) {
        _jp_backgroundLayer = [CAShapeLayer layer];
        
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        CGFloat radius = viewSize.width / 2;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius
                                                        startAngle:(-0.5) * M_PI
                                                          endAngle:(1.5f) * M_PI
                                                         clockwise:YES];
        _jp_backgroundLayer.borderColor = [UIColor blueColor].CGColor;
        _jp_backgroundLayer.borderWidth = 5.0f;
        _jp_backgroundLayer.lineWidth = 2;
        _jp_backgroundLayer.path = path.CGPath;
        _jp_backgroundLayer.fillColor = (_centerColor == nil) ?  DefaultCenterColor.CGColor : _centerColor.CGColor;
        _jp_backgroundLayer.strokeColor = (_arcBackColor == nil) ? DefaultBackColor.CGColor : _arcBackColor.CGColor;
    }
    return _jp_backgroundLayer;
}
// 画 动画层
- (CAShapeLayer *)jp_runningLayer
{
    if (!_jp_runningLayer) {
        _jp_runningLayer = [CAShapeLayer layer];
        
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        CGFloat radius = viewSize.width / 2;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius
                                                        startAngle:(-0.5) * M_PI
                                                          endAngle:(1.5) * M_PI
                                                         clockwise:YES];
        _jp_runningLayer.borderColor = [UIColor blueColor].CGColor;
        _jp_runningLayer.borderWidth = 5.0f;
        _jp_runningLayer.lineWidth = 2;
        _jp_runningLayer.path = path.CGPath;
        _jp_runningLayer.fillColor = [UIColor clearColor].CGColor;
        _jp_runningLayer.strokeColor = (_arcUnfinishColor == nil) ? DefaultUnFinishColor.CGColor : _arcUnfinishColor.CGColor;
    }
    return _jp_runningLayer;
}

@end
