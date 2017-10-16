//
//  TraveIntroViewController.m
//  StudyTour
//
//  Created by lqq on 16/6/7.
//  Copyright © 2016年 lqq. All rights reserved.
//
#import "TraveIntroViewController.h"
#import "UIView+Extension.h"
#import "UIColor+Utils.h"
#import "NSString+Frame.h"
#import "Downloader.h"
#import "UserInfoModel.h"
#import "TravelIntroSectionHeaderView.h"
#import "MJExtension.h"
#import "TravelIntroModel.h"
#import "WJPHomeCountryCell.h"
#import "WJPHomeNewsCell.h"
#import "TravelListType.h"
#import "CountryInfoModel.h"
#import "InfomationLearningCell.h"
#import "WJPTaskModel.h"
#import "WJPStudyNewsModel.h"
#import <SafariServices/SafariServices.h>
#import "BBSViewController.h"
#import "WJPCheckDetailDocViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NetWorkErrorView.h"
#import "WJPTravelNoteHomePageController.h"
#import "UserLoginViewController.h"
#import "WJPLinkTaskCell.h"
#import "QuestionNaireViewController.h"
#import "UIImage+Extension.h"
#import "UserLoginViewController.h"
#define labelColor  [UIColor colorWithHex:0x887564]

@interface TraveIntroViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,weak) UIImageView *videoImageView;
@property(nonatomic,weak) UILabel *nameLabel;
@property(nonatomic,weak) UIButton *checkBtn;
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,weak) UIButton *submitBtn;

@property (nonatomic, assign) BOOL loadCacheSuccess;
@property(nonatomic,strong) TravelIntroModel *travelIntroModel;

@property(nonatomic,strong) NSMutableArray *arryData;
@property(nonatomic,strong) UserInfoModel *userinfo;

@end

@implementation TraveIntroViewController

