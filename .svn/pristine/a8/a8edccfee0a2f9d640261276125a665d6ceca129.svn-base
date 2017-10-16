//
//  EnrollCountryCell.m
//  StudyTourLeaderSide
//
//  Created by use on 16/3/3.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "EnrollCountryCell.h"
#import "CountryInfoModel.h"

@interface EnrollCountryCell ()

@property (weak, nonatomic) IBOutlet UIImageView *countryImage;

@end

@implementation EnrollCountryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(CountryInfoModel *)model
{
    [_countryImage sd_setImageWithURL:[NSURL URLWithString:model.countryPicture]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
