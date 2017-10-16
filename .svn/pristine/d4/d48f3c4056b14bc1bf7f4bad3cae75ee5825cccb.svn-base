//
//  TfeedBackView.m
//  StudyTour
//
//  Created by use on 15/12/4.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "TfeedBackView.h"
#import "NSString+Frame.h"

@interface TfeedBackView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *underline;

@end

@implementation TfeedBackView

- (void)setContent:(NSString *)content
{
    _content = content;
    
    CGFloat contentHeight = [content heightWithFont:[UIFont systemFontOfSize:15] withinWidth:[UIScreen mainScreen].bounds.size.width-40];
    contentHeight = contentHeight > 54 ? 54 : contentHeight;
    self.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, contentHeight+82);
    
    _titleLabel.text = [NSString stringWithFormat:@"每日反馈 - DAY%@", self.day];
    _contentLabel.text = content;
}
- (IBAction)moreOpinion_down:(UIButton *)sender {
    _underline.alpha = 0;
}

- (IBAction)moreOpinionCancel:(UIButton *)sender {
    _underline.alpha = 1;
}

- (IBAction)moreOpinionOut:(UIButton *)sender {
    _underline.alpha = 1;
}


- (IBAction)moreOpinion:(UIButton *)sender {
    _underline.alpha = 1;
    if (self.moreOpinionBlock) {
        self.moreOpinionBlock();
    }
//    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
//        _underline.alpha = 1;
//    } completion:^(BOOL finished) {
//        
//    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 75);
}

@end