- (UserInfoModel *)userinfo
{
    if (_userinfo == nil) {
        _userinfo = [UserInfoModel sharedUserInfo];
    }
    return _userinfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNaviBar];
    [self setUpUI];
    
    [self.tableView registerClass:[WJPHomeCountryCell class] forCellReuseIdentifier:NSStringFromClass([WJPHomeCountryCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"WJPLinkTaskCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([WJPLinkTaskCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfomationLearningCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([InfomationLearningCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"TravelIntroSectionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TravelIntroSectionHeaderView class])];
}
#pragma mark 从服务器读数据
- (void)loadDataFromSever
{
    Downloader *download = [[Downloader alloc]init];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cardId"] = self.userinfo.cardId;
    param[@"journeyId"] = self.userinfo.journeyId;
    param[@"groupId"] = self.userinfo.groupId;
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"MainShow_%@_%@_%@.data",self.userinfo.cardId , self.userinfo.journeyId , self.userinfo.groupId]];
    
    [download POST:MainShowURL cachePath:cachePath param:param wating:^{
    
    } fail:^{
        if (_loadCacheSuccess) {
            [self loadDataFromCache];
            [self showTips:NetWorkTips] ;
        } else {
            [self addNetWorkErrorView];
        }
    } success:^(NSDictionary *originData) {
        [self parseData:originData];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self calculationTableHeight];

            [self.videoImageView sd_setImageWithURL:[NSURL URLWithString: self.travelIntroModel.videoImage] placeholderImage:[UIImage imageNamed:@"bg_safe"]];
            self.nameLabel.text = [NSString stringWithFormat:@"你好，%@", self.travelIntroModel.stuName];
            if ([ self.travelIntroModel.type integerValue] == 1) {
//                self.checkBtn.selected = YES;
                self.submitBtn.selected = YES;
            } else {
//                self.checkBtn.selected = NO;
                self.submitBtn.selected = NO;
            }
            [self.tableView reloadData];
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
        [weakself loadDataFromSever];
        _sev = nil;
    }];
    [self.view addSubview:errorView];
}
#pragma mark 从缓存读数据
- (void)loadDataFromCache
{
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"MainShow_%@_%@_%@.data",self.userinfo.cardId , self.userinfo.journeyId , self.userinfo.groupId]];
    NSDictionary *data = [self readSaveData:cachePath];
    if (data == nil) {
        _loadCacheSuccess = NO;
        return;
    }else {
        _loadCacheSuccess = YES;
        [self parseData:data];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self calculationTableHeight];

            [self.videoImageView sd_setImageWithURL:[NSURL URLWithString: self.travelIntroModel.videoImage] placeholderImage:[UIImage imageNamed:@"bg_safe"]];
            self.nameLabel.text = [NSString stringWithFormat:@"你好，%@", self.travelIntroModel.stuName];
            if ([ self.travelIntroModel.type integerValue] == 1) {
//                self.checkBtn.selected = YES;
                self.submitBtn.selected = YES;
            } else {
//                self.checkBtn.selected = NO;
                self.submitBtn.selected = NO;
            }

            [self.tableView reloadData];
        });
    }
}
#pragma mark 解析数据
- (void)parseData:(NSDictionary *)data
{
    self.arryData = [NSMutableArray array];
    TravelIntroModel *model = [TravelIntroModel mj_objectWithKeyValues:data];
    [self.arryData addObjectsFromArray:model.list];
    
    NSMutableArray *aryTemp =  [model.list copy];
    
    [aryTemp enumerateObjectsUsingBlock:^(TravelListType *temptype, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *aaTmp = [NSMutableArray array];
        NSMutableArray *tempAry = [temptype.listObject mutableCopy];
        [tempAry enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            WJPTaskModel *taskModel = [WJPTaskModel createWJPTaskModelWithDict:dict];
            [aaTmp addObject:taskModel];
        }];
        temptype.listObject = [aaTmp copy];
    }];
    if (model.countrieses.count > 0) {
        TravelListType *temptype = [[TravelListType alloc]init];
        temptype.listName = @"更多线路";
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"contries"] = model.countrieses;
        temptype.listObject = [NSArray arrayWithObject:dict];
        [self.arryData addObject:temptype];
    }
    self.travelIntroModel = model;
}
#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arryData.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TravelIntroSectionHeaderView *headerView =  [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([TravelIntroSectionHeaderView class])];
    TravelListType *temptype = self.arryData[section];
    headerView.sectionTitle = temptype.listName;
    return headerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TravelListType *temptype = self.arryData[section];
    return temptype.listObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TravelListType *temptype = self.arryData[indexPath.section];
    if ([temptype.listName isEqualToString:@"更多线路"]) {
        NSDictionary *dict = temptype.listObject[indexPath.row];
        NSArray *countries = dict[@"contries"];
        WJPHomeCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WJPHomeCountryCell class]) forIndexPath:indexPath];
        cell.countries = countries;
        cell.ownVC = self;
        return cell;
    } else {
        if (indexPath.row >= temptype.listObject.count) {
            return [UITableViewCell new];
        }
        id mod = temptype.listObject[indexPath.row];
        if ([mod isKindOfClass:[WJPTaskModel class]]) {
            WJPTaskModel *taskModel = (WJPTaskModel *)mod;
            taskModel.noCustomBackgroundColor = NO;
            taskModel.noCustomContentColor = NO;
            if ([taskModel.type integerValue] == 1) {
                InfomationLearningCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InfomationLearningCell class]) forIndexPath:indexPath];
                cell.model = taskModel;
                if ([[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"wjpfile, %@", taskModel.taskId]]) {
                    cell.persent = 1;
                } else {
                    cell.persent = 0;
                }
                cell.height = 56;
                return cell;
                
            }
            else
            {
                WJPLinkTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WJPLinkTaskCell class]) forIndexPath:indexPath];
                cell.model = taskModel;
                cell.height = 56;
                return cell;
            }
        }
    }
    return [UITableViewCell new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TravelListType *temptype = self.arryData[indexPath.section];
    if ([temptype.listName isEqualToString:@"更多线路"]) {
        CGFloat h = (ScreenWidth - 16*2)*153/343 + 16;
        return h;
    }else {
        return 57;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TravelListType *temptype = self.arryData[indexPath.section];
    id mod = temptype.listObject[indexPath.row];
    if ([mod isKindOfClass:[WJPStudyNewsModel class]]) {
        WJPStudyNewsModel *model = mod;
        [self gotoURLWithString:model.stadyTourTitleUrl webTitle:model.stadyTourTitle];
    } else if ([mod isKindOfClass:[WJPTaskModel class]]) {
        WJPTaskModel *model = mod;
        
        if ([model.state isEqualToString:@"0"]) {
            return;
        }
        if ([model.type integerValue] == 100) {
            // 分割用的 Cell
            return;
        }else if ([model.type integerValue] == 3) {
            // 外链任务 Cell
            [self gotoURLWithString:model.link webTitle:model.title];
            return;
        }else if ([model.type integerValue] == 4) {
            QuestionNaireViewController *question = [[QuestionNaireViewController alloc]init];
            question.taskId = model.taskId;
            [self.navigationController pushViewController:question animated:YES];
            return;
        }else if ([model.type integerValue] != 1) {
            return;
        }
        
        NSString *fileName = [model.accessory componentsSeparatedByString:@"/"].lastObject;
        NSString *filePath = [NSString stringWithFormat:@"/Documents/%@", fileName];
        NSString *savedPath = [[FileUtility sandboxHomePath] stringByAppendingString:filePath];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"wjpfile, %@", model.taskId]] isEqualToString:@"已下载"]) {
            /**
             *  查看文件界面
             */
            WJPCheckDetailDocViewController *checkVC = [[WJPCheckDetailDocViewController alloc] init];
            checkVC.filePath = savedPath;
            checkVC.navTitle = model.title;
            [self.navigationController pushViewController:checkVC animated:YES];
            
            return;
        }
        
        InfomationLearningCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        Downloader *downloader = [[Downloader alloc] init];
        [downloader downloadFileWithOption:nil
                             withURLString:model.accessory
                                 savedPath:savedPath
                           downloadSuccess:^(NSString *path) {
                               [[NSUserDefaults standardUserDefaults] setValue:@"已下载" forKey:[NSString stringWithFormat:@"wjpfile, %@", model.taskId]];
                               cell.downloadCount = cell.downloadCount+1;
                               [self updateDownloadCountToServerWithTaskId:model.taskId];
                           } downloadFailure:^(NSError *error) {
                               cell.persent = 0;
                               [self showTips:@"网络连接失败，请稍后再试"];
                           } progress:^(float progress) {
                               cell.persent = progress;
                           }];
    }
    

}
#pragma mark 更新附件下载数量
- (void)updateDownloadCountToServerWithTaskId:(NSString *)taskId
{
    Downloader *downloader = [[Downloader alloc] init];
    NSDictionary *param = @{@"taskId":taskId,
                            @"taskType":@"mainobject"};
    [downloader POST:DownloadCount param:param wating:^{
        
    } fail:^{
        
    } success:^(NSDictionary *originData) {
        
    } refresh:YES];
}
#pragma mark -- 跳转外链
- (void)gotoURLWithString:(NSString *)urlString webTitle:(NSString *)title
{
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion >= 9.0) {
        SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
        //            _needChangeStatusColor = NO;
        [self presentViewController:sfvc animated:YES completion:nil];
    } else {
        BBSViewController *bbsvc = [[BBSViewController alloc] init];
        bbsvc.urlString = urlString;
        bbsvc.webTitle = title;
        [self.navigationController pushViewController:bbsvc animated:YES];
    }
}

