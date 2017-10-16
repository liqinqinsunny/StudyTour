//
//  EnrollTeacherCell.m
//  StudyTourLeaderSide
//
//  Created by use on 16/3/3.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "EnrollTeacherCell.h"
#import "TeacherInfoModel.h"

@interface EnrollTeacherCell ()

@property (weak, nonatomic) IBOutlet UIImageView *teacherPhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eduLabel;
@property (weak, nonatomic) IBOutlet UILabel *letterLabel;
@property (weak, nonatomic) IBOutlet UILabel *membersLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;


@end


@implementation EnrollTeacherCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(TeacherInfoModel *)model
{
    [_teacherPhoto sd_setImageWithURL:[NSURL URLWithString:model.photoUrl]];
    _nameLabel.text = model.name;
    _eduLabel.text = model.eduBG;
    _letterLabel.text = model.letter;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[model.members stringByAppendingString:@" 人跟Ta去游学"]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, model.members.length)];
    _membersLabel.attributedText = attributedString;
    _countryLabel.text = model.countrys;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
