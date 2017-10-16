//
//  EnrollInfoModel.h
//  StudyTourLeaderSide
//
//  Created by use on 16/3/15.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnrollInfoModel : NSObject

@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *reviewStatus;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *mailAdd;
@property (nonatomic, copy) NSString *leaderSign;
@property (nonatomic, copy) NSString *directorSign;
@property (nonatomic, copy) NSString *groupId;

// 原始数据
//@property (nonatomic, copy) NSDictionary *dataDict;

+ (id)createEnrollInfoModelWithDict:(NSDictionary *)dict needInit:(BOOL)isneed;

+ (EnrollInfoModel *)sharedEnrollInfoModel;

+ (void)changeGroupId:(NSString *)groupId;
+ (void)changeLeaderName:(NSString *)name;

@end
