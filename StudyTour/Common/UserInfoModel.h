//
//  UserInfoModel.h
//  StudyTour
//
//  Created by lqq on 16/6/2.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

// 身份证
@property(nonatomic,copy) NSString *cardId;
// 行程id
@property(nonatomic,copy) NSString *journeyId;
// 团号
@property(nonatomic,copy) NSString *groupId;

@property(nonatomic,copy) NSString *stuName;
// 是否同意协议
@property(nonatomic,assign) BOOL isAgree;


//单例对象
+ (UserInfoModel *)sharedUserInfo;

// 保存对象
+ (void)saveUserinfo:(NSDictionary *)userinfoData;

// 是否有用户登录
- (BOOL)isUserLogin;

- (BOOL)loginOut;

@end