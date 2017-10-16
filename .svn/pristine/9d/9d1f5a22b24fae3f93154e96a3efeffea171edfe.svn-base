//
//  EnrollCountryViewController.m
//  StudyTourLeaderSide
//
//  Created by use on 16/3/3.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "EnrollCountryViewController.h"
#import "EnrollCountryCell.h"
#import "Downloader.h"
#import "CountryInfoModel.h"
#import "CountryDetailView.h"
#import "NetWorkErrorView.h"

@interface EnrollCountryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, assign) BOOL loadCacheSuccess;

@end

@implementation EnrollCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"国家线路";
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, -8, ScreenWidth, 8);
    view.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = view;
    
    [_tableView registerNib:[UINib nibWithNibName:@"EnrollCountryCell" bundle:nil] forCellReuseIdentifier:@"CountryCellID"];
    [self loadCountryInfoFromServer];
}

- (void)loadCountryInfoFromServer
{
    [self showHud];
    NSString *cachePath = [HomePath stringByAppendingPathComponent:CountryEnroll];
    Downloader *downloader = [[Downloader alloc] init];
//    downloader.viewController = self;
    [downloader POST:CountryShow cachePath:cachePath param:nil wating:^{
        
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
        [self parsedData:originData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            [_tableView reloadData];
        });
    } refresh:YES];
}

- (void)loadCountryInfoFromCache
{
    NSString *cachePath = [HomePath stringByAppendingPathComponent:CountryEnroll];
    NSDictionary *originData = [self readSaveData:cachePath];
    if(originData != nil){
        [self parsedData:originData];
        
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



// 解析数据
- (void)parsedData:(NSDictionary *)originData
{
    if ([originData[@"result"] isEqualToString:@"T"]) {
        NSArray *dicts = originData[@"countrys"];
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSDictionary *dict in dicts) {
            CountryInfoModel *model = [CountryInfoModel createCountryInfoModelWithDict:dict];
            [tempArr addObject:model];
        }
        self.dataArray = tempArr;
    }
}

// 添加错误提示页
- (void)addNetWorkErrorView
{
    NetWorkErrorView *errorView = [[NetWorkErrorView alloc] init];
    errorView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    [self.view addSubview:errorView];
    __weak typeof(errorView) _ev = errorView;
    __weak typeof(self) weakself = self;
    [errorView setOperateBlock:^{
        __strong NetWorkErrorView *_sev = _ev;
        [_sev removeFromSuperview];
        _sev = nil;
        [weakself loadCountryInfoFromServer];
        
        
    }];
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CountryInfoModel *model = _dataArray[indexPath.row];
    EnrollCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryCellID" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}


#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenWidth - 16) * 159 / 359 + 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CountryInfoModel *model = _dataArray[indexPath.row];
    CountryDetailView *countryDetailView = [[CountryDetailView alloc] init];
    [countryDetailView setModel:model];
    [self.navigationController.view addSubview:countryDetailView];
}


#pragma mark -- lifeCircle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCountryInfoFromCache];
    [self loadCountryInfoFromServer];
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
