//
//  WJPHomeNewsCell.m
//  StudyTourLeaderSide
//
//  Created by use on 16/4/22.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "WJPHomeNewsCell.h"

@interface WJPHomeNewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *newsLabel;

@end

@implementation WJPHomeNewsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(WJPStudyNewsModel *)model
{
    _newsLabel.text = model.stadyTourTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
