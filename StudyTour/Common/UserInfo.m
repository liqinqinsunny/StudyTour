//
//  UserInfo.m
//  StudyTour
//
//  Created by use on 15/12/10.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *_userInfo;

@implementation UserInfo

+ (UserInfo *)sharedUserInfo
{
    if (_userInfo != nil) {
        return _userInfo;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [[UserInfo alloc] init];
    });
    return _userInfo;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_userInfo != nil) {
        return _userInfo;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [super allocWithZone:zone];
    });
    return _userInfo;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _userInfo;
}

-(void)initAttribute : (NSString *)userinfoKey
{
    self.curDay = @"";
    self.journeyDesc = @"";
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:userinfoKey];
    if(dic == nil)
    {
        return;
    }
    NSString * day = dic[@"curDay"];
    if (day != nil) {
        self.curDay = day;
    }
    NSString * desc = dic[@"journeyDesc"];
    if (desc != nil) {
        self.journeyDesc = desc;
    }
}


-(void)saveUserDataToDictionary : (NSDictionary *)userdata
{
    NSString *userInfoKey = userdata[@"cardId"];
    [self initAttribute : userInfoKey];
    NSMutableDictionary * dicdata = [[NSMutableDictionary alloc]initWithDictionary:userdata];
    [dicdata setObject:self.curDay forKey:@"curDay"];
    [dicdata setObject:self.journeyDesc forKey:@"journeyDesc"];
    //保存当前用户信息
    
    [[NSUserDefaults standardUserDefaults] setObject:dicdata forKey:userInfoKey];
    [NSUserDefaults resetStandardUserDefaults];
    //保存当前登录的用户cardID
    [self setCurLoginUserCardId:userInfoKey];
}

-(NSDictionary *)getCurUserDataFromDictionary
{
    NSString * carId = [self getCurLoginUserCardId];
    if (carId == nil) {
        return nil;
    }
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] valueForKey:carId];
    return userDic;
}


-(void)setCurLoginUserCardId : (NSString *)cardId
{
    [[NSUserDefaults standardUserDefaults] setObject:cardId forKey:CurLogigKey];
    [NSUserDefaults resetStandardUserDefaults];
}


-(NSString *)getCurLoginUserCardId
{
    NSString * cardId = [[NSUserDefaults standardUserDefaults] valueForKey :CurLogigKey];
    if (cardId == nil || [cardId isEqualToString:@""]) {
        return nil;
    }
    return cardId;
}

//|| [self.curDay isEqualToString:@""]
-(NSInteger)getCurDays 
{
    if (self.curDay == nil ) {
        return 1;
    }
    
    NSInteger day = [self.curDay intValue];
    //1、超出行程已经完成 2、没有开始行程 0
    if (day > self.days || day == 0) {
        return 1;
    }
    
    return day;
}

-(NSString *)getCurDaysString
{
    if (self.curDay != nil) {
        return self.curDay;
    }
    return @"";
}

-(BOOL)isUserLogin
{
    NSDictionary * curUserDic = [self getCurUserDataFromDictionary];
    if (curUserDic == nil) {
        return NO;
    }
    
    return YES;
}

-(void)setCurDays:(NSString*)days
{
    if (days == nil) {
        self.curDay = @"";
    }
    else{
        self.curDay = days;
    }
    NSDictionary * userDic = [self toDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:self.cardId];
    [NSUserDefaults resetStandardUserDefaults];
}

-(void)setCurTravelDesc:(NSString*)des
{
    if (des == nil) {
        self.journeyDesc = @"";
    }
    else{
        self.journeyDesc = des;
    }
    NSDictionary * userDic = [self toDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:self.cardId];
    [NSUserDefaults resetStandardUserDefaults];
}

- (void)setTeamLeaders:(NSArray *)teamleader
{
    self.teamleader = teamleader;
    NSDictionary * userDic = [self toDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:self.cardId];
    [NSUserDefaults resetStandardUserDefaults];
}


-(NSString *)getCurTravelDesc
{
    if (self.journeyDesc == nil) {
        return @"";
    }
    return self.journeyDesc;
}


@end
