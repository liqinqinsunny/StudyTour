//
//  FfeedBackView.m
//  StudyTour
//
//  Created by use on 15/12/11.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "FfeedBackView.h"
#import "NSString+Frame.h"

@interface FfeedBackView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation FfeedBackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setContent:(NSString *)content
{
    _content = content;
    
    CGFloat contentHeight = [content heightWithFont:[UIFont systemFontOfSize:15] withinWidth:[UIScreen mainScreen].bounds.size.width-40];
    contentHeight = contentHeight > 54 ? 54 : contentHeight;
    self.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, contentHeight+82);
    
    _titleLabel.text = [NSString stringWithFormat:@"每日反馈 - DAY%@", self.day];
    _contentLabel.text = content;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 75);
}

@end
