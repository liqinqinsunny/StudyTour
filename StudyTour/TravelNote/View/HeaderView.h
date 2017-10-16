//
//  HeaderView.h
//  StudyTourLeaderSide
//
//  Created by Apple on 16/5/16.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TravelDetails;

@interface HeaderView : UIView
@property(nonatomic,strong) TravelDetails *travelDetailsModel;

@property (nonatomic, assign) NSInteger likeCount;

- (void)likeCountAddOne;

@end
