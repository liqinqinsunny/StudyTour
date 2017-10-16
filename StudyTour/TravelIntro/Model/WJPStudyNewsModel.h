//
//  WJPStudyNewsModel.h
//  StudyTourLeaderSide
//
//  Created by use on 16/4/20.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJPStudyNewsModel : NSObject

@property (nonatomic, copy) NSString *stadyTourTitleUrl;
@property (nonatomic, copy) NSString *stadyTourTitle;

+ (id)createWJPStudyNewsModelWithDict:(NSDictionary *)dict;

@end
