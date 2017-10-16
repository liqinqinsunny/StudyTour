//
//  TeacherInfoModel.h
//  StudyTourLeaderSide
//
//  Created by use on 16/3/16.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherInfoModel : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *eduBG;
@property(nonatomic, copy) NSString *countrys;
@property(nonatomic, copy) NSString *members;
@property(nonatomic, copy) NSString *letter;
@property(nonatomic, copy) NSString *photoUrl;
@property(nonatomic, copy) NSString *teacherLevel;

+ (id)createTeacherInfoModelWithDict:(NSDictionary *)dict;

@end
