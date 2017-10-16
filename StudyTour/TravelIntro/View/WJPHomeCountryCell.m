//
//  WJPHomeCountryCell.m
//  StudyTourLeaderSide
//
//  Created by use on 16/4/22.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "WJPHomeCountryCell.h"
#import "CountryInfoModel.h"
#import "CountryDetailView.h"

@interface WJPHomeCountryCell ()

@property (nonatomic, weak) UIScrollView *myScrollView;

@end

@implementation WJPHomeCountryCell

- (void)awakeFromNib {
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor customBackgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setCountries:(NSArray *)countries
{
    if (![self isEqualToCountries:countries]) {
        _countries = countries;
        [self removeCountryScrollView];
        [self loadCountryScrollView];
    }
    return;
}

- (BOOL)isEqualToCountries:(NSArray *)countries
{
    BOOL bRet = NO;
    do {
        if (countries.count != _countries.count) {
            break;
        }
        for (NSInteger i = 0; i < countries.count; ++i) {
            CountryInfoModel *oldModel = countries[i];
            CountryInfoModel *newModel = _countries[i];
            if (![oldModel.countryName isEqualToString:newModel.countryName] ||
                ![oldModel.countryContent isEqualToString:newModel.countryContent] ||
                ![oldModel.countryPicture isEqualToString:newModel.countryPicture]) {
                break;
            }
        }
        bRet = YES;
    } while (0);
    return bRet;
}

- (void)loadCountryScrollView
{
    UIScrollView *countryView = [[UIScrollView alloc] init];
    countryView.frame = CGRectMake(0, 12, ScreenWidth, (ScreenWidth - 16*2)*153/343);
    CGFloat contentWidth = 32 + (ScreenWidth-32)*_countries.count + 8*(_countries.count-1);
    CGFloat contentHeight = countryView.frame.size.height;
    countryView.contentSize = CGSizeMake(contentWidth, contentHeight);
    [self addSubview:countryView];
    self.myScrollView = countryView;
    countryView.showsHorizontalScrollIndicator = NO;
    
    CGFloat imageViewX = 16;
    CGFloat imageViewTag = CountryPictureClicked;
    for (CountryInfoModel *model in _countries) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(imageViewX, 0, ScreenWidth-16*2, countryView.frame.size.height);
        imageView.tag = imageViewTag++;
        imageViewX += (imageView.frame.size.width + 8);
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.countryPicture]];
        [countryView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(countryPictureClicked:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }
}

- (void)removeCountryScrollView
{
    [_myScrollView removeFromSuperview];
    _myScrollView = nil;
}

- (void)countryPictureClicked:(UITapGestureRecognizer *)tap
{
//    tap.view.tag
//    NSLog(@"%ld\n", tap.view.tag);
    CountryInfoModel *model = self.countries[tap.view.tag-CountryPictureClicked];
    CountryDetailView *countryDetailView = [[CountryDetailView alloc] init];
    [countryDetailView setModel:model];
    __weak typeof(countryDetailView) weak_cdv = countryDetailView;
    [countryDetailView setCloseBlock:^{
        __strong CountryDetailView *strong_cdv = weak_cdv;
        [strong_cdv removeFromSuperview];
        strong_cdv = nil;
    }];
    [_ownVC.navigationController.view addSubview:countryDetailView];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
