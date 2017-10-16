//
//  RadioOrMultiBtn.m
//  StudyTour
//
//  Created by lqq on 16/6/21.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "RadioOrMultiBtn.h"
#import "UIView+Extension.h"
#import "NSString+Frame.h"
#define titlefont [UIFont systemFontOfSize:14]
@implementation RadioOrMultiBtn

- (instancetype)init
{
    if (self = [super init]) {
        [self setTitleColor:[UIColor colorWithHex:0x333333 alpha:1] forState:UIControlStateNormal];
        self.titleLabel.font = titlefont;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.titleLabel.lineBreakMode = 0;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return self;
}

- (void)setModel:(RadioOrMultiModel *)model
{
    _model = model;
    
    [self setTitle:model.title forState:UIControlStateNormal];
    if ([model.type isEqualToString:@"多选"]) {
        [self setImage:[UIImage imageNamed:@"ic_question_uncheck"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"ic_question_checked"] forState:UIControlStateSelected];
    } else if ([model.type isEqualToString:@"单选"]){
        [self setImage:[UIImage imageNamed:@"ic_question_single_uncheck"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"ic_question_single_checked"] forState:UIControlStateSelected];
    }
    if ([model.value isEqual:@1]) {
        self.selected = YES;
    }else {
        self.selected = NO;
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self sizeToFit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.y = self.titleLabel.y + 2;
}


- (void)setFrame:(CGRect)frame
{
    CGFloat imgW = self.currentImage.size.width ;
    CGFloat imgH = self.currentImage.size.height;
    CGFloat titleW = self.width - imgW - 10;
 
    CGFloat titleH = [self.currentTitle heightWithFont:titlefont withinWidth:titleW];
    if (titleH > imgH) {
        frame.size.height = titleH;
    }
    [super setFrame:frame];
}

@end
