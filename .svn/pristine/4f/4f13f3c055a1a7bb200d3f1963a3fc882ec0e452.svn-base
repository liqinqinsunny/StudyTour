//
//  EnrollInfoModel.m
//  StudyTourLeaderSide
//
//  Created by use on 16/3/15.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "EnrollInfoModel.h"
#import "NSObject+Model.h"

static EnrollInfoModel *jp_singletonInstance = nil;

@interface EnrollInfoModel ()

@property (nonatomic, copy) NSDictionary *emptyDict;

@end

@implementation EnrollInfoModel

+ (id)createEnrollInfoModelWithDict:(NSDictionary *)dict needInit:(BOOL)isneed
{
    return [[self alloc] initWithDict:dict needInit:isneed];
}

- (id)initWithDict:(NSDictionary *)dict needInit:(BOOL)isneed
{
    if (self = [self init]) {
        if (isneed) {
            [self setValuesForKeysWithDictionary:self.emptyDict];
        }
        [self setValuesForKeysWithDictionary:dict];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"LoginInfo"];
    jp_singletonInstance = self;
    return self;
}

- (NSDictionary *)emptyDict
{
    _emptyDict = @{@"cardId":@"",
                   @"reviewStatus":@"",
                   @"name":@"",
                   @"phoneNum":@"",
                   @"mailAdd":@"",
                   @"leaderSign":@"",
                   @"directorSign":@"",
                   @"groupId":@""};
    return _emptyDict;
}

+ (void)changeGroupId:(NSString *)groupId
{
    jp_singletonInstance.groupId = groupId;
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginInfo"];
    NSMutableDictionary *tempDict = [userDict mutableCopy];
    [tempDict setValue:groupId forKey:@"groupId"];
    [[NSUserDefaults standardUserDefaults] setObject:[tempDict copy] forKey:@"LoginInfo"];
}

+ (void)changeLeaderName:(NSString *)name
{
    jp_singletonInstance.name = name;
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginInfo"];
    NSMutableDictionary *tempDict = [userDict mutableCopy];
    [tempDict setValue:name forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:[tempDict copy] forKey:@"LoginInfo"];
}

+ (EnrollInfoModel *)sharedEnrollInfoModel {
    if (jp_singletonInstance != nil) {
        return jp_singletonInstance;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginInfo"];
        jp_singletonInstance = [[EnrollInfoModel alloc] initWithDict:dict needInit:YES];
    });
    
    return jp_singletonInstance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (jp_singletonInstance != nil) {
        return jp_singletonInstance;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jp_singletonInstance = [super allocWithZone:zone];
    });
    return jp_singletonInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return jp_singletonInstance;
}

@end
