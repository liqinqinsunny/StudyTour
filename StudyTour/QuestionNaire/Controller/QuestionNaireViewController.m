//
//  QuestionNaireViewController.m
//  StudyTour
//
//  Created by lqq on 16/6/17.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "QuestionNaireViewController.h"
#import "QuestionCell.h"
#import "MJExtension.h"
#import "NetWorkErrorView.h"
#import "Downloader.h"
#import "QuestionModel.h"
#import "ExamPaperModel.h"
#import "NSString+Frame.h"
#import "QuestionCellFrame.h"
#import "UIImage+Extension.h"
#import "UserInfoModel.h"
#import "NSString+Json.h"
#import "MBProgressHUD+MJ.h"

@interface QuestionNaireViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) BOOL *loadCacheSuccess;
@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) ExamPaperModel *examPagerModel;

@property(nonatomic,strong) NSMutableArray *questionFrames;

@property(nonatomic,strong) UserInfoModel *userinfo;
@property(nonatomic,strong) NSArray *optionAry;

@property(nonatomic,strong) UITextField *currentTextFiled;


@end

@implementation QuestionNaireViewController

- (UserInfoModel *)userinfo
{
    if (_userinfo == nil) {
        _userinfo = [UserInfoModel sharedUserInfo];
    }
    return _userinfo;
}
- (NSArray *)optionAry
{
    if (_optionAry == nil) {
        _optionAry = [NSArray array];
    }
    return _optionAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新东方国际游学调查问卷";
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(questionCellViewClickEvent:) name:QuestionCellViewClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionCellOptionTextChangeEvent:) name:QuestionCellOptionTextChangeNotification object:nil];
    
    // 当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)  name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)  name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuestionCellOptionTextbegin:) name:@"QuestionCellOptionTextbegin" object:nil];
}

- (void)QuestionCellOptionTextbegin:(NSNotification *)noti
{
    self.currentTextFiled = noti.userInfo[@"textfieldKey"];
}

