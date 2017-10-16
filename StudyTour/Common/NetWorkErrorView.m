//
//  NetWorkErrorView.m
//  StudyTourLeaderSide
//
//  Created by use on 16/3/25.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "NetWorkErrorView.h"

@interface NetWorkErrorView ()

@property (weak, nonatomic) IBOutlet UIImageView *errorImageView;
@property (weak, nonatomic) IBOutlet UILabel *errorNoticeLabel;

@end

@implementation NetWorkErrorView

- (instancetype)init
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"NetWorkErrorView" owner:nil options:nil];
    return [nibContents lastObject];
}

- (void)setNoticeTitle:(NSString *)noticeTitle
{
    _errorNoticeLabel.text = noticeTitle;
}

- (void)setImageName:(NSString *)imageName
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:_imageName ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    _errorImageView.image = image;
}

- (IBAction)viewClicked:(UIButton *)sender {
    if (self.operateBlock) {
        self.operateBlock();
    }
}

@end
