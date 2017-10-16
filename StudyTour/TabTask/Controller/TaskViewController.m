//
//  TaskViewController.m
//  StudyTour
//
//  Created by 魏鹏 on 15/12/1.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "TaskViewController.h"
#import "TableViewCell.h"
#import "FeedBackView.h"
#import "TfeedBackView.h"
#import "FfeedBackView.h"
#import "OpinionDetailController.h"
#import "Downloader.h"
#import "SurveyController.h"
#import "TaskDetailController.h"
#import "SurveyViewController.h"

#import "MJRefresh.h"

#import "Downloader.h"
#import "AFNetworking.h"

#import "TaskModel.h"
#import "UserInfo.h"

/**
 *  每日反馈逻辑
 *  点击满意或者不满意时，在本地保存状态，
 *  当请求当前天数与保存本地的时间不一致时，更新状态
 */
@interface TaskViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    FeedBackView *feedBackView;
    TfeedBackView *tFeedBackView;
    FfeedBackView *fFeedBackView;
}
@property (nonatomic, copy) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewOriginYConstraint;

@property (nonatomic, strong) UserInfo *userInfo;

@property (nonatomic, copy) NSString *notice;//行程描述
@property (nonatomic, copy) NSString *dayth;

@property (nonatomic, copy) NSMutableArray *phones;
@end

static NSString * const CellID = @"TaskCell";

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"游学任务";
    
    _userInfo = [UserInfo sharedUserInfo];
    
    _phones = [[NSMutableArray alloc] init];
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:CellID];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = CGRectMake(0, 0, 58, 40);
    [tempBtn setImage:[UIImage imageNamed:@"phoneIcon"] forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(callUp) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:tempBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)callUp
{
    //统计紧急电话
    [MobClick event:Click_Task_Phone_Count];
    
    NSArray *teamleaders = _userInfo.teamleader;
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in teamleaders) {
        NSString *str = [NSString stringWithFormat:@"%@-%@", dict[@"teamLeaderName"], dict[@"sosPhone"]];
        [tempArr addObject:str];
        [_phones addObject:dict[@"sosPhone"]];
    }
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"拨打领队电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *btnTitle in tempArr) {
        [as addButtonWithTitle:btnTitle];
    }
    [as showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        NSString *phoneNum = [NSString stringWithFormat:@"tel://%@", _phones[buttonIndex-1]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //统计进入任务页签次数
    [MobClick event:Click_Task_Count];
    
    //  加载行程
    [self loadNotice];
    //  加载任务数据
    [self loadData];
    
    NSString *opinionStateKey = [NSString stringWithFormat:@"OpinionState%@", _userInfo.userId];
    NSString *opinionState = [[NSUserDefaults standardUserDefaults] objectForKey:opinionStateKey];
    if ([@"2" isEqualToString:opinionState]) {
        [self addFeedBackView:2];//显示评价完毕View
    } else if ([@"0" isEqualToString:opinionState] || [@"1" isEqualToString:opinionState]) {
        [self addFeedBackView:1];//显示『满意』的View
    } else {
        [self addFeedBackView:0];//显示待评价的View
    }
    [self.tableView reloadData];
}

#pragma mark - 加载当前天数，行程，领队信息
- (void)loadNotice
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"Z"];
    NSString *dateStr = [[df stringFromDate:date] substringToIndex:3];
    
    NSDictionary *param = @{@"startDate":_userInfo.startDate,
                            @"projectCode":_userInfo.group,
                            @"myTimeZone":dateStr};

    Downloader *downloader = [[Downloader alloc] init];
    [downloader POST:GetDateTimeURL param:param wating:^{
        
    } fail:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //读取user缓存
            _dayth = [self.userInfo getCurDaysString];
            _notice = [self.userInfo getCurTravelDesc];
            _tableViewOriginYConstraint.constant = tFeedBackView.frame.size.height;
            
            NSString *opinionStateKey = [NSString stringWithFormat:@"OpinionState%@", _userInfo.userId];
            NSString *opinionState = [[NSUserDefaults standardUserDefaults] objectForKey:opinionStateKey];
            if ([@"2" isEqualToString:opinionState]) {
                [self addFeedBackView:2];//显示评价完毕View
            } else if ([@"0" isEqualToString:opinionState] || [@"1" isEqualToString:opinionState]) {
                [self addFeedBackView:1];//显示『满意』的View
            } else {
                [self addFeedBackView:0];//显示待评价的View
            }
            
        });
        
    } success:^(NSDictionary *originData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (originData[@"teamleader"] != nil) {
                NSArray *leaderArr = originData[@"teamleader"];
                [_userInfo setTeamLeaders : leaderArr];
            }
            
            NSInteger day = [originData[@"curDay"] integerValue];
            _dayth = [NSString stringWithFormat:@"%ld",(long)day];
            _notice = originData[@"journeyDesc"];
            if (![_dayth isEqualToString:_userInfo.curDay]) {
                NSString *opinionStateKey = [NSString stringWithFormat:@"OpinionState%@", _userInfo.userId];
                [[NSUserDefaults standardUserDefaults] setObject:@"10" forKey:opinionStateKey];
                
                //存储当前天数 [NSString stringWithString:_dayth]
                [_userInfo setCurDays : _dayth];
                //存储当前描述
                [_userInfo setCurTravelDesc : _notice];
            }
            
            
            NSString *opinionStateKey = [NSString stringWithFormat:@"OpinionState%@", _userInfo.userId];
            NSString *opinionState = [[NSUserDefaults standardUserDefaults] objectForKey:opinionStateKey];
            if ([@"2" isEqualToString:opinionState]) {
                [self addFeedBackView:2];//显示评价完毕View
            } else if ([@"0" isEqualToString:opinionState] || [@"1" isEqualToString:opinionState]) {
                [self addFeedBackView:1];//显示『满意』的View
            } else {
                [self addFeedBackView:0];//显示待评价的View
            }
            [self.tableView reloadData];
        });
    } refresh:YES];
}

