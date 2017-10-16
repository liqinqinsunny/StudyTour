//
//  TravelNotePerDayModel.m
//  StudyTour
//
//  Created by use on 16/6/3.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "TravelNotePerDayModel.h"
#import "NSObject+Model.h"

#import "TravelNoteCoverModel.h"

@implementation TravelNotePerDayModel

+ (id)createTravelNotePerDayModelWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    if ([@"template" isEqualToString:key]) {
        NSMutableArray *tempArray = [NSMutableArray new];
        for (NSDictionary *dict in value) {
            TravelNoteCoverModel *model = [TravelNoteCoverModel createTravelNoteCoverModelWithDict:dict];
            [tempArray addObject:model];
        }
        _travelArray = [tempArray copy];
    }
}

@end