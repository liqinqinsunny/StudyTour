//
//  TitleButton.m
//  新浪微博
//
//  Created by jeremy on 15/10/19.
//  Copyright (c) 2015年 lqq. All rights reserved.
//

#import "TitleButton.h"
#import "UIView+Extension.h"

@implementation TitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        [self setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.imageView.contentMode = UIViewContentModeLeft; // 图片不拉抻,在view的中间显示

        [self sizeToFit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.x = 0;
    self.titleLabel.x = CGRectGetMaxX(self.imageView.frame) + self.imageContentMargin;
    self.width = self.titleLabel.width + self.imageView.width + self.imageContentMargin;
    
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self sizeToFit];
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
}


@end