#pragma mark - 加载任务数据
- (void)loadData
{
    NSDictionary *param = @{@"cardId":_userInfo.cardId,
                            @"userId":_userInfo.userId,
                            @"tokenId":_userInfo.tokenId};
    NSString *cachePath = [HomePath stringByAppendingPathComponent:RootPath];
    NSString *lastPath = [NSString stringWithFormat:@"mytaskData%@.json", _userInfo.userId];
    cachePath = [cachePath stringByAppendingPathComponent:lastPath];
    
    Downloader *downloader = [[Downloader alloc] init];
    [downloader POST:StudyTourTaskURL cachePath:cachePath param:param wating:^{
        
    } fail:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //加载页面
            [self showTips:NetWorkTips];
            
            NSDictionary * dataDic = [self readSaveData:cachePath];
            if(dataDic != nil){
                
                [self loadNSDictionary : dataDic];
                [self.tableView reloadData];
            }
        });
    } success:^(NSDictionary *originData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //保存调查系列数据
            NSString *categoryID = [originData objectForKey:@"routeCategoryID"];
            [[NSUserDefaults standardUserDefaults] setObject:categoryID forKey:@"routeCategoryID"];
            NSString *categoryName = [originData objectForKey:@"routeCategoryName"];
            [[NSUserDefaults standardUserDefaults] setObject:categoryName forKey:@"routeCategoryName"];
            [NSUserDefaults resetStandardUserDefaults];
            
            [self loadNSDictionary : originData];
            [self.tableView reloadData];
        });
    } refresh:YES];
}

-(void)loadNSDictionary : (NSDictionary *)dicData
{
    NSArray *dicts = dicData[@"tasks"];
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:dicts.count];
    for (NSDictionary *dict in dicts)
    {
        TaskModel *model = [[TaskModel alloc] initWithDictionary:dict error:nil];
        [tempArr addObject:model];
    }
    TaskModel *model = [[TaskModel alloc] init];
    model.taskId = @"weijinpeng";
    NSString *mySurveyStateKey = [NSString stringWithFormat:@"surveyState%@", _userInfo.userId];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:mySurveyStateKey] == nil) {
        model.taskState = @"0";
    } else {
        model.taskState = [[NSUserDefaults standardUserDefaults] objectForKey:mySurveyStateKey];
    }
    model.taskTitle = @"新东方国际游学调查问卷";
    [tempArr addObject:model];
    _dataArray = tempArr;
}

