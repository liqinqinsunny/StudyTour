//
//  Questions.m
//  StudyTour
//
//  Created by owen on 15/12/10.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "Questions.h"
#import "UserInfo.h"

@implementation Questions


+ (Questions *)infoFromDict:(NSDictionary *)dict
{
    Questions *info = [[Questions alloc] init];
    
    info.title = [dict objectForKey:@"title"];
    info.selectArr = [dict objectForKey:@"selectArr"];
    info.answer = [dict objectForKey:@"answer"];
    info.explain = [dict objectForKey:@"explain"];
    info.ansState = NO;
    return info;
}


+(NSArray *)readQuestionsPlist{

    NSString *configFile = [[NSBundle mainBundle] pathForResource:@"CheckQuestions" ofType:@"plist"];
    NSArray *quetions = [NSArray arrayWithContentsOfFile:configFile];
    NSMutableArray *answers = [[NSMutableArray alloc] init];
    
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:MyCheckData];
//    NSDictionary * answerDic = [FileUtility readFilePathForDictionary:path];
    if (quetions.count <= 0) {
        NSLog(@"没有plist文件");
    }
    for (NSDictionary *dict in quetions) {
        Questions * ques = [Questions infoFromDict:dict];
//        if (answerDic != nil) {
//            NSInteger index = [quetions indexOfObject:dict];
//            NSString * ansStr = [answerDic objectForKey:[NSString stringWithFormat:@"%ld",index]];
//            if (ansStr != nil) {
//                ques.ansState = YES;
//                ques.answered = [ansStr intValue];
//            }
//        }
        NSInteger index = [quetions indexOfObject:dict];
        NSString * anskey = [NSString stringWithFormat:@"%@_check%ld",[UserInfo sharedUserInfo].cardId,index];
        NSString * clickkey = [NSString stringWithFormat:@"%@_click%ld",[UserInfo sharedUserInfo].cardId,index];
        NSString * ansStr = [[NSUserDefaults standardUserDefaults] objectForKey:anskey];
        if (ansStr != nil) {
            ques.ansState = YES;
            ques.answered = [ansStr intValue];
        }
        NSString * clickkeyStr = [[NSUserDefaults standardUserDefaults] objectForKey:clickkey];
        if (clickkeyStr != nil) {
            ques.selectIndex = [clickkeyStr intValue];
        }
        
        [answers addObject : ques];
    }
   
    return answers;
}

@end
