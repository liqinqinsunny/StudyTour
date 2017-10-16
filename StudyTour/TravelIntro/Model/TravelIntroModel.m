//
//  TravelIntroModel.m
//  StudyTour
//
//  Created by lqq on 16/6/7.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "TravelIntroModel.h"
#import "MJExtension.h"

@implementation TravelIntroModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"countrieses" : @"CountryInfoModel",
              @"list" : @"TravelListType" };
}

@end
