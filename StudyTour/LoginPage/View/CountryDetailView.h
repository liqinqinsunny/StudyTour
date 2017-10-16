//
//  CountryDetailView.h
//  StudyTourLeaderSide
//
//  Created by use on 16/3/15.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CountryInfoModel;

@interface CountryDetailView : UIView

@property (nonatomic, strong) CountryInfoModel *model;

@property (nonatomic, copy) void(^closeBlock)();

- (void)setCloseBlock:(void (^)())closeBlock;

@end