#pragma mark - 增加监听 - 当键盘出现或改变时收出消息
- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect newRect = [self.currentTextFiled.superview convertRect:self.currentTextFiled.frame toView:self.view];
    CGFloat currentMaxY = CGRectGetMaxY(newRect);

    // 动画时间
    CGFloat durn = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 键盘尺寸
    CGRect keyBoardframe = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyBoardframe.origin.y - currentMaxY;
    height -= 5;
    [UIView animateWithDuration: durn animations:^{
        CGPoint point = self.tableView.contentOffset;
        point.y -= height;
        self.tableView.contentOffset = point;
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    CGRect newRect = [self.currentTextFiled.superview convertRect:self.currentTextFiled.frame toView:self.view];
    CGFloat currentMaxY = CGRectGetMaxY(newRect);

    // 动画时间
    CGFloat durn = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 键盘尺寸
    CGRect keyBoardframe = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height =  currentMaxY - keyBoardframe.origin.y;
    height += 10;
    [UIView animateWithDuration: durn animations:^{
        CGPoint point = self.tableView.contentOffset;
        point.y += height;
        self.tableView.contentOffset = point;
    }];
}

#pragma mark - 增加监听 - 页面上文本改变 选项点击选项事件

- (void)questionCellOptionTextChangeEvent:(NSNotification *)noti
{
    NSMutableArray *ary = [self.optionAry mutableCopy];
    self.currentTextFiled = noti.userInfo[@"textfiled"];
    QuestionCellFrame *cellfrme = noti.userInfo[QuestionCellViewkey];
    NSString *optionText = noti.userInfo[QuestionCellOptionTextKey];
    QuestionModel *questionModel = cellfrme.model;
    
    __block NSMutableDictionary *optionDict = [NSMutableDictionary dictionary];
    optionDict[@"ExamQuestionID"] = questionModel.ExamQuestionID;
    optionDict[@"SortId"] = questionModel.SortId;
    optionDict[@"optionText"] = optionText;
    optionDict[@"type"] = questionModel.type;
    optionDict[@"Option"] = nil;
    
    
    __block BOOL isFind = NO;
    for (int i = 0; i< self.optionAry.count; i++) {
        NSMutableDictionary *dict = self.optionAry[i];
        if ([dict[@"ExamQuestionID"] isEqualToString:questionModel.ExamQuestionID]) {
            if (dict[@"Option"] != nil) {
                optionDict[@"Option"] = dict[@"Option"];
            }
            dict[@"optionText"] = optionText;
            isFind = YES;
            break;
        }
    }
    if (!isFind) {
        [ary addObject: optionDict];
    }
    self.optionAry = [ary copy];
}
- (void)questionCellViewClickEvent:(NSNotification *)noti
{
    NSMutableArray *ary = [self.optionAry mutableCopy];

    QuestionCellFrame *cellframe = noti.userInfo[QuestionCellViewkey];
    
    NSDictionary *sdict  = noti.userInfo[QuestionStrKey];
    QuestionModel *questionModel = cellframe.model;
    
    NSMutableDictionary *optionDict = [NSMutableDictionary dictionary];
    optionDict[@"ExamQuestionID"] = questionModel.ExamQuestionID;
    optionDict[@"SortId"] = questionModel.SortId;
    optionDict[@"Option"] = sdict;
    optionDict[@"type"] = questionModel.type;
    optionDict[@"optionText"] = @"";
    
    __block BOOL isFind = NO;
    for (int i = 0; i< self.optionAry.count; i++) {
        NSMutableDictionary *dict = self.optionAry[i];
        if ([dict[@"ExamQuestionID"] isEqualToString:questionModel.ExamQuestionID]) {
            if (dict[@"optionText"] != nil) {
                optionDict[@"optionText"] = dict[@"optionText"];
            }
            dict[@"Option"] = sdict;
            isFind = YES;
            break;
        }
    }
    if (!isFind) {
        [ary addObject: optionDict];
    }
    
    self.optionAry = [ary copy];
//    NSLog(@"%@",self.optionAry);
}

#pragma mark - 提交
- (void)submitBtnClick
{
    [self showHud];
    if (self.optionAry.count < self.questionFrames.count) {
        [self hideHud];
        [MBProgressHUD showError:@"请做完题才提交！" toView: self.view];
        return;
    } else {
        __block BOOL optionflag = NO;
        [self.optionAry enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([dict[@"type"] isEqualToString:@"填空"]){
                if ([dict[@"optionText"] isEqualToString:@""]) {
                    optionflag = NO;
                    
                    *stop = YES;
                    return ; 
                } else
                {
                    optionflag = YES;
                }
            } else {
                NSDictionary *dictOption = dict[@"Option"];
                __block BOOL dxflag = NO;
                [dictOption.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSNumber *val = dictOption[key];
                    if ([val intValue] == 1) {
                        dxflag = YES;
                        *stop = YES;
                    }
                }];
                if (!dxflag) {
                    optionflag = NO;
                    *stop = YES;
                    return ;
                } else {
                    optionflag = YES;
                }
            }
        }];
        if (!optionflag) {
            [self hideHud];
            [MBProgressHUD showError:@"请做完题才提交！" toView : self.view];
            return ;
        }
    }

    Downloader *download = [[Downloader alloc]init];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    /*
     ExamPaperID：试卷Id
     ExamPaperName：试卷名称
     cardId：学员身份证
     groupId：团号
     
     Option：放置问题数组
         ExamQuestionID：题目ID
         OptionA—I：题目的答案
         optionText：题目其他答案
         SortId：题目排列顺序
     */
    param[@"ExamPaperID"] = self.examPagerModel.ExamPaperID;
    param[@"ExamPaperName"] = self.examPagerModel.ExamPaperName;
    param[@"cardId"] = self.userinfo.cardId;
    param[@"groupId"] = self.userinfo.groupId;
