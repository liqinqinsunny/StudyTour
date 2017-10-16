//
//  DynamicCell.m
//  StudyTour
//
//  Created by use on 15/12/2.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "DynamicCell.h"

@interface DynamicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *dynamicImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDateLabel;

@end

@implementation DynamicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setState:(NSInteger)state
{
    _dynamicImageView.image = [UIImage imageNamed:@"PDF"];
    _contentLabel.text = @"你会在轻松愉快的环境下学习入门意大利语，感受意大利语的魅力。继续学习意大利美食 - 披萨饼的制作过程。之后前往威尼斯水城";
    _userDateLabel.text = @"徐启迪 2016-01-12 12:12";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
