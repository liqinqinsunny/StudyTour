//
//  QuestionModel.m
//  StudyTour
//
//  Created by lqq on 16/6/21.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "QuestionModel.h"
#import "MJExtension.h"
#import "QustionSection.h"
@implementation QuestionModel

- (void)setOptionList:(NSDictionary *)OptionList
{
    _OptionList = OptionList;
    
    NSArray *sortedkeys = self.OptionList.allKeys;
    NSArray *sortedArray = [sortedkeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *aryM = [NSMutableArray array];
    [sortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QustionSection *section = [[QustionSection alloc]init];
        section.section = obj;
        section.title = OptionList[obj];
        [aryM addObject:section];
    }];
    _OptionsAry = [aryM copy];
}



@end