#pragma mark - 开始进程
- (void)submit
{
    if ([self.travelIntroModel.type integerValue] == 1) {
        return;
    }
    Downloader *download = [[Downloader alloc]init];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"cardId"] = self.userinfo.cardId;
    param[@"journeyId"] = self.userinfo.journeyId;
    param[@"groupId"] = self.userinfo.groupId;
    [download POST:AgreementUrl param:param wating:^{
    } fail:^{
    } success:^(NSDictionary *originData) {
        if ([originData[@"result"] isEqualToString:@"T"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:AgreementKey];
            [NSUserDefaults resetStandardUserDefaults];
            self.userinfo.isAgree = YES;
            WJPTravelNoteHomePageController *homePage = [[WJPTravelNoteHomePageController alloc]init];
            RootNavigationController *navi = [[RootNavigationController alloc]initWithRootViewController:homePage];
            [UIApplication sharedApplication].keyWindow.rootViewController = navi;
        }
        
    } refresh:YES];
    
}
- (void)checkBtnClick
{
    if ([self.travelIntroModel.type isEqualToString:@"1"]) {
        return;
    }
    self.checkBtn.selected = ! self.checkBtn.selected;
    self.submitBtn.enabled = self.checkBtn.selected;
    
}
// 用户协议
- (void)userBtnClick
{
    NSString *url =  self.travelIntroModel.CopyrightUrl;

    NSString *fileName = [url componentsSeparatedByString:@"/"].lastObject;
    NSString *filePath = [NSString stringWithFormat:@"/Documents/%@", fileName];
    NSString *savedPath = [[FileUtility sandboxHomePath] stringByAppendingString:filePath];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"userAgreementfile"]] isEqualToString:@"已下载"]) {
        WJPCheckDetailDocViewController *checkVC = [[WJPCheckDetailDocViewController alloc] init];
        checkVC.filePath = savedPath;
        checkVC.navTitle = @"安全告知书";
        [self.navigationController pushViewController:checkVC animated:YES];
        
        return;
    } else {
        Downloader *downloader = [[Downloader alloc] init];
        [downloader downloadFileWithOption:nil withURLString:url savedPath:savedPath downloadSuccess:^(NSString *path) {
            [[NSUserDefaults standardUserDefaults] setValue:@"已下载" forKey:[NSString stringWithFormat:@"userAgreementfile"]];
            [NSUserDefaults resetStandardUserDefaults];
            
            WJPCheckDetailDocViewController *checkVC = [[WJPCheckDetailDocViewController alloc] init];
            checkVC.filePath = savedPath;
            checkVC.navTitle = @"安全告知书";
            [self.navigationController pushViewController:checkVC animated:YES];
            
        } downloadFailure:^(NSError *error) {
            [self showTips:@"打开失败！"];
        } progress:^(float progress) {
            
        }];
    }

}
// 视频播放
- (void)imgViewClick
{
    MPMoviePlayerViewController *vc =  [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:self.travelIntroModel.videoUrl]];
    [self presentMoviePlayerViewControllerAnimated:vc];
    
}