#pragma mark - 添加头部每日反馈视图
- (void)addFeedBackView:(NSInteger)flag
{
    if (flag == 0) {
        if (tFeedBackView) {
            [tFeedBackView removeFromSuperview];
        }
        if (feedBackView == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedBackView" owner:self options:nil];
            feedBackView = [nib objectAtIndex:0];
        }
        
        __weak typeof(self) ws = self;
        [feedBackView setSatisfactionBlock:^(NSInteger satisfaction) {
            [ws showHud];
            if (satisfaction == 11) {//不满意
                
                [ws submit:0];
                //统计不满意
                [MobClick event:Click_Task_Dissatisfied_Count];
                return;
            }
            [ws submit:1];//满意
            //统计满意
            [MobClick event:Click_Task_Satisfied_Count];
        }];
        feedBackView.day = self.dayth;
        feedBackView.content = self.notice;
        [self.view addSubview:feedBackView];
        
        _tableViewOriginYConstraint.constant = feedBackView.frame.size.height;
    }
    else if (flag == 1) {
        if (feedBackView) {
            [feedBackView removeFromSuperview];
        }
        if (tFeedBackView == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TfeedBackView" owner:self options:nil];
            tFeedBackView = [nib objectAtIndex:0];
        }
        
        __weak typeof(self) weakself = self;
        [tFeedBackView setMoreOpinionBlock:^{
            _flag = 2;
            OpinionDetailController *odc = [[OpinionDetailController alloc] init];
            [weakself.navigationController pushViewController:odc animated:YES];
//            [weakself addFeedBackView:2];
        }];
        [self.view addSubview:tFeedBackView];
        tFeedBackView.day = self.dayth;
        tFeedBackView.content = self.notice;
        _tableViewOriginYConstraint.constant = tFeedBackView.frame.size.height;
    }
    else if (flag == 2) {
        if (tFeedBackView) {
            [tFeedBackView removeFromSuperview];
        }
        if (feedBackView) {
            [feedBackView removeFromSuperview];
        }
        if (fFeedBackView == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FfeedBackView" owner:self options:nil];
            fFeedBackView = [nib objectAtIndex:0];

        }
        [self.view addSubview:fFeedBackView];
        fFeedBackView.day = self.dayth;
        fFeedBackView.content = self.notice;
        _tableViewOriginYConstraint.constant = fFeedBackView.frame.size.height;
    }
}

- (void) headerRefresh
{
    
}

- (void) footerRefresh
{
    
}

- (void)submit:(NSInteger)flag
{
    Downloader *TVCdownloader = [[Downloader alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:flag == 1 ? @"1" : @"0" forKey:@"score"];
    [dict setValue:_userInfo.group forKey:@"groupId"];
    [dict setValue:_userInfo.tokenId forKey:@"tokenId"];
    [dict setValue:_userInfo.userId forKey:@"userId"];
    [dict setValue:@"" forKey:@"assessId"];
    [dict setValue:_userInfo.cardId forKey:@"cardId"];
    
    [TVCdownloader POST:FeedBackSubmitURL param:dict wating:^{
        
    } fail:^{
        dispatch_async(dispatch_get_main_queue(), ^{
          [self hideHud];
          [self showTips:NetWorkTips];
            
        });

    } success:^(NSDictionary *originData) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            NSString *assessId = originData[@"assessId"];
            NSString *assessIdKey = [NSString stringWithFormat:@"assessId%@", _userInfo.userId];
            if (assessId == nil) {
                
                [self showTips:SubmitDataFailTips];
                return ;
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:assessId forKey:assessIdKey];
            
            NSString *opinionStateKey = [NSString stringWithFormat:@"OpinionState%@", _userInfo.userId];
            if (flag == 0) {//提交不满意
                _flag = 2;
                OpinionDetailController *odc = [[OpinionDetailController alloc] init];
                [self.navigationController pushViewController:odc animated:YES];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:opinionStateKey];
            } else {//提交满意
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:opinionStateKey];
                [self addFeedBackView:1];
            }
        });
        
    } refresh:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataArray.count-1) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Survey%@%@", _userInfo.group, _userInfo.cardId]] != nil) {
            if ([UIDevice currentDevice].systemVersion.floatValue < 8) {
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您已做过调查问卷" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertV show];
            } else {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您已做过调查问卷" preferredStyle:UIAlertControllerStyleAlert];
                [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:ac animated:YES completion:nil];
            }
        }
        //调查问卷
        SurveyViewController *sc = [[SurveyViewController alloc] init];
        [self.navigationController pushViewController:sc animated:YES];
        return;
    }
    //每日任务
    TaskModel *model = _dataArray[indexPath.row];
    TaskDetailController *tdVC = [[TaskDetailController alloc] init];
    tdVC.navTitle = model.taskTitle;
    tdVC.taskId = model.taskId;
    [self.navigationController pushViewController:tdVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
