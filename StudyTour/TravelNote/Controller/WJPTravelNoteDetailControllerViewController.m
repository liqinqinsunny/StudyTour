//
//  WJPTravelNoteDetailControllerViewController.m
//  StudyTour
//
//  Created by use on 16/6/1.
//  Copyright © 2016年 魏鹏. All rights reserved.
//

#import "WJPTravelNoteDetailControllerViewController.h"

#import "Downloader.h"
#import "NetWorkErrorView.h"
#import "TravelNoteUnitCell.h"
#import "Downloader.h"
#import "MJExtension.h"
#import "TravelDetails.h"
#import "TravelNoteUnitCell.h"
#import "NSString+Frame.h"
#import "HeaderView.h"
#import "UIView+Extension.h"
#import "Accessorys.h"
#import "Particularses.h"
#import "InfomationLearningCell.h"
#import "WJPCheckDetailDocViewController.h"
#import "Downloader.h"
#import "MBProgressHUD.h"
#import "TitleButton.h"
#import "UMSocial.h"
#import "UMSocialSnsService.h"
#import "NetWorkErrorView.h"
#import "WJPWriteTravelNoteViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialDataService.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "WJPLinkTaskCell.h"
#import <SafariServices/SafariServices.h>
#import "BBSViewController.h"

#import "HeaderView.h"
#import "TravelNoteFooterView.h"
#import "TravelNoteCoverModel.h"
#import "TravelDetailHeader.h"

#import "UserInfoModel.h"
#import "SDImageCache.h"

#define lastPath    [NSString stringWithFormat:@"TravelNoteDataCache%@+%@+%@.json",(self.templateId),(self.groupId),(self.introId)]
#define cachefilePath   [[HomePath stringByAppendingPathComponent:RootPath] stringByAppendingPathComponent:(lastPath)]

@interface WJPTravelNoteDetailControllerViewController ()<UITableViewDelegate, UITableViewDataSource, UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) HeaderView *headerView;

@property TravelNoteFooterView *footerView;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, assign) BOOL loadCacheSuccess;
// 模型数据
@property(nonatomic,strong) TravelDetails *travelDetailsModel;

@property (nonatomic, strong) NSMutableString *needScroll;

@property (nonatomic, assign) BOOL fromCheckDocVC;

@end

@implementation WJPTravelNoteDetailControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViewConfig];
}

- (void)initViewConfig
{
    self.view.backgroundColor = [UIColor customBackgroundColor];
    self.navigationItem.title = @"游记详情";
    
    /**
     *  设置游记标题
     */
    if (_headerView == nil) {
        HeaderView *headerView = [[HeaderView alloc] init];
        headerView.frame = CGRectMake(0, 0, ScreenWidth, 56);
        _headerView = headerView;
    }

    /**
     *  设置footerView : "上滑加载下一个游记"
     */
    if (_footerView == nil) {
        TravelNoteFooterView *footerView = [[TravelNoteFooterView alloc] init];
        if (_currentIndex == _travelArray.count-1) {
            footerView.noticeTitle = nil;
        } else {
            TravelNoteCoverModel *model = _travelArray[_currentIndex+1];
            footerView.noticeTitle = model.title;
        }
        _footerView = footerView;
    }

    /**
     *  设置headerView : "下拉加载上一个游记"
     */
    TravelDetailHeader *upHeaderView = [[TravelDetailHeader alloc] init];
    upHeaderView.frame = CGRectMake(0, -80, ScreenWidth, 80);
    if (_currentIndex == 0) {
        upHeaderView.noticeTitle = nil;
    } else {
        TravelNoteCoverModel *model = _travelArray[_currentIndex-1];
        upHeaderView.noticeTitle = model.title;
    }
    [_tableView addSubview:upHeaderView];
    
    
    // 分享
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_traveldetails_share.png"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = shareItem;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TravelNoteUnitCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TravelNoteUnitCell class])];
    /**
     *  注册 cell
     */
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TravelNoteUnitCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TravelNoteUnitCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InfomationLearningCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([InfomationLearningCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WJPLinkTaskCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WJPLinkTaskCell class])];
}

- (void)initDataConfig
{
    TravelNoteCoverModel *model = _travelArray[_currentIndex];
    _templateId = model.templateId;
    _groupId = [UserInfoModel sharedUserInfo].groupId;
    if (_needScroll == nil) {
        _needScroll = [[NSMutableString alloc] initWithString:@"0"];
    }
}

