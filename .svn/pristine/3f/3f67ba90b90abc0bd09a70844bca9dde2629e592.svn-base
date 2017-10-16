//
//  NSObject+Model.m
//  Esports
//
//  Created by 魏鹏 on 15/10/22.
//  Copyright © 2015年 AerialSeeding. All rights reserved.
//

#import "NSObject+Model.h"

@implementation NSObject (Model)

+ (id)createModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [self init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    NSLog(@"{\nkey:%@\nvalue:%@\n}", key, value);
}

@end
