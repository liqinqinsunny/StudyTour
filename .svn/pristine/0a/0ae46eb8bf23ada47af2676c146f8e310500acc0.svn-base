//
//  QuestionView.m
//  StudyTour
//
//  Created by owen on 15/12/10.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "QuestionView.h"
#import "CheckQuestionController.h"
#import "UserInfo.h"


@implementation QuestionView

-(id)initWithFrame:(CGRect)frame Obbject:(id)obj {
 
    self = [super initWithFrame:frame];
    if (self) {
        //加载xib
        self = [[[NSBundle mainBundle] loadNibNamed:@"QuestionView" owner:obj options:nil] objectAtIndex:0];

        [self setFrame:frame];

    }
    return self;
}


-(void)loadData : (Questions *)quesTions atIndex:(NSInteger)index Count:(NSInteger)count
{
    if(quesTions == nil){
        return;
    }
    
    NSString * indexStr = [NSString stringWithFormat:@"第%ld题",index+1];
    self.titleIndex.text = indexStr;
    
    NSString * numStr = [NSString stringWithFormat:@"(%ld/%ld)",index+1,count];
    self.titleNum.text = numStr;
    
    NSString * titlecon = quesTions.title;
    self.titleCon.text = titlecon;
    
    NSString * exlainStr = quesTions.explain;
    self.explainCon.text = exlainStr;
    
    self.rightIndex = [quesTions.answer intValue];
    self.curIndex = index;
    
    if (quesTions.ansState) {
        [self setSelectBtnState:NO];
        [self setExplainState:YES isRight: quesTions.answered];
        [self setSelectImg:quesTions.selectIndex];
    }
    else{
        [self setExplainState:NO isRight: quesTions.answered];
    }
    
}


- (IBAction)rightBtn:(id)sender
{
    //默认正确键 的索引为1
    NSInteger ansNum = 0;
    if (self.rightIndex == 1) {
        [self setExplainState:YES isRight:YES];
        ansNum = 1;
    }
    else{
        [self setExplainState:YES isRight:NO];
        ansNum = 0;
    }
    [self statisticsTitle];
    [self setSelectImg:1];
    [self setSelectBtnState:NO];
    //数据
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",ansNum] forKey:[NSString stringWithFormat:@"%@_check%ld",[UserInfo sharedUserInfo].cardId,(long)self.curIndex]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",1] forKey:[NSString stringWithFormat:@"%@_click%ld",[UserInfo sharedUserInfo].cardId,(long)self.curIndex]];
    [self saveQuestionState:self.curIndex];
}

- (void)saveQuestionState:(NSInteger)qIndex
{
    
    NSString * const QuestionStateArrKey = [NSString stringWithFormat:@"QuestionStateArrKey%@", [UserInfo sharedUserInfo].userId];
    NSMutableArray *tempArr = [[[NSUserDefaults standardUserDefaults] objectForKey:QuestionStateArrKey] mutableCopy];
    tempArr[qIndex] = @"1";
    [[NSUserDefaults standardUserDefaults] setObject:tempArr forKey:QuestionStateArrKey];
}

- (IBAction)errorBtn:(id)sender
{
    //默认错误键 的索引为2
    NSInteger ansNum = 0;
    if (self.rightIndex == 2) {
        [self setExplainState:YES isRight:YES];
        ansNum = 1;
    }
    else{
        [self setExplainState:YES isRight:NO];
        ansNum = 0;
    }
    [self statisticsTitle];
    [self setSelectImg:2];
    [self setSelectBtnState:NO];
    
    //记录数据
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",ansNum] forKey:[NSString stringWithFormat:@"%@_check%ld",[UserInfo sharedUserInfo].cardId,(long)self.curIndex]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",2] forKey:[NSString stringWithFormat:@"%@_click%ld",[UserInfo sharedUserInfo].cardId,(long)self.curIndex]];
//    NSMutableDictionary * dicData = [[NSMutableDictionary alloc]init];
//    [dicData setObject:[NSString stringWithFormat:@"%ld",ansNum] forKey:[NSString stringWithFormat:@"%ld",(long)self.curIndex]];
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:MyCheckData];
//    [FileUtility writeFileDictionary:dicData filePath:path];
    [self saveQuestionState:self.curIndex];
}


-(void)setExplainState : (BOOL)isShow isRight:(BOOL)isRight
{
    if(isShow){
        self.explainView.hidden = NO;
        if (isRight) {
            self.explainCon.text = [NSString stringWithFormat:@"恭喜你答对了,%@",self.explainCon.text];
        }
        else{
            self.explainCon.text = [NSString stringWithFormat:@"很遗憾答错了,%@",self.explainCon.text];
        }
    }
    else{
        self.explainView.hidden = YES;
    }
}


-(void)setSelectBtnState:(BOOL)isEnabel
{
    self.rightBtn.enabled = isEnabel;
    self.errorBtn.enabled = isEnabel;
}

-(void)setSelectImg : (NSInteger)select
{
    if (select == 1) {
        [self.rightBtn setImage:[UIImage imageNamed:@"right-green.png"] forState:UIControlStateDisabled];
        [self.errorBtn setImage:[UIImage imageNamed:@"wrong-white.png"] forState:UIControlStateDisabled];
    }
    else if(select == 2)
    {
        [self.errorBtn setImage:[UIImage imageNamed:@"wrong-green.png"] forState:UIControlStateDisabled];
        [self.rightBtn setImage:[UIImage imageNamed:@"right-white.png"] forState:UIControlStateDisabled];
    }
}

-(void)statisticsTitle
{
    NSString * testKey = [NSString stringWithFormat:@"%@_check%@",[UserInfo sharedUserInfo].cardId,TestTitleKey];
    NSString * total = [[NSUserDefaults standardUserDefaults] valueForKey :testKey];
    if (total == nil) {
        total = @"1";
        [[NSUserDefaults standardUserDefaults] setValue:total forKey : testKey];
        [NSUserDefaults resetStandardUserDefaults];
    }
    else
    {
        NSInteger totalnum = [total integerValue];
        if (totalnum >= 10) {
            return;
        }
        totalnum = totalnum + 1;
        if (totalnum <= 10) {
            total = [NSString stringWithFormat:@"%ld",totalnum];
            [[NSUserDefaults standardUserDefaults] setValue:total forKey : testKey];
            [NSUserDefaults resetStandardUserDefaults];
            //统计答完
            if (totalnum == 10) {
                
                UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已经做完当前所有试题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //统计测试题
    [MobClick endEvent:Click_Notice_TestSuccess_Count];
}

@end