#pragma mark - 再写一点
- (IBAction)writeMore:(UIButton *)sender {
    WJPWriteTravelNoteViewController *noteVc = [[WJPWriteTravelNoteViewController alloc]init];
    noteVc.incidentId = self.introId;
    noteVc.templateId = self.templateId;
    noteVc.needRequest = NO;
    noteVc.isFromSuperViewController = YES;
    noteVc.generalizeId = self.travelDetailsModel.generalizeId;
    noteVc.titleString = self.travelDetailsModel.title;
    noteVc.tagName = self.travelDetailsModel.tagName;
    noteVc.needScroll = _needScroll;
    [self.navigationController pushViewController:noteVc animated:YES];
}

#pragma mark -- 分享
- (void)share
{
    //分享内嵌文字
    NSMutableString *url = [self.travelDetailsModel.shareUrl mutableCopy];
    if (![url isEqualToString:@""]) {
        [url appendFormat:@"?groupId=%@&introId=%@#%@",self.groupId,self.introId,self.templateId];
    }
    NSString *shareText = [NSString stringWithFormat:@"%@ %@ %@",self.groupId, self.travelDetailsModel.incidentName,self.travelDetailsModel.title];
    //分享内嵌图片
    UIImage *shareImage;
    if (![self.travelDetailsModel.coverUrl isEqualToString:@""]) {
        shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.travelDetailsModel.coverUrl]]];
    }
    
    if (shareImage == nil) {
        shareImage = [[UIImage alloc] init];
    }
    
    //调用快速分享接口
    //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
    [UMSocialData defaultData].extConfig.title = shareText;//@"游学领队";
    [UMSocialData defaultData].extConfig.wechatFavoriteData.url = url; //微信收藏
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url; //分享到微信朋友圈内容
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url; //分享到微信好友内容
    
    NSLog(@"\nURL:%@", url);
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMengAppKey
                                      shareText:@""
                                     shareImage:shareImage
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatFavorite,UMShareToWechatTimeline]
                                       delegate:self];
}

#pragma mark -- 加载数据
- (void)loadTravelNoteDataFromServer
{
    if (_fromCheckDocVC) {
        _fromCheckDocVC = NO;
        return;
    }
    
    [self showHud];
    Downloader *downloader = [[Downloader alloc] init];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    // templateId:游记概论Id
    param[@"templateId"] = self.templateId;
    // groupId：团号
    param[@"groupId"] = self.groupId;
    // introId：事件Id
    param[@"introId"] = self.introId;
    
    [downloader POST:StuParticularsShow cachePath:cachefilePath param:param wating:^{
    } fail:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadTravelNoteDataFromCache];
            [self hideHud];
            [self showTips:NetWorkTips] ;
        });
    } success:^(NSDictionary *originData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ParseData:originData];
            [self hideHud];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.headerView.travelDetailsModel = self.travelDetailsModel;
            _tableView.tableHeaderView = _headerView;
            _tableView.tableFooterView = _footerView;
            [self jp_reloadData];
        });
        
    } refresh:YES];
}

// 添加错误提示页
- (void)addNetWorkErrorView
{
    NetWorkErrorView *errorView = [[NetWorkErrorView alloc] init];
    errorView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    __weak typeof(errorView) _ev = errorView;
    __weak typeof(self) weakself = self;
    [errorView setOperateBlock:^{
        __strong NetWorkErrorView *_sev = _ev;
        [_sev removeFromSuperview];
        [weakself loadTravelNoteDataFromServer];
        _sev = nil;
    }];
    [self.view addSubview:errorView];
}

- (void)loadTravelNoteDataFromCache
{
    NSDictionary *dict =[self readSaveData:cachefilePath];
    if (!dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addNetWorkErrorView];
        });
        return;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ParseData:dict];
            self.headerView.travelDetailsModel = self.travelDetailsModel;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            _tableView.tableHeaderView = _headerView;
            _tableView.tableFooterView = _footerView;
            [self jp_reloadData];
        });
    }
}

// 读取缓存的数据
- (NSDictionary *)readSaveData:(NSString *)filePath
{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        return nil;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if(dict != nil){
        return dict;
    }
    return nil;
}