- (void)calculationTableHeight
{
    NSInteger i = self.arryData.count;
    __block CGFloat _rowheight = 0;
    _rowheight += i * 48;
    [self.arryData enumerateObjectsUsingBlock:^(TravelListType *temptype , NSUInteger idx, BOOL * _Nonnull stop) {
        if ([temptype.listName isEqualToString:@"更多线路"]) {
            CGFloat h = (ScreenWidth - 16*2)*153/343 + 16;
            _rowheight += h;
        } else {
           [temptype.listObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                _rowheight += 57;
            }];
        }
    }];
    self.tableView.height = _rowheight;
    CGFloat h = self.tableView.y + _rowheight + 32;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, h);
}

#pragma mark 页面设置
- (void)setUpUI
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor colorWithHex:0xf7f3ec];
    scrollView.delegate = self;
    scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_safe"]];
    imgView.width = self.scrollView.width;
    imgView.height = 211;
    imgView.x = imgView.y = 0;
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewClick)];
    [imgView addGestureRecognizer:tapClick];
    [self.scrollView addSubview:imgView];
    self.videoImageView = imgView;
    
    UIView *agreeView = [[UIView alloc]init];
    agreeView.width = self.scrollView.width;
    agreeView.backgroundColor = [UIColor colorWithHex:0xf7f3ec];
    agreeView.x = 0;
    agreeView.y = CGRectGetMaxY(imgView.frame);
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"你好，高强";
    nameLabel.font = [UIFont systemFontOfSize:20];
    nameLabel.textColor = labelColor;
    nameLabel.x = 16;
    nameLabel.y = 30;
    nameLabel.width = ScreenWidth - 16 * 2;
    nameLabel.height = [nameLabel.text heightWithFont:[UIFont systemFontOfSize:20] withinWidth:nameLabel.width];
    [agreeView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *welocomeLabel = [[UILabel alloc]init];
    welocomeLabel.text = @"游学世界从这里开始，把世界带回中国";
    welocomeLabel.font = [UIFont systemFontOfSize:15];
    welocomeLabel.textColor = labelColor;
    welocomeLabel.x = 16;
    welocomeLabel.y = CGRectGetMaxY(nameLabel.frame) + 8;
    welocomeLabel.width = ScreenWidth - 16 * 2;
    welocomeLabel.height = [welocomeLabel.text heightWithFont:[UIFont systemFontOfSize:15] withinWidth:welocomeLabel.width];
    [agreeView addSubview:welocomeLabel];
    
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setTitle:@"阅读以下内容后，开始行程" forState:UIControlStateNormal];
    [submitBtn setTitle:@"阅读以下内容后，开始行程" forState:UIControlStateDisabled];
    [submitBtn setTitle:@"谢谢您的阅读" forState:UIControlStateSelected];
    submitBtn.x = 16;
    submitBtn.y = CGRectGetMaxY(welocomeLabel.frame) + 20;
    submitBtn.width = ScreenWidth - 16 * 2;
    submitBtn.height = 48;
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    

    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0x1ac057]] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0xe7e0da]] forState:UIControlStateSelected];
    [submitBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0xe7e0da]] forState:UIControlStateDisabled];
    
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [agreeView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    
   
    
    UIButton *checkBtn = [[UIButton alloc]init];
    [checkBtn setImage:[UIImage imageNamed:@"ic_uncheck"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"ic_checked"] forState:UIControlStateSelected];
    checkBtn.x = 16;
    checkBtn.y = CGRectGetMaxY(submitBtn.frame) + 12;
    [checkBtn sizeToFit];
    checkBtn.selected = YES;
    [checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [agreeView addSubview:checkBtn];
    self.checkBtn = checkBtn;
    self.submitBtn.enabled = self.checkBtn.selected;
    
    UIButton *userbtn = [[UIButton alloc]init];
    userbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [userbtn setTitle:@"我已阅读并遵守《安全告知书》中的全部内容" forState:UIControlStateNormal];
    [userbtn setTitleColor:labelColor forState:UIControlStateNormal];
     userbtn.x = CGRectGetMaxX(checkBtn.frame) + 10;
    [userbtn sizeToFit];
    [userbtn addTarget:self action:@selector(userBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [agreeView addSubview:userbtn];
    userbtn.centerY = checkBtn.centerY;
    
    agreeView.height = CGRectGetMaxY(userbtn.frame);
    
    [self.scrollView addSubview:agreeView];
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    
    CGFloat y = CGRectGetMaxY(agreeView.frame);
    CGFloat h = ScreenHeight;
    tableView.frame = CGRectMake(0, y, ScreenWidth, h);
    tableView.backgroundColor = [UIColor colorWithHex:0xf7f3ec];
    [self.scrollView addSubview:tableView];
    self.tableView = tableView;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.tableView.frame));
}

#pragma mark -- LifeCircle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self loadDataFromCache];
    [self loadDataFromSever];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- UIScroll View Delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y <= 64) {
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
//    }else {
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
//    }
//}
- (void)setUpNaviBar
{
    self.navigationItem.title = @"游学简介";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:@"退出" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(exitCurrentUser:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)exitCurrentUser:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    UserInfoModel *user = [UserInfoModel sharedUserInfo];
    BOOL loginOutSuccess = [user loginOut];
    if (loginOutSuccess) {
        UserLoginViewController *loginVc = [[UserLoginViewController alloc]init];
        RootNavigationController *nc = [[RootNavigationController alloc]initWithRootViewController:loginVc];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = nc;
    }
    sender.userInteractionEnabled = YES;
}

@end