//
//  DynamicViewController.m
//  StudyTour
//
//  Created by 魏鹏 on 15/12/1.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "DynamicViewController.h"
#import "DynamicCell.h"
#import "Dynamic_V_Cell.h"
#import "Downloader.h"

#import "MJRefresh.h"

@interface DynamicViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString * const HcellID = @"DynamicCellH";
static NSString * const VcellID = @"DynamicCellV";

@implementation DynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"境外动态";
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"DynamicCell" bundle:nil] forCellReuseIdentifier:HcellID];
    [_tableView registerNib:[UINib nibWithNibName:@"Dynamic_V_Cell" bundle:nil] forCellReuseIdentifier:VcellID];
    
    [self createReleaseButton];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}

- (void)downloadData
{
//    Downloader *downloader = [[Downloader alloc] init];
    
}

- (void) headerRefresh
{
    
}

- (void) footerRefresh
{
    
}

- (void)createReleaseButton
{
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [releaseButton addTarget:self action:@selector(releaseDynamic:) forControlEvents:UIControlEventTouchUpInside];
    releaseButton.frame = CGRectMake(0, 0, 60, 27);
    [releaseButton setImage:[UIImage imageNamed:@"compose-alt"] forState:UIControlStateNormal];
    [releaseButton setTitle:@"发布" forState:UIControlStateNormal];
    [releaseButton setTitleColor:[UIColor colorWithHex:0xffe100] forState:UIControlStateNormal];
    [releaseButton setTitleColor:[UIColor colorWithHex:0xffe100 alpha:0.7] forState:UIControlStateHighlighted];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)releaseDynamic:(UIButton *)sender
{
    NSString *dateString = [self  dateToString:[NSDate date]];
    NSDate *date = [NSDate date];
    NSLog(@"dateString - \n%@\n%@", date, dateString);
}

- (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss  zzzz - Z"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:HcellID forIndexPath:indexPath];
        
        // 并没有什么用，以后该处改为model
        cell.state = 0;
        
        return cell;
    } else {
        Dynamic_V_Cell *cell = [tableView dequeueReusableCellWithIdentifier:VcellID forIndexPath:indexPath];
        
        // 同上
        cell.state = 0;
        
        return cell;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row % 2) {
        return 258+80;
    }
    return 500+80;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    self.tabBarController.tabBar.hidden = NO;
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    self.tabBarController.tabBar.hidden = YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