// 解析数据
- (void)ParseData:(NSDictionary *)dict
{
    self.travelDetailsModel = [TravelDetails createTravelDetailsModelWithDict:dict];
    if (self.travelDetailsModel.particularseArray.count > 0) {
        NSMutableArray *tempArray = [self.travelDetailsModel.particularseArray mutableCopy];
        Particularses *jpmodel = tempArray[0];
        NSArray *accessoryArray = jpmodel.accessoryArray;
        
        for (NSInteger i = 0; i < accessoryArray.count; ++i) {
            WJPTaskModel *model = accessoryArray[i];
            model.noCustomBackgroundColor = YES;
            model.noCustomContentColor = YES;
            [tempArray insertObject:model atIndex:i+1];
            
        }
        self.travelDetailsModel.particularseArray = [tempArray copy];
    }
}
- (void)updateDownloadCountToServerWithTaskId:(NSString *)taskId
{
    Downloader *downloader = [[Downloader alloc] init];
    NSDictionary *param = @{@"taskId":taskId,
                            @"taskType":@"travel"};
    [downloader POST:DownloadCount param:param wating:^{
        
    } fail:^{
        
    } success:^(NSDictionary *originData) {
        
    } refresh:YES];
}
/**
 *  提交点赞
 */
- (void)updateLikeToServer
{
    Downloader *downloader = [[Downloader alloc] init];
    NSDictionary *param = @{@"templateId":_templateId};
    [downloader POST:UpdateLike param:param wating:^{
        
    } fail:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _likeButton.enabled = YES;
        });
    } success:^(NSDictionary *originData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _likeButton.enabled = YES;
            [_headerView likeCountAddOne];
        });
    } refresh:YES];
}

#pragma mark -- 跳转外链
- (void)updataDataWithIndexPath:(NSIndexPath *)indexPath GotoURLWithString:(NSString *)urlString webTitle:(NSString *)webTitle
{
    UserInfoModel *user = [UserInfoModel sharedUserInfo];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"stuName"] = user.stuName;
    param[@"cardId"] = user.cardId;
    param[@"type"] = @"1" ; // 上传人状态 1:学生 ，2: 领队
    param[@"groupId"] = self.groupId;
    param[@"incidentId"] = self.introId;
    param[@"generalizeId"] = self.travelDetailsModel.generalizeId;
    param[@"generalizeName"] = self.travelDetailsModel.title;
    
    Downloader *downloader = [[Downloader alloc]init];
    
    [downloader POST:ClassRegisterSubmit param:param wating:^{
    } fail:^{
    } success:^(NSDictionary *originData) {
    } refresh:YES];
    
    [self gotoURLWithString:urlString webTitle:webTitle];
}

#pragma mark -- UITable View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.travelDetailsModel.particularseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.travelDetailsModel.particularseArray.count) {
        return [UITableViewCell new];
    }
    id model = self.travelDetailsModel.particularseArray[indexPath.row];
    if ([model isKindOfClass:[WJPTaskModel class]]) {
        WJPTaskModel *taskModel = model;
        if ([taskModel.type integerValue] == 1) {
            InfomationLearningCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InfomationLearningCell class]) forIndexPath:indexPath];
            cell.model = taskModel;
            if ([[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"wjpfile, %@", taskModel.taskId]]) {
                cell.persent = 1;
            }
            cell.height = 56;
            return cell;
        } else {
            WJPLinkTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WJPLinkTaskCell class]) forIndexPath:indexPath];
            cell.model = model;
            
            cell.height = 56;
            return cell;
        }
    } else {
        TravelNoteUnitCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TravelNoteUnitCell class]) forIndexPath:indexPath];
        Particularses *particularsModel = self.travelDetailsModel.particularseArray[indexPath.row];
        cell.model = particularsModel;
        return cell;
    }
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.travelDetailsModel.particularseArray[indexPath.row];
    if ([model isKindOfClass:[WJPTaskModel class]]) {
        return 57;
    } else {
        Particularses *p_model = model;
        return p_model.cellHeight;
    }
}

- (void)jp_reloadData
{
    [_tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_jp_scrollToLastCell || [_needScroll isEqualToString:@"1"]) {
            NSInteger cellPosition = self.travelDetailsModel.particularseArray.count - 1;
            if (cellPosition > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellPosition inSection:0];
                [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    });
}

