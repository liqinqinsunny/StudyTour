//
//  SurveyViewController.m
//  StudyTour
//
//  Created by owen on 16/1/16.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "SurveyViewController.h"
#import "surveyModel.h"
#import "MultiSelectView.h"
#import "SingleSelectView.h"
#import "Downloader.h"
#import "UserInfo.h"

@implementation SurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新东方国际游学调查问卷";
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString * categoryID = [[NSUserDefaults standardUserDefaults] objectForKey :@"routeCategoryID"];
    NSString * categoryName = [[NSUserDefaults standardUserDefaults] objectForKey :@"routeCategoryName"];
    self.routeCategoryName = categoryName;
    self.routeCategoryID = categoryID;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showHud];
    //调查问卷
    [MobClick event:Click_Task_Survey_Url_Count];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //子线程初始化数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.routeCategoryName != nil) {
            self.dataArray = [surveyModel readPlistData : self.routeCategoryName];
        }

        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initAnwserArr];
            [self initScrollData];
        });

    });
}

- (void)initAnwserArr
{
    _anwserArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dataArray.count; ++i) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [_anwserArr addObject:dict];
    }
}

//初始化scroll数据
-(void)initScrollData
{
    [self hideHud];
    CGFloat cur_y = 0;
    for (NSInteger i = 0; i < _dataArray.count; ++i) {
        NSMutableDictionary *dict = _anwserArr[i];
        surveyModel * dataModel = [_dataArray objectAtIndex:i];
        NSString * titleStr = [NSString stringWithFormat:@"%ld.%@",(long)(i+1),dataModel.titleName];
        if ([dataModel.selectType isEqualToString:@"多选"]) {
            MultiSelectView * msv = [[MultiSelectView alloc] init];
            msv.selelctType = !dataModel.isSelect;
            msv.theTitle = titleStr;
            msv.dataArr = [dataModel.selects mutableCopy];
            [dict setValue:@(dataModel.isSelect) forKey:@"selectType"];
            msv.anwserDict = dict;
            [_scrollview addSubview:msv];
            msv.frame = CGRectMake(0, cur_y, msv.frame.size.width, msv.frame.size.height);
            cur_y += msv.frame.size.height;
        }
        else if([dataModel.selectType isEqualToString:@"单选"]){
            SingleSelectView *ssv = [[SingleSelectView alloc] init];
            ssv.selectArr = [dataModel.selects mutableCopy];
            ssv.type = !dataModel.isSelect;
            ssv.theTitle = titleStr;
            [dict setValue:@(dataModel.isSelect) forKey:@"selectType"];
            ssv.anwserDict = dict;
            [_scrollview addSubview:ssv];
            ssv.frame = CGRectMake(0, cur_y, ssv.frame.size.width, ssv.frame.size.height);
            cur_y += ssv.frame.size.height;
        }
    }
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(0, 0, ScreenWidth*0.5, ScreenWidth*0.15);
    submit.center = CGPointMake(ScreenWidth*0.5, cur_y+80);
    [submit setTitle:@"提 交" forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor themeColor];
    submit.layer.cornerRadius = 4;
    submit.clipsToBounds = YES;
    [submit addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollview addSubview:submit];
    
    _scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, cur_y+300);
}

- (void)submitClicked:(UIButton *)sender
{
    if ([self checkOut] == NO) {
        if ([UIDevice currentDevice].systemVersion.floatValue < 8) {
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请确认是否填写完毕" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertV show];
        } else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提醒" message:@"请确认是否填写完毕" preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }
        return;
    }
    [self showHud];
    //提交调查问卷
    [MobClick event:Click_Task_Submit_Survey_Count];
    
    Downloader *scDownloader = [[Downloader alloc] init];
    
    [scDownloader POST:SurveySubmitURL param:self.submitDictionary wating:^{
        
    } fail:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            [self showTips:SubmitDataFailTips];
        });
        
    } success:^(NSDictionary *originData) {
        
        if ([originData[@"cardId"] isEqualToString:@"0"] || originData[@"error"] != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                [self showTips:SubmitDataFailTips];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                [self showTips:SubmitDataSuceesTips];
                [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:[NSString stringWithFormat:@"Survey%@%@", self.submitDictionary[@"groupId"], self.submitDictionary[@"cardId"]]];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } refresh:YES];
}

- (BOOL)checkOut
{
    for (int i = 0; i < _dataArray.count; ++i) {
        NSMutableDictionary *dict = _anwserArr[i];
//                NSArray * dicArr = [dict allKeys];
        NSInteger selectType = [[dict valueForKey:@"selectType"] integerValue];
        if (selectType && ![self validKey:dict]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validKey:(NSMutableDictionary *)dict
{
    if ([dict valueForKey:@"Other"] != nil && ![[dict valueForKey:@"Other"] isEqualToString:@"无"]) {
        return YES;
    }
    for (NSInteger j = 1; j < 15; ++j) {
        NSString *resultStr = dict[[NSString stringWithFormat:@"%ld", (long)j]];
        if (resultStr != nil && ![resultStr isEqualToString:@""] && ![@"0" isEqualToString:resultStr]) {
            return YES;
        }
    }
    
    return NO;
}

-(NSMutableDictionary *)submitDictionary
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    [tempDict setValue:userInfo.userId forKey:@"userId"];
    [tempDict setValue:userInfo.cardId forKey:@"cardId"];
    [tempDict setValue:userInfo.group forKey:@"groupId"];
    [tempDict setValue:self.routeCategoryID forKey:@"routeCategoryID"];
    [tempDict setValue:self.routeCategoryName forKey:@"routeCategoryName"];
    
    for (NSInteger i = 1; i <= _anwserArr.count; ++i) {
        NSDictionary *dict = _anwserArr[i-1];
        NSString *str = @"";
        for (NSInteger j = 1; j < 15; ++j) {
            NSString *resultStr = dict[[NSString stringWithFormat:@"%ld", (long)j]];
            if (resultStr != nil && ![resultStr isEqualToString:@""] && ![@"0" isEqualToString:resultStr]) {
                str = [str stringByAppendingString:resultStr];
                str = [str stringByAppendingString:@"--"];
                continue;
            }
        }
        [tempDict setValue:str forKey:[NSString stringWithFormat:@"wenti%ld", (long)i]];
        NSString *otherStr = dict[@"Other"];
        [tempDict setValue:otherStr forKey:[NSString stringWithFormat:@"wenti%ldb", (long)i]];
    }
    
    return tempDict;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
