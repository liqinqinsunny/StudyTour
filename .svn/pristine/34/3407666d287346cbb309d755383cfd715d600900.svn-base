//
//  UserInfo.h
//  StudyTour
//
//  Created by use on 15/12/10.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "JSONModel.h"

@interface UserInfo : JSONModel <NSCopying, NSCoding>

@property (nonatomic, copy) NSString *tokenId;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *group;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSArray *teamleader;
//@property (nonatomic, copy) NSString *sosPhone;
//@property (nonatomic, copy) NSString *teamLeaderId;
//@property (nonatomic, copy) NSString *teamLeaderName;

@property (nonatomic, assign) NSInteger days;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) NSString<Optional> *journeyDesc;
@property (nonatomic, strong) NSString<Optional> *curDay;


//单例对象
+ (UserInfo *)sharedUserInfo;

//存储用户数据
-(void)saveUserDataToDictionary : (NSDictionary *)userdata;

//读取当前已经登 用户数据
-(NSDictionary *)getCurUserDataFromDictionary;


//设置 当前登录用户的cardId
-(void)setCurLoginUserCardId : (NSString *)cardId;

//获取 当前登录用户的cardId
-(NSString *)getCurLoginUserCardId;


//判断是否有已经有用户登录
-(BOOL)isUserLogin;

//获取当前天数 经过计算转换
-(NSInteger)getCurDays;
-(NSString *)getCurDaysString;

//设置当前天数 并且保存
-(void)setCurDays : (NSString *)days;

//设置当天描述 并且保存
-(void)setCurTravelDesc:(NSString *)des;

//获取当前行程描述
-(NSString *)getCurTravelDesc;


- (void)setTeamLeaders:(NSArray *)teamleader;

@end