#pragma mark -- UITable View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id taskModel = self.travelDetailsModel.particularseArray[indexPath.row];
    if ([taskModel isKindOfClass:[WJPTaskModel class]]) {
        WJPTaskModel *model = taskModel;
        
        if ([model.state isEqualToString:@"0"]) {
            return;
        }
        
        if ([model.type integerValue] == 100) {
            // 分割用的 Cell
            return;
        } else if ([model.type integerValue] == 3) {
            // 外链任务 Cell
            [self gotoURLWithString:model.link webTitle:model.title];
            return;
        } else if ([model.type integerValue] == 5) {
            // 外链任务 点击得更新服务器数据
            NSString *linkString = [NSString stringWithFormat:@"%@?generalizeId=%@&groupId=%@", model.link, _travelDetailsModel.generalizeId, self.groupId];
            [self updataDataWithIndexPath:indexPath GotoURLWithString:linkString webTitle:model.title];
            return;
        } else if ([model.type integerValue] != 1) {
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
            _fromCheckDocVC = YES;
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

#pragma mark -- UIScroll View Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentSize.height < ScreenHeight-48-64) {
        scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight-48-64);
    }
    NSLog(@"\n%@\n%@", NSStringFromCGSize(scrollView.contentSize), NSStringFromCGPoint(scrollView.contentOffset));
    if ((scrollView.contentOffset.y + ScreenHeight-48) > (scrollView.contentSize.height+80)) {
        if (_currentIndex >= _travelArray.count-1) {
            return;
        }
        WJPTravelNoteDetailControllerViewController *svc = [[WJPTravelNoteDetailControllerViewController alloc] init];
        svc.introId = _introId;
        svc.travelArray = _travelArray;
        svc.currentIndex = _currentIndex + 1;
        [self.view addSubview:svc.view];
        svc.view.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-64);
        [UIView animateWithDuration:1 animations:^{
            svc.view.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
        } completion:^(BOOL finished) {
            [self.navigationController pushViewController:svc animated:NO];
        }];
        
//        [self.navigationController.view.layer addAnimation:[self getTransitionUp:YES] forKey:kCATransition];
//        [self.navigationController pushViewController:svc animated:NO];
    } else if ((scrollView.contentOffset.y+64) < (-80)) {
        if (_currentIndex <= 0) {
            return;
        }
        WJPTravelNoteDetailControllerViewController *svc = [[WJPTravelNoteDetailControllerViewController alloc] init];
        svc.introId = _introId;
        svc.travelArray = _travelArray;
        svc.currentIndex = _currentIndex - 1;
        [self.navigationController.view.layer addAnimation:[self getTransitionUp:NO] forKey:kCATransition];
        [self.navigationController pushViewController:svc animated:NO];
    }
}

-(float)getTableViewHeight
{
    [self.tableView layoutIfNeeded];
    return self.tableView.contentSize.height;
}

#pragma mark -- 转场动画
- (CATransition *)getTransitionUp:(BOOL)isUp
{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    if (isUp) {
        transition.subtype = kCATransitionFromTop;
    } else {
        transition.subtype = kCATransitionFromBottom;
    }
    transition.duration = 0.75;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return transition;
}

#pragma mark -- 跳转&点击
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

- (IBAction)likeButtonClicked:(UIButton *)sender {
    sender.enabled = NO;
    [self updateLikeToServer];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 50, 24);
    label.center = sender.center;
    label.text = @"+1";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:30];
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    [UIView animateWithDuration:0.5 animations:^{
        label.alpha = 0;
        CGAffineTransform transform_move = CGAffineTransformMakeTranslation(0, -80);
        CGAffineTransform transform_scale = CGAffineTransformScale(transform_move, 0.6, 0.6);
        label.transform = transform_scale;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}

#pragma mark -- Life Circle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initDataConfig];
    
//    [self loadTravelNoteDataFromServer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadTravelNoteDataFromServer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _jp_scrollToLastCell = NO;
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"嘀！嘀！嘀！内存警告 -- From %@", self);
//    if ([self isViewLoaded]) {
//        
//    }
}

- (void)dealloc
{
    NSLog(@"详情被销毁喽");
}

- (void)back:(UIBarButtonItem *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
