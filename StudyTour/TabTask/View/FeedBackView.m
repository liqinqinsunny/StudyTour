//
//  FeedBackView.m
//  StudyTour
//
//  Created by use on 15/12/3.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "FeedBackView.h"
#import "NSString+Frame.h"

@interface FeedBackView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation FeedBackView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor colorWithHex:0x2dcc70];
}

- (void)setContent:(NSString *)content
{
    _content = content;
    
    CGFloat contentHeight = [content heightWithFont:[UIFont systemFontOfSize:15] withinWidth:[UIScreen mainScreen].bounds.size.width-40];
    contentHeight = contentHeight > 54 ? 54 : contentHeight;
    
    CGFloat btnHeightExt = (ScreenWidth-70)*0.5*0.24 - 30;
    self.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, contentHeight+92+btnHeightExt);
    
    _titleLabel.text = [NSString stringWithFormat:@"每日反馈 - DAY%@", self.day];
    _contentLabel.text = content;
}

- (IBAction)satisfactionBtnClicked:(UIButton *)sender {
    if (sender.tag == 10) {
        if (self.satisfactionBlock) {
            self.satisfactionBlock(sender.tag);
        }
    } else if(sender.tag == 11) {
        if (self.satisfactionBlock) {
            self.satisfactionBlock(sender.tag);
        }
    }
}


@end