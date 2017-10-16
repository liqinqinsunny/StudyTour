//
//  CountryDetailView.m
//  StudyTourLeaderSide
//
//  Created by use on 16/3/15.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "CountryDetailView.h"
#import "CountryInfoModel.h"

@interface CountryDetailView ()

@property (weak, nonatomic) IBOutlet UIImageView *countryImage;
@property (weak, nonatomic) IBOutlet UILabel *countryContent;

@end

@implementation CountryDetailView

- (instancetype)init
{
    if (self = [super init]) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"CountryDetailView" owner:nil options:nil];
        self = [nibContents lastObject];
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self removeFromSuperview];
//    if (self.closeBlock) {
//        self.closeBlock();
//    }
}

- (void)setModel:(CountryInfoModel *)model
{
    [_countryImage sd_setImageWithURL:[NSURL URLWithString:model.countryPicture]];
    _countryContent.text = model.countryContent;
    
}

@end
