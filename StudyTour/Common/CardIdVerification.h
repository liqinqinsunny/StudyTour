//
//  CardIdVerification.h
//  StudyTourLeaderSide
//
//  Created by use on 16/3/9.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardIdVerification : NSObject

+ (BOOL)cardIdVerification:(NSString *)cardId;
+ (BOOL)phoneNumVerification:(NSString *)phoneNum;
+ (BOOL)mailAddVerification:(NSString *)mailAdd;
+ (BOOL)passportVerification:(NSString *)passport;

@end
