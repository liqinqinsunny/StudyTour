//
//  WJPTaskModel.m
//  StudyTourLeaderSide
//
//  Created by use on 16/4/26.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "WJPTaskModel.h"
#import "NSObject+Model.h"

@implementation WJPTaskModel

+ (id)createWJPTaskModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (id)createEmptyWJPTaskModel
{
    NSDictionary *dict = @{@"taskId":@"Empty",
                           @"title":@"Empty",
                           @"type":@"100"};
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"accessoryUrl"]) {
        _accessory = value;
    } else if ([key isEqualToString:@"externalChain"]) {
        _link = value;
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_taskId forKey:@"taskId"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_state forKey:@"state"];
    [aCoder encodeObject:_hide forKey:@"hide"];
    [aCoder encodeObject:_downloadCount forKey:@"downloadCount"];
    [aCoder encodeObject:_type forKey:@"type"];
    [aCoder encodeObject:_accessory forKey:@"accessory"];
    [aCoder encodeObject:_taskCount forKey:@"taskCount"];
    [aCoder encodeObject:_link forKey:@"link"];
    [aCoder encodeBool:_noCustomBackgroundColor forKey:@"noCustomBackgroundColor"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _taskId = [aDecoder decodeObjectForKey:@"taskId"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _state = [aDecoder decodeObjectForKey:@"state"];
        _hide = [aDecoder decodeObjectForKey:@"hide"];
        _downloadCount = [aDecoder decodeObjectForKey:@"downloadCount"];
        _type = [aDecoder decodeObjectForKey:@"type"];
        _accessory = [aDecoder decodeObjectForKey:@"accessory"];
        _taskCount = [aDecoder decodeObjectForKey:@"taskCount"];
        _link = [aDecoder decodeObjectForKey:@"link"];
        _noCustomBackgroundColor = [aDecoder decodeBoolForKey:@"noCustomBackgroundColor"];
    }
    return self;
}

@end
