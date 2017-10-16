//
//  HeaderView.m
//  StudyTourLeaderSide
//
//  Created by Apple on 16/5/16.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "HeaderView.h"
#import "TravelDetails.h"
#import "NSString+Frame.h"
#import "UIView+Extension.h"
#import "TitleButton.h"
#define tagFont [UIFont systemFontOfSize:10]
#define titleFont [UIFont systemFontOfSize:16]
#define viewFont [UIFont systemFontOfSize:14]

@interface HeaderView()

@property(nonatomic,strong) UIButton *tagbtn;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) TitleButton *zanButton;
@property(nonatomic,strong) TitleButton *viewButton;
@end

@implementation HeaderView

- (instancetype)init
{
    if (self = [super init]) {

        // 标签
        UIButton *tagbtn = [[UIButton alloc]init];
        [tagbtn setBackgroundImage:[UIImage imageNamed:@"bg_traveldetails_tagbg"]  forState:UIControlStateNormal];
        tagbtn.titleLabel.font = tagFont;

        [tagbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:tagbtn];
        self.tagbtn = tagbtn;
        // 标题
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor colorWithHex:0x383838];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font =  titleFont;
        
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        // 点赞数
        TitleButton *zanButton = [[TitleButton alloc]init];
        [zanButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        [zanButton setImage:[UIImage imageNamed:@"ic_travelNoteDetail_zan"] forState:UIControlStateNormal];
        zanButton.imageContentMargin = 4;
        
        [self addSubview:zanButton];
        self.zanButton = zanButton;
        // 查看数
        TitleButton *viewButton = [[TitleButton alloc]init];
        [viewButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        [viewButton setImage:[UIImage imageNamed:@"ic_travelNoteDetail_see"] forState:UIControlStateNormal];
        viewButton.imageContentMargin = 4;
        [self addSubview:viewButton];
        self.viewButton = viewButton;
        
        
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, 55, ScreenWidth, 1);
        [line setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]];
        [self addSubview:line];
    }
    return self;
}

- (void)setTravelDetailsModel:(TravelDetails *)travelDetailsModel
{
    _travelDetailsModel = travelDetailsModel;
    [self.tagbtn setTitle:travelDetailsModel.tagName forState:UIControlStateNormal];

    self.titleLabel.text = travelDetailsModel.title;
    if (travelDetailsModel.view == nil) {
        travelDetailsModel.view = @"0";
    }
    [self.viewButton setTitle:travelDetailsModel.view forState:UIControlStateNormal];
    if (travelDetailsModel.like == nil) {
        travelDetailsModel.like = @"0";
    }
    [self.zanButton setTitle:travelDetailsModel.like forState:UIControlStateNormal];
    
    _likeCount = [travelDetailsModel.like integerValue];
    
    // 标签
    CGFloat tagW = [self.travelDetailsModel.tagName widthWithFont:tagFont];
    self.tagbtn.frame = CGRectMake(16, 0, tagW * 1.5, 20);
    self.tagbtn.centerY = self.centerY;
   
    // view
    CGFloat viewFontW = [self.travelDetailsModel.view widthWithFont:viewFont];
    CGFloat viewW = viewFontW + 4 + 16;
    CGFloat viewX = ScreenWidth - 20 - viewW;
    CGFloat viewY = 0;
    CGFloat viewH = 40;
    self.viewButton.frame = CGRectMake(viewX, viewY, viewW, viewH);
    self.viewButton.centerY = self.centerY;
    // zan
    CGFloat zanFontW = [self.travelDetailsModel.like widthWithFont:viewFont];
    CGFloat zanW = zanFontW + 4 + 16;
    CGFloat zanX = self.viewButton.x - 12 - zanW;
    CGFloat zanY = 0;
    CGFloat zanH = 40;
    self.zanButton.frame = CGRectMake(zanX, zanY, zanW, zanH);
    self.zanButton.centerY = self.centerY;
    
    // 标题
    CGFloat titleX = CGRectGetMaxX(self.tagbtn.frame) + 8;
    CGFloat titleY = 0;
    CGFloat titleW = zanX - titleX; //[self.travelDetailsModel.title widthWithFont:titleFont];
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, 40);
    self.titleLabel.centerY = self.centerY;
}

- (void)setLikeCount:(NSInteger)likeCount
{
    _likeCount = likeCount;
    [self.zanButton setTitle:[NSString stringWithFormat:@"%ld", (long)_likeCount] forState:UIControlStateNormal];
    
    CGFloat zanFontW = [self.travelDetailsModel.like widthWithFont:viewFont];
    CGFloat zanW = zanFontW + 4 + 16;
    CGFloat zanX = self.viewButton.x - 12 - zanW;
    CGFloat zanY = 0;
    CGFloat zanH = 40;
    self.zanButton.frame = CGRectMake(zanX, zanY, zanW, zanH);
    self.zanButton.centerY = self.centerY;
}

- (void)likeCountAddOne
{
    [self setLikeCount:_likeCount+1];
}

@end
