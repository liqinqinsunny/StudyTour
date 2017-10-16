//
//  TravelNoteUnitModel.m
//  StudyTour
//
//  Created by use on 16/6/1.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "TravelNoteUnitModel.h"
#import "NSObject+Model.h"

@implementation TravelNoteUnitModel


+ (id)createTravelNoteUnitModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
