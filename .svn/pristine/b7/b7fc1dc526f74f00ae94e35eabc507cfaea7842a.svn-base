//
//  WJPLinkTaskCell.m
//  StudyTourLeaderSide
//
//  Created by use on 16/4/26.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "WJPLinkTaskCell.h"

@interface WJPLinkTaskCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *myContentView;

@end

@implementation WJPLinkTaskCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(WJPTaskModel *)model
{
    _model = model;
    _titleLabel.text = model.title;
    if (_model.noCustomBackgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor customBackgroundColor];
    }
    if (_model.noCustomContentColor) {
        self.myContentView.backgroundColor = [UIColor whiteColor];
    } else {
        self.myContentView.backgroundColor = [UIColor customBackgroundColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
