//
//  CheckQuestionController.m
//  StudyTour
//
//  Created by owen on 15/12/11.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "CheckQuestionController.h"
#import "Questions.h"
#import "UserInfo.h"

@implementation CheckQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"安全测试";
    self.pageIndex = 0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollview.delegate = self;
    self.viewArr = [[NSMutableArray alloc]init];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showHud];
    
    //统计进入测试题
    [MobClick event:Click_Notice_Test_Count];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [NSThread detachNewThreadSelector:@selector(initXibData) toTarget:self withObject:nil];
}

-(void)initXibData
{
    self.questions = [Questions readQuestionsPlist];

    for (NSInteger i = 0; i<self.questions.count; i++) {
        CGRect viewRect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        QuestionView *views = [[QuestionView alloc]initWithFrame:viewRect Obbject:self];
        [self.viewArr addObject:views];
    }
    [self performSelectorOnMainThread:@selector(initScrollData) withObject:nil waitUntilDone:YES];
    
    //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        self.questions = [Questions readQuestionsPlist];
    //
    //        for (NSInteger i = 0; i<self.questions.count; i++) {
    //            CGRect viewRect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //            QuestionView *views = [[QuestionView alloc]initWithFrame:viewRect Obbject:self];
    //            [self.viewArr addObject:views];
    //        }
    //
    //        //通知主线程刷新
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //
    //            [self initScrollData];
    //        });
    //        
    //    });
}


//初始化scroll数据
-(void)initScrollData
{
    if (!self.questions.count) {
        return;
    }
    
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    NSString * const QuestionStateArrKey = [NSString stringWithFormat:@"QuestionStateArrKey%@", userInfo.userId];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:QuestionStateArrKey] == nil) {
        NSArray *arr = @[@"0", @"0", @"0", @"0", @"0",
                         @"0", @"0", @"0", @"0", @"0"];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:QuestionStateArrKey];
    }
    NSArray *qsArr = [[NSUserDefaults standardUserDefaults] objectForKey:QuestionStateArrKey];
    NSInteger i = 0;
    for (; i < qsArr.count; ++i) {
        NSString *qsStr = qsArr[i];
        if ([qsStr isEqualToString:@"0"]) {
            self.pageIndex = i;
            break;
        }
    }
    
    [self hideHud];
    CGRect screenRect =  [UIScreen mainScreen].bounds;
    CGSize screenSize = screenRect.size;
    
    //设置显示区域实际大小 114=20+44+50
    self.scrollview.contentSize = CGSizeMake(screenSize.width * self.questions.count, 0);
    
    CGRect scrollRect = self.scrollview.bounds;
    for (NSInteger i = 0; i < self.questions.count; i++) {
        //设置每页实际坐标
        CGFloat posX = screenSize.width * i;
        //视图的长宽按照滚动层缩放
        CGRect viewRect = CGRectMake(posX, 0, scrollRect.size.width, scrollRect.size.height);
//        QuestionView * CustomView = [[QuestionView alloc]initWithFrame:viewRect Obbject:self];
        QuestionView * CustomView = [self.viewArr objectAtIndex:i];
        [CustomView setFrame:viewRect];
        [self.scrollview addSubview:CustomView];
        
        Questions * quesObj = [self.questions objectAtIndex:i];
        //加载数据 判断当前题目是否已经做过 改变做题状态
        [CustomView loadData:quesObj atIndex:i Count:self.questions.count];

    }

    [self.scrollview setContentOffset:CGPointMake(0, 0) animated:false];
    if (self.pageIndex) {
         CGFloat posX = screenSize.width * self.pageIndex;
        [self.scrollview setContentOffset:CGPointMake(posX, 0) animated:false];
    }
    [self setTurnButtonState];
}

- (IBAction)upBtnAction:(UIButton *)sender
{
    [self convertToPoint:self.pageIndex -1];
}

- (IBAction)nextBtnAction:(UIButton *)sender
{
    [self convertToPoint:self.pageIndex +1];
}

-(void)setTurnButtonState
{
    if (self.pageIndex == 0) {
        self.upTitleBtn.enabled = NO;
    }
    else if (self.pageIndex == self.questions.count -1){
        self.nextTitleBtn.enabled = NO;
    }
    else{
        self.upTitleBtn.enabled = YES;
        self.nextTitleBtn.enabled = YES;
    }
    
}

-(void)convertToPoint : (NSInteger)index
{
    CGFloat posX = ScreenWidth * index;
    [self setTurnPage:CGPointMake(posX, 0)];
}

-(void)setTurnPage : (CGPoint)point
{
    [self.scrollview setContentOffset:point animated:YES];
    NSInteger index = point.x/ScreenWidth;
    self.pageIndex = index;
    [self setTurnButtonState];
}

//代理实现
//滚动视图完成，滚动将停止时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point = self.scrollview.contentOffset;
    [self setTurnPage:point];
    
}


@end
