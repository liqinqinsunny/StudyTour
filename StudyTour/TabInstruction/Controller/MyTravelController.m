//
//  MyTravelController.m
//  StudyTour
//
//  Created by owen on 15/12/16.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "MyTravelController.h"
#import "MyTravelView.h"
#import "MyTravel.h"
#import "Downloader.h"
#import "FileUtility.h"
#import "UserInfo.h"

@implementation MyTravelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollview.delegate = self;
    [self setNavigationStyle];
    self.curDay = 0;
    
    self.pagePointArr = [[NSMutableArray alloc]init];
    
    NSString *cachePath = [HomePath stringByAppendingPathComponent:RootPath];
    NSString * cacheFilePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.json",[UserInfo sharedUserInfo].cardId, MyTravelData]];
    [self operateNetwork:cacheFilePath];
}

-(void)operateNetwork  : (NSString *)savePath
{
    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    [self showHud];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:userInfo.cardId forKey:@"cardId"];
    [dic setObject:userInfo.tokenId forKey:@"tokenId"];
    
    Downloader * down = [[Downloader alloc]init];
    [down POST:TraveURL cachePath:savePath param:dic wating:^{

    } fail:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //提示失败
            [self hideHud];
            [self showTips:NetWorkTips];
            //失败时读取缓存
            NSDictionary *dict = [self readSaveData:savePath];
            if(dict != nil){
                [self initScrollData:dict];
            }
        });
        
    } success:^(NSDictionary *originData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //加载页面
            [self hideHud];
            [self initScrollData:originData];
            
        });
        
    } refresh:YES];
}

-(void)initScrollData : (NSDictionary *)dicData
{
    //获取Model数据
    NSArray * mytravelArr = [MyTravel readMyTravelData:dicData];
    if (!mytravelArr.count) {
        return;
    }
    CGRect scrollRect = self.scrollview.bounds;
    self.curDay = [[UserInfo sharedUserInfo] getCurDays] -1;
    for (NSInteger i = 0; i< mytravelArr.count; i++) {
        
        MyTravel * travelModel = [mytravelArr objectAtIndex:i];
        
        MyTravelView * traveliew = [[MyTravelView alloc]init:self];
        
        [traveliew loadData:travelModel height:^(CGFloat height) {
            
            //根据坐标设置显示区域实际大小 (此高度 + 40) + 上次坐标
            CGFloat upHeight = 0;
            if (self.pagePointArr.count) {
                upHeight = [[self.pagePointArr lastObject]floatValue];
                
            }
            //当前视图的总高度 = 自身高度 + 20
            CGFloat curHeight = height + 20 + upHeight;
            self.scrollview.contentSize = CGSizeMake(0 , curHeight);
            //当前视图的坐标点 = 上次的总高度
            self.posY = upHeight;
            //记录当前视图的总高度
            NSNumber * nsHeight = [NSNumber numberWithFloat:curHeight];
            [self.pagePointArr addObject:nsHeight];
        }];
        //父视图上面间距20 traveliew的height加上20
        CGRect viewRect = CGRectMake(0, self.posY, scrollRect.size.width, self.posY);
        [traveliew setFrame:viewRect];
        
        [self.scrollview addSubview:traveliew];
        
        //第一个去掉底线
        if (i == 0) {
            [traveliew setBaseLineHidden:YES];
        }
        //显示当前第几天
        if (i == self.curDay) {
            [traveliew showCurDayState];
            [traveliew showCurDayTravelWay:travelModel.travel];
        }
    }
    //显示位置
    if (self.curDay >= 1) {
        if (self.pagePointArr.count <= self.curDay) {
            return;
        }
        CGFloat posY = [self.pagePointArr[self.curDay - 1] floatValue];
        //判断最后几条heigt 是否在scrollview 最后一屏中
        CGFloat scrollH = self.scrollview.contentSize.height;
        CGFloat lastScreenH = scrollH - posY;  //当前天的坐标 距离scroll底部的距离
        CGFloat screenH = ScreenHeight - NavAndStatusBarHeight;
        if (screenH > lastScreenH) {           //是否在最后一屏中
             CGPoint point = CGPointMake(0, scrollH - screenH);
            [self.scrollview setContentOffset:point animated:NO];
        }
        else{
             CGPoint point = CGPointMake(0, posY + 1);
            [self.scrollview setContentOffset:point animated:NO];
        }
    }
}

-(void)setNavigationStyle
{
    self.navigationItem.title = @"查看行程";
    //initWithCustomView 用控件视图来实现导航按钮 支持ios6
    //ios6以后 可以直接使用initWithImage
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Rounded-Rectangle-3-copy-4.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBarBtn:)];
//    self.navigationItem.leftBarButtonItem = item;
}

-(void)onBarBtn:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //统计进入我的行程页面
    [MobClick event:Click_Notice_Trip_Count];
}

@end
