//
//  TaskDetailController.m
//  StudyTour
//
//  Created by use on 15/12/11.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "TaskDetailController.h"
#import "TaskDetailView.h"
#import "KnowTopicView.h"
#import "QuestionnaireView.h"

#import "Downloader.h"
#import "TaskDetailModel.h"

#import "UserInfo.h"

//#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TaskDetailController () <UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollV;

@property (weak, nonatomic) IBOutlet UIButton *lastOne;
@property (weak, nonatomic) IBOutlet UIButton *nextOne;

@property (nonatomic, copy) NSMutableArray *dataArray;

@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, assign) CGFloat btnHeight;
@end

@implementation TaskDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = _navTitle;
    
    _userInfo = [UserInfo sharedUserInfo];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    CGFloat btnHeight = (ScreenWidth*0.5)*14/53;
    _btnHeight = btnHeight;
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-btnHeight-64)];
    scrollV.delegate = self;
    _scrollV = scrollV;
    [self.view addSubview:scrollV];
    scrollV.pagingEnabled = YES;
    scrollV.bounces = NO;
    
    scrollV.contentSize = CGSizeMake(ScreenWidth*_dataArray.count, btnHeight);
    
    [self.view bringSubviewToFront:_lastOne];
    [self.view bringSubviewToFront:_nextOne];
    
    [self loadData];
}

- (void)loadData
{
    [self showHud];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_userInfo.tokenId forKey:@"tokenId"];
    [param setValue:self.taskId forKey:@"taskId"];
    [param setValue:_userInfo.userId forKey:@"userId"];
 
//#warning 缓存地址需特殊化
    NSString *cachePath = [HomePath stringByAppendingPathComponent:RootPath];
    NSString *lastPath = [NSString stringWithFormat:@"myTaskDetail%@%@.json", _userInfo.userId, _taskId];
    cachePath = [cachePath stringByAppendingPathComponent:lastPath];
    
    Downloader *downloader = [[Downloader alloc] init];
    [downloader POST:TaskParticularsURL cachePath:cachePath param:param wating:^{
        
    } fail:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            [self showTips:NetWorkTips];
            
            NSDictionary * dicData = [self readSaveData:cachePath];
            if (dicData != nil) {
                NSArray *dicts = dicData[@"tasks"];
                for (NSDictionary *dict in dicts) {
                    
                    TaskDetailModel *model = [TaskDetailModel createModelWithDict:dict];
                    [self.dataArray addObject:model];
                }
                if (self.dataArray.count > 0) {
                    _lastOne.hidden = NO;
                    _nextOne.hidden = NO;
                }
                [self createTaskDetailView];
            }
        });
    } success:^(NSDictionary *originData) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            NSArray *dicts = originData[@"tasks"];
            for (NSDictionary *dict in dicts) {
                
                TaskDetailModel *model = [TaskDetailModel createModelWithDict:dict];
                [self.dataArray addObject:model];
            }
            if (self.dataArray.count > 0) {
                _lastOne.hidden = NO;
                _nextOne.hidden = NO;
            }
            [self createTaskDetailView];
        });
        
    } refresh:YES];
}

