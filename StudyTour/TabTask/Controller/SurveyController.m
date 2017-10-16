//
//  SurveyController.m
//  StudyTour
//
//  Created by use on 15/12/16.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "SurveyController.h"
#import "MultiSelectView.h"
#import "SingleSelectView.h"
#import "Downloader.h"

#import "UserInfo.h"

@interface SurveyController ()<UIAlertViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollV;
@property (nonatomic, copy) NSMutableArray *dataArr;
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, copy) NSArray *typeArr;

@property (nonatomic, copy) NSMutableArray *anwserArr;

@property (nonatomic, copy) NSMutableDictionary *submitDictionary;
@end

@implementation SurveyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"新东方国际游学调查问卷";
    
    _typeArr = @[@(10), @(10), @(10), @(0), @(1),
                 @(1), @(1), @(1), @(0), @(0),
                 @(0), @(10), @(2), @(0)];
    [self initAnwserArr];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    [self.view addSubview:scrollView];
    self.scrollV = scrollView;
    
    [self setUpUI];
}

- (void)initAnwserArr
{
    _anwserArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < _typeArr.count; ++i) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [_anwserArr addObject:dict];
    }
//    NSLog(@"_anwserArr.count-%ld", _anwserArr.count);
}

- (BOOL)checkOut
{
    for (int i = 0; i < _typeArr.count; ++i) {
        NSMutableDictionary *dict = _anwserArr[i];
        if ([dict allKeys].count == 0 && (i <= 3 || (i >= 8 && i != 12))) {
            return NO;
        }
    }
    return YES;
}

- (void)setUpUI
{
    CGFloat cur_y = 0;
    for (NSInteger i = 0; i < _typeArr.count; ++i) {
        NSMutableDictionary *dict = _anwserArr[i];
        if ([_typeArr[i] integerValue] == 10) {
            MultiSelectView * msv = [[MultiSelectView alloc] init];
            msv.theTitle = self.titleArr[i];
            msv.dataArr = self.dataArr[i];
            msv.anwserDict = dict;
            [_scrollV addSubview:msv];
            msv.frame = CGRectMake(0, cur_y, msv.frame.size.width, msv.frame.size.height);
            cur_y += msv.frame.size.height;
        } else {
            SingleSelectView *ssv = [[SingleSelectView alloc] init];
            ssv.type = [_typeArr[i] integerValue];
            ssv.theTitle = self.titleArr[i];
            ssv.anwserDict = dict;
            [_scrollV addSubview:ssv];
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
    [_scrollV addSubview:submit];
    
    _scrollV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, cur_y+300);
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
    //提交调查问卷
    [MobClick event:Click_Task_Submit_Survey_Count];
    
    Downloader *scDownloader = [[Downloader alloc] init];

    [scDownloader POST:SurveySubmitURL param:self.submitDictionary wating:^{
        
    } fail:^{


        [self showTips:SubmitDataFailTips];
    } success:^(NSDictionary *originData) {

        if ([originData[@"cardId"] isEqualToString:@"0"] || originData[@"error"] != nil) {
            [self showTips:SubmitDataFailTips];
        } else {
            [self showTips:SubmitDataSuceesTips];

            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:[NSString stringWithFormat:@"Survey%@%@", self.submitDictionary[@"groupId"], self.submitDictionary[@"cardId"]]];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } refresh:YES];
}

-(NSMutableDictionary *)submitDictionary
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    [tempDict setValue:userInfo.userId forKey:@"userId"];
    [tempDict setValue:userInfo.cardId forKey:@"cardId"];
    [tempDict setValue:userInfo.group forKey:@"groupId"];
    
//    NSArray *anwserNumArray = @[@(9), @(5), @(11), @(3), @(3),
//                                @(3), @(3), @(3), @(3), @(3),
//                                @(3), @(9), @(3), @(3)];
//    NSLog(@"ARR-%@", _anwserArr);
    for (NSInteger i = 1; i <= _anwserArr.count; ++i) {
        NSDictionary *dict = _anwserArr[i-1];
        NSString *str = @"";
        for (NSInteger j = 1; j < 11; ++j) {
            NSString *resultStr = dict[[NSString stringWithFormat:@"%ld", j]];
            if ([@"1" isEqualToString:resultStr]) {
                NSString *tempStr = [NSString stringWithFormat:@"%ld,", j];
                str = [str stringByAppendingString:tempStr];
                continue;
            }
        }
        [tempDict setValue:str forKey:[NSString stringWithFormat:@"wenti%ld", i]];
        NSString *otherStr = dict[@"Other"];
        [tempDict setValue:otherStr forKey:[NSString stringWithFormat:@"wenti%ldb", i]];
    }
    
    return tempDict;
}

- (NSMutableArray *)dataArr
{
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithCapacity:4];
    
    NSArray *arr = @[@"去的景点比较全面",
                     @"有我想去的名校的交流",
                     @"能跟当地学生互动",
                     @"出发日期符合",
                     @"能住寄宿家庭",
                     @"能住当地的学生公寓",
                     @"有语言课程",
                     @"没有课程，可以玩得尽兴",
                     @"我的朋友推荐或父母选的"];
    [mArr addObject:arr];
    
    NSArray *ar1 = @[@"上午上课，下午游览",
                     @"密集上课一周，后面充分游览",
                     @"户外拓展、移动主题课堂、边练边学",
                     @"参观名校、与校方代表交流",
                     @"参加名校留学说明会、吸取留学申请经验"];
    [mArr addObject:ar1];

    NSArray *ar2 = @[@"提高了外语学习兴趣和动力",
                     @"了解了西方文化和习俗",
                     @"有了明确的学业奋斗目标",
                     @"坚定了留学信念",
                     @"锻炼了独立能力，对事情更有主见",
                     @"更爱动脑筋，具有探索精神",
                     @"锻炼了领导力，提高了沟通能力",
                     @"拓展了国际视野",
                     @"和父母沟通增多，学会感恩",
                     @"更加乐观自信了",
                     @"增强环保意识了"];
    [mArr addObject:ar2];

    for (NSInteger i = 0; i < 8; ++i) {
        [mArr addObject:[NSNull new]];
    }
    
    NSArray *ar3 = @[@"美国",
                     @"英国",
                     @"澳大利亚",
                     @"新西兰",
                     @"加拿大",
                     @"欧洲",
                     @"新加坡",
                     @"日本",
                     @"中国香港"];
    [mArr addObject:ar3];

    
    return mArr;
}

- (NSArray *)titleArr
{
    return @[@"1.报名这条路线的原因",
             @"2.最喜欢的游学形式",
             @"3.参加本次游学的收获是",
             @"4.整体来说，你对游学的餐饮是否满意",
             @"5.整体来说，你对寄宿家庭的住宿是否满意",
             @"6.整体来说，你对酒店的住宿是否满意",
             @"7.整体来说，你对学生公寓的住宿是否满意",
             @"8.整体来说，你对营区的住宿是否满意",
             @"9.整体来说，你对导游的讲解和服务是否满意",
             @"10.整体来说，你对带团导师是否满意",
             @"11.整体来说，你对本次游学的满意度",
             @"12.你下次想游学的国家/地区是",
             @"13.对于学校交流的内容和方式，你更喜欢哪种?",
             @"14.整体来说，你对学的环节是否满意"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //调查问卷
    [MobClick event:Click_Task_Survey_Url_Count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
