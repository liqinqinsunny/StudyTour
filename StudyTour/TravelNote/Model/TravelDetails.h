//
//  TravelDetails.h
//  StudyTourLeaderSide
//
//  Created by Apple on 16/5/13.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelDetails : NSObject
// 标签
@property(nonatomic,copy) NSString *tagName;
// 标题
@property(nonatomic,copy) NSString *title;
// 查看数
@property(nonatomic,copy) NSString *view;
// 喜欢数
@property(nonatomic,copy) NSString *like;
// 游记概括Id
@property(nonatomic,copy) NSString *generalizeId;
// 游记详情数组
@property(nonatomic,copy) NSArray *particularseArray;

// 封面URL
@property(nonatomic,copy) NSString *coverUrl;
// 分享URL
@property(nonatomic,copy) NSString *shareUrl;
// DAY1
@property(nonatomic,copy) NSString *incidentName;

+ (instancetype)createTravelDetailsModelWithDict:(NSDictionary *)dict;

@end