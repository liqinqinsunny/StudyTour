//
//  MyTravel.h
//  StudyTour
//
//  Created by owen on 15/12/16.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    PLANE = 1,
    BUS,
    TRAIN,
    SHIP
} travelTool;

@interface MyTravel : JSONModel

@property(nonatomic,strong)NSString * curDays;

@property(nonatomic,strong)NSString * startravel;

@property(nonatomic,strong)NSArray * travel;

@property(nonatomic,strong)NSString * tripDes;

@property(nonatomic,strong)NSString * tripDesImg;

@property(nonatomic,strong)NSString * liveHotel;




//给属性赋值
+(MyTravel *)infoFromDict:(NSDictionary *)dict;

+(NSArray *)readMyTravelData : (NSDictionary *)dict;

@end