//    param[@"Option"] = [NSString getJsonString: self.optionAry];
    NSMutableArray *optionAryNew = [NSMutableArray array];
    
    for (NSMutableDictionary *dict in self.optionAry) {
        NSMutableDictionary *newdict = [NSMutableDictionary dictionary];
        for (NSString *key in dict.allKeys) {
            if ([key isEqualToString: @"Option"]) {
                NSDictionary *dictoption = [dict objectForKey:@"Option"];
                
                for (NSString *optk in dictoption.allKeys) {
                    [newdict setObject:dictoption[optk] forKey:optk];
                }
            }else {
                [newdict setObject:dict[key] forKey:key];
            }
        }
        [optionAryNew addObject:newdict];
    }
    NSArray *optionNew = [optionAryNew copy];
    param[@"Option"] = [NSString getJsonString: optionNew];
    
    [download POST:QuestionnaireSubmit param:param wating:^{
        
    } fail:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            [MBProgressHUD showError:@"提交失败！请稍候再试！"];
        });
    } success:^(NSDictionary *originData) {
        dispatch_async(dispatch_get_main_queue(), ^{
             if ([originData[@"result"]isEqualToString:@"T"]) {
                [self hideHud];
                [MBProgressHUD showSuccess:@"提交答卷成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        });
    } refresh:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *indentifier = [NSString stringWithFormat:@"QuestionCell%ld",indexPath.row];
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];

    if (cell == nil) {
        cell = [[QuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.cellFrame =  self.questionFrames[indexPath.row];
    cell.tag = indexPath.row;
    cell.rowIndex = indexPath.row;
    // 选中的数据绑定
    [self.optionAry enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dict[@"ExamQuestionID"] isEqualToString:cell.cellFrame.model.ExamQuestionID]) {
            cell.questDict = dict[@"Option"];
            cell.questionText = dict[@"optionText"];
        }
    }];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionCellFrame *cellframe = self.questionFrames[indexPath.row];
    return cellframe.rowHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 表头表尾
- (void)setUpHeaderView
{
    // 表头
    UIView *headerView = [[UIView alloc]init];
    UILabel *headLabel = [[UILabel alloc]init];
    CGFloat w = ScreenWidth - 40 * 2;
    headLabel.numberOfLines = 0;
    headLabel.text = self.examPagerModel.ExamPaperHeadDesc;
    headLabel.font = [UIFont systemFontOfSize:20];
    headLabel.textColor = [UIColor colorWithHex:0x333333];
    CGFloat h = [headLabel.text heightWithFont:[UIFont systemFontOfSize:20] withinWidth:w];
    headLabel.frame = CGRectMake(40, 80, w, h);
    [headerView addSubview:headLabel];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(headLabel.frame) + 80);
    self.tableView.tableHeaderView = headerView;
}
- (void)setUpfooterView
{
    UIView *footView = [[UIView alloc]init];
    
    UILabel *footLabel = [[UILabel alloc]init];
    CGFloat w = ScreenWidth - 40 * 2;
    footLabel.numberOfLines = 0;
    footLabel.text = self.examPagerModel.ExamPaperEndDesc;
    footLabel.font = [UIFont systemFontOfSize:20];
    footLabel.textColor = [UIColor colorWithHex:0x333333];
    CGFloat h = [footLabel.text heightWithFont:[UIFont systemFontOfSize:20] withinWidth:w];
    footLabel.frame = CGRectMake(40, 80, w, h);
    [footView addSubview:footLabel];
    
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0x1ac057]] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0xe7e0da]] forState:UIControlStateDisabled];
    CGFloat subY = CGRectGetMaxY(footLabel.frame) + 80;
    submitBtn.frame = CGRectMake(40, subY, w, 48);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:submitBtn];
    
    footView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(submitBtn.frame) + 80);
    self.tableView.tableFooterView = footView;
}

#pragma mark 从服务器读数据
- (void)loadDataFromSever
{
    Downloader *download = [[Downloader alloc]init];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"taskId"] = self.taskId;
    
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"question_%@.data",self.taskId]];
    
    [download POST:QuestionnaireShow cachePath:cachePath param:param wating:^{
        
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
            [self setUpHeaderView];
            [self setUpfooterView];
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
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"question_%@.data",self.taskId]];
    
    NSDictionary *data = [self readSaveData:cachePath];
    if (data == nil) {
        _loadCacheSuccess = NO;
        return;
    }else {
        _loadCacheSuccess = YES;
        [self parseData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUpHeaderView];
            [self.tableView reloadData];
        });
    }
}
#pragma mark 解析数据
- (void)parseData:(NSDictionary *)data
{
    self.examPagerModel = [ExamPaperModel mj_objectWithKeyValues:data];
    
    self.questionFrames = [NSMutableArray array];
    
    [self.examPagerModel.QuestionList enumerateObjectsUsingBlock:^(QuestionModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        QuestionCellFrame *frame = [[QuestionCellFrame alloc]init];
        frame.model = model;
        [self.questionFrames addObject:frame];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadDataFromCache];
    [self loadDataFromSever];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
