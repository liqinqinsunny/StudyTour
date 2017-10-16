
//
//  TravelNotePerDayModel.h
//  StudyTour
//
//  Created by use on 16/6/3.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelNotePerDayModel : NSObject

@property (nonatomic, copy) NSString *dayName;
@property (nonatomic, copy) NSString *dayId;
@property (nonatomic, copy) NSArray *travelArray;
/**
 *  0:不满意
 *  1:满意
 *  2:非常满意
 *  9:未选择选项
 */
@property (nonatomic, copy) NSString* feedback;
/**
 *  0:该事件不需反馈
 *  1:该事件需反馈
 */
@property (nonatomic, copy) NSString* type;

+ (id)createTravelNotePerDayModelWithDict:(NSDictionary *)dict;

@end