- (void)createTaskDetailView
{
    _scrollV.contentSize = CGSizeMake(ScreenWidth*_dataArray.count, _btnHeight);
    for (NSInteger i = 0; i < _dataArray.count; ++i) {
        TaskDetailModel *model = _dataArray[i];
        if (model.taskType == 10) {
            
        }
        NSString *taskFlagKey = [NSString stringWithFormat:@"taskState%@%@", _userInfo.userId, _taskId];
        if (model.taskA.count <= 1 || model.taskA == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KnowTopicView" owner:self options:nil];
            KnowTopicView *ktView = [nib objectAtIndex:0];
            ktView.taskId = _taskId;
            ktView.position = [NSString stringWithFormat:@"%ld/%ld", i+1, _dataArray.count];
            ktView.model = _dataArray[i];
            
            [ktView setTaskStateBlock:^{
                if([[NSUserDefaults standardUserDefaults] objectForKey:taskFlagKey] == nil) {
                    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:taskFlagKey];
                }
                NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:taskFlagKey];
                NSInteger didNum = [num integerValue];
                ++didNum;
                if (didNum == _dataArray.count) {
                    didNum = 100;
                }
                [[NSUserDefaults standardUserDefaults] setObject:@(didNum) forKey:taskFlagKey];
            }];
            UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(_scrollV.frame.size.width*i, 0, _scrollV.frame.size.width, _scrollV.frame.size.height)];
            sv.contentSize = CGSizeMake(ScreenWidth, ktView.frame.size.height + 40);
            [ktView setTaskClickedBlock:^(CGFloat h) {
                sv.contentSize = CGSizeMake(ScreenWidth, h + 40);
            }];

            [sv addSubview:ktView];
            [_scrollV addSubview:sv];
        }
        else {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TaskDetailView" owner:self options:nil];
            TaskDetailView *tdView = [nib objectAtIndex:0];
            tdView.taskId = _taskId;
            tdView.position = [NSString stringWithFormat:@"%ld/%ld", i+1, _dataArray.count];
            tdView.model = _dataArray[i];
            [tdView setTaskStateBlock:^{
                if([[NSUserDefaults standardUserDefaults] objectForKey:taskFlagKey] == nil) {
                    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:taskFlagKey];
                }
                NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:taskFlagKey];
                NSInteger didNum = [num integerValue];
                ++didNum;
                if (didNum == _dataArray.count) {
                    didNum = 100;
                }
                [[NSUserDefaults standardUserDefaults] setObject:@(didNum) forKey:taskFlagKey];
            }];
            UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(_scrollV.frame.size.width*i, 0, _scrollV.frame.size.width, _scrollV.frame.size.height)];
//            sv.delegate = self;
            sv.contentSize = CGSizeMake(ScreenWidth, tdView.frame.size.height + 40);

            [tdView setTaskClickedBlock:^(CGFloat h) {
                sv.contentSize = CGSizeMake(ScreenWidth, h + 40);
            }];
            [sv addSubview:tdView];
            [_scrollV addSubview:sv];
        }
    }
}
- (IBAction)lastTopic:(UIButton *)sender {
    sender.userInteractionEnabled = NO;

    CGPoint offset = _scrollV.contentOffset;
    [UIView animateWithDuration:0.5 animations:^{
        _scrollV.contentOffset = CGPointMake(offset.x-ScreenWidth, offset.y);
    }];
    [self performSelector:@selector(updateBtnState) withObject:nil afterDelay:1.0];
}

- (IBAction)nextTopic:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    CGPoint offset = _scrollV.contentOffset;
    [UIView animateWithDuration:0.5 animations:^{
        _scrollV.contentOffset = CGPointMake(offset.x+ScreenWidth, offset.y);
    }];
    [self performSelector:@selector(updateBtnState) withObject:nil afterDelay:1.0];
}

- (void)updateBtnState
{
//    if (_dataArray.count <= 0) {
//        _lastOne.hidden = YES;
//        _nextOne.hidden = YES;
//        
//        return;
//    }
//    _lastOne.hidden = NO;
//    _nextOne.hidden = NO;
    if (_scrollV.contentOffset.x <= 50) {
        _lastOne.userInteractionEnabled = NO;
        _lastOne.titleLabel.textColor = [UIColor colorWithHex:0xcacaca];
    }
    else if (_lastOne.userInteractionEnabled == NO) {
        _lastOne.userInteractionEnabled = YES;
        _lastOne.titleLabel.textColor = [UIColor colorWithHex:0x4c4c4b];
    }
    if (_scrollV.contentOffset.x >= [UIScreen mainScreen].bounds.size.width * (_dataArray.count-1)-50) {
        _nextOne.userInteractionEnabled = NO;
        _nextOne.titleLabel.textColor = [UIColor colorWithHex:0xcacaca];
    }
    else if (_nextOne.userInteractionEnabled == NO) {
        _nextOne.userInteractionEnabled = YES;
        _nextOne.titleLabel.textColor = [UIColor colorWithHex:0x4c4c4b];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateBtnState];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        NSLog(@"滑动停止！！！");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //每日任务
    [MobClick event:Click_Task_EverydayTask_Count];
//    [self updateBtnState];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateBtnState];
}

@end