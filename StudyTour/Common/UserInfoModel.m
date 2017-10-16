//
//  UserInfoModel.m
//  StudyTour
//
//  Created by lqq on 16/6/2.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "UserInfoModel.h"
#import "MJExtension.h"

@implementation UserInfoModel

static UserInfoModel *_instance;

- (instancetype)init
{
    if (_instance != nil) {
        return _instance;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        [_instance readDictdata];
    });
    return _instance;
}

+ (UserInfoModel *)sharedUserInfo
{
    if (_instance == nil) {
        _instance = [[self alloc]init];
        [_instance readDictdata];
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_instance != nil) {
        return _instance;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        [_instance readDictdata];
    });
    return _instance;
}

- (instancetype)readDictdata
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    if (dict != nil) {
        _instance = [UserInfoModel mj_objectWithKeyValues:dict];
        [self getStuName];
        [self getCurrentCarId];
        [self getAgreement];
    }
    return _instance;
}

+ (void)saveUserinfo:(NSDictionary *)userinfoData
{
    [[NSUserDefaults standardUserDefaults] setObject:userinfoData forKey:@"userinfo"];
    [[NSUserDefaults standardUserDefaults] setObject:userinfoData[@"cardId"] forKey:CurLogigKey];
    [NSUserDefaults resetStandardUserDefaults];
}
// 是否有用户登录
- (BOOL)isUserLogin
{
    BOOL islogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN"] boolValue];
    if (islogin) {
        if ([self getCurrentCarId]) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

- (BOOL)loginOut
{
    if (![self isUserLogin]) {
        return NO;
    }
    @synchronized (self) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LOGIN"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CurLogigKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:AgreementKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:StuNameKey];
        return YES;
    }
}

// 当前登录的用户ID
- (NSString *)getCurrentCarId
{
    NSString *carid = [[NSUserDefaults standardUserDefaults] objectForKey:CurLogigKey];
    if (carid == nil) {
        return nil;
    }
    return carid;
}
// 当前是否同意协议
- (void)getAgreement
{
    id agree = [[NSUserDefaults standardUserDefaults] objectForKey:AgreementKey];
    if ([agree integerValue] == 1) {
        self.isAgree = YES;
    } else {
        self.isAgree = NO;
    }
}

- (NSString *)getStuName
{
    id name = [[NSUserDefaults standardUserDefaults] objectForKey:StuNameKey];
    if (name == nil) {
        return nil;
    } else {
        _stuName = name;
    }
    return _stuName;
}
@end
