//
//  EnrollTeacherViewController.m
//  StudyTourLeaderSide
//
//  Created by use on 16/3/3.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "EnrollTeacherViewController.h"
#import "TeacherInfoModel.h"
#import "EnrollTeacherCell.h"
#import "Downloader.h"
#import "NetWorkErrorView.h"

@interface EnrollTeacherViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, assign) BOOL loadCacheSuccess;
@end

@implementation EnrollTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"老师风采";
    
    self.view.backgroundColor = [UIColor customBackgroundColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, -12, ScreenWidth, 12);
    view.backgroundColor = [UIColor customBackgroundColor];
    _tableView.tableHeaderView = view;
    
    [_tableView registerNib:[UINib nibWithNibName:@"EnrollTeacherCell" bundle:nil] forCellReuseIdentifier:@"EnrollTeacherCell"];
    _tableView.rowHeight = (ScreenWidth - 16*2) * 402 / 343 + 130;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTeacherInfoFromCache];
    [self loadTeacherInfoFromServer];
}

- (void)loadTeacherInfoFromServer
{
    [self showHud];
    
    NSString *cachePath = [HomePath stringByAppendingPathComponent:TeacherEnroll];
    Downloader *downloader = [[Downloader alloc] init];
    
    [downloader POST:TeacherShow cachePath:cachePath param:nil wating:^{
        
    } fail:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            if (_loadCacheSuccess) {
                [self showTips:NetWorkTips];
            } else {
                [self addNetWorkErrorView];
            }
        });
    } success:^(NSDictionary *originData) {
        
        if ([originData[@"result"] isEqualToString:@"T"]) {
            NSArray *dicts = originData[@"teachers"];
            NSMutableArray *tempArr = [NSMutableArray new];
            for (NSDictionary *dict in dicts) {
                TeacherInfoModel *model = [TeacherInfoModel createTeacherInfoModelWithDict:dict];
                [tempArr addObject:model];
            }
            self.dataArray = tempArr;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            [_tableView reloadData];
        });
    } refresh:YES];
}

// 添加错误提示页
- (void)addNetWorkErrorView
{
    NetWorkErrorView *errorView = [[NetWorkErrorView alloc] init];
    errorView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    __weak typeof(errorView) _ev = errorView;
    __weak typeof(self) weakself = self;
    [errorView setOperateBlock:^{
        __strong NetWorkErrorView *_sev = _ev;
        [_sev removeFromSuperview];
        [weakself loadTeacherInfoFromServer];
        _sev = nil;
    }];
    [self.view addSubview:errorView];
}

- (void)loadTeacherInfoFromCache
{
    NSString *cachePath = [HomePath stringByAppendingPathComponent:TeacherEnroll];
    NSDictionary *originData = [self readSaveData:cachePath];
    if(originData != nil){
        if ([originData[@"result"] isEqualToString:@"T"]) {
            NSArray *dicts = originData[@"teachers"];
            NSMutableArray *tempArr = [NSMutableArray new];
            for (NSDictionary *dict in dicts) {
                TeacherInfoModel *model = [TeacherInfoModel createTeacherInfoModelWithDict:dict];
                [tempArr addObject:model];
            }
            self.dataArray = tempArr;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _loadCacheSuccess = YES;
            [self hideHud];
            [_tableView reloadData];
        });
    }
    else
    {
        _loadCacheSuccess = NO;
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= _dataArray.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.hidden = YES;
        return cell;
    }
    TeacherInfoModel *model = _dataArray[indexPath.row];
    EnrollTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnrollTeacherCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
