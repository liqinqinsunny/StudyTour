//
//  TravelDetails.m
//  StudyTourLeaderSide
//
//  Created by Apple on 16/5/13.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "TravelDetails.h"
#import "Particularses.h"

#import "NSObject+Model.h"

@implementation TravelDetails

+ (instancetype)createTravelDetailsModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    if ([@"particularses" isEqualToString:key]) {
        NSMutableArray *tempArray = [NSMutableArray new];
        for (NSDictionary *dict in value) {
            Particularses *p_model = [Particularses createPartiModelWithDict:dict];
            [tempArray addObject:p_model];
        }
        _particularseArray = [tempArray copy];
    }
}

@end
