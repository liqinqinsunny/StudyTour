//
//  MessageViewController.m
//  StudyTour
//
//  Created by 魏鹏 on 15/12/1.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "MJRefresh.h"
#import "Downloader.h"
#import "UserInfo.h"

#import "LoginViewController.h"
#import "MyMessageModel.h"

@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *dataArray;

@end

static NSString * const CellID = @"MessageCell";

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"领队消息";
    
    _dataArray = [[NSMutableArray alloc] init];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:CellID];

    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];

    
    UIBarButtonItem *itemBtn = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = itemBtn;
    
    _tableView.tableFooterView = [UIView new];
}

- (void)logout
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"确定退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertV show];
    } else {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定退出？" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self singOut];

            });
        }]];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self singOut];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //统计进入消息页签次数
    [MobClick event:Click_Message_Count];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView.header beginRefreshing];
//    [self loadDataWithIndex:@"0" refresh:YES];
}

- (void)loadDataWithIndex:(NSString *)myIndex refresh:(BOOL)refresh
{

    UserInfo *userInfo = [UserInfo sharedUserInfo];
    Downloader *downloader = [[Downloader alloc] init];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.cardId forKey:@"cardId"];
    [param setValue:myIndex  forKey:@"newsIndex"];
    [param setValue:userInfo.tokenId forKey:@"tokenId"];
    
//    NSLog(@"领队信息提交请求信息-%@", param);
    
    NSString *cachePath = [HomePath stringByAppendingPathComponent:RootPath];
    NSString *lastPath = [NSString stringWithFormat:@"mymessage%@%@.json", userInfo.userId, myIndex];
    cachePath = [cachePath stringByAppendingPathComponent:lastPath];
    
    [downloader POST:MyMessage cachePath:cachePath param:param wating:^{
        
    } fail:^{
        //提示样式
//        [self showTips:NetWorkTips];
//        
//        self.tableView.userInteractionEnabled = NO;
//        [self performSelector:@selector(tableViewUserInter) withObject:nil afterDelay:1.5];
//        [self.tableView.footer endRefreshing];
//        [self.tableView.header endRefreshing];
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            if (_dataArray.count == 0) {
//                [self loadDataWithIndex:myIndex refresh:NO];
//            }
//        });
        dispatch_async(dispatch_get_main_queue(), ^{
            //提示样式
            [self showTips:NetWorkTips];

            self.tableView.userInteractionEnabled = NO;
            [self performSelector:@selector(tableViewUserInter) withObject:nil afterDelay:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.footer endRefreshing];
                [self.tableView.header endRefreshing];
            });
            
            //失败时读取缓存
            NSDictionary *dictdata = [self readSaveData:cachePath];
            if(dictdata != nil){

                NSArray *dataArr = [dictdata objectForKey:@"data"];
                if (dataArr != nil && dataArr.count > 0) {
                    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    [self removeNotDataTips];
                    for (NSDictionary *dict in dataArr) {
                        MyMessageModel *model = [[MyMessageModel alloc] initWithDictionary:dict error:nil];
                        [_dataArray addObject:model];
                    }
                    [self.tableView reloadData];
                }
                else{
                    [self showNotDataTips : NotMessageDataTips];
                }
            }
            else
            {
                [self showNotDataTips : NotMessageDataTips];
            }
        });
        
        
    } success:^(NSDictionary *originData) {

        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (originData[@"error"] != nil) {
                [self.tableView.footer endRefreshing];
                [self.tableView.header endRefreshing];
                if (_dataArray.count <= 0) {
                    [self showNotDataTips : NotMessageDataTips];
                }

                return ;
            }
           
            NSArray *dicts = [originData objectForKey:@"data"];
            if(dicts != nil && dicts.count > 0)
            {
                if (dicts.count > 0 && [myIndex isEqualToString:@"0"]) {
                    [_dataArray removeAllObjects];
                }
                for (NSDictionary *dict in dicts) {
                    MyMessageModel *model = [[MyMessageModel alloc] initWithDictionary:dict error:nil];
                    [_dataArray addObject:model];
                }
                _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                
                [self removeNotDataTips];
                [self.tableView reloadData];
            }
            else{
                [self showNotDataTips : NotMessageDataTips];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.footer endRefreshing];
                [self.tableView.header endRefreshing];
            });
        });
    } refresh:refresh];
}

- (void)tableViewUserInter
{
    _tableView.userInteractionEnabled = YES;
}

- (void) headerRefresh
{
    [self loadDataWithIndex:@"0" refresh:YES];
}

- (void) footerRefresh
{
    NSInteger index = 1;
    if(_dataArray.count > 0)
    {
        index = _dataArray.count;
    }
    NSString *dataNumStr = [NSString stringWithFormat:@"%ld", (index - 1)/10+1];
    [self loadDataWithIndex:dataNumStr refresh:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataArray.count) {
        return [UITableViewCell new];
    }

    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataArray.count) {
        NSLog(@"不该有的返回值");
        return 44;
    }
    NSInteger i = indexPath.row;
    MyMessageModel *model = self.dataArray[i];
    if (model.myCellHeight == nil) {
        return 44;
    }
    return [model.myCellHeight floatValue];
}

-(void)singOut
{
    //统计退出次数
    [MobClick event:Click_loginOut_Count];
    NSString * curCarId = [[UserInfo sharedUserInfo] getCurLoginUserCardId];
    
    LoginViewController *Login = [[LoginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = Login;
    [Login setUpUserCarId:curCarId];
    
    //清除当前登录用户的状态
    [[UserInfo sharedUserInfo] setCurLoginUserCardId:@""];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
