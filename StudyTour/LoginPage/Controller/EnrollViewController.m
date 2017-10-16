//
//  EnrollViewController.m
//  StudyTourLeaderSide
//
//  Created by use on 16/3/3.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "EnrollViewController.h"
#import "CardIdVerification.h"
//#import "FillRegistrationController.h"
#import "Downloader.h"
//#import "MainModel.h"
#import "SDImageCache.h"
#import "EnrollInfoModel.h"
//#import "PersonInfoViewController.h"
#import "EnrollCountryViewController.h"
#import "EnrollTeacherViewController.h"
//#import "BBSViewController.h"
#import "JPDeleteLastSpace.h"

//#import "UserSingleton.h"

//#import "WJPHomePageViewController.h"
//#import "WJPLeftMenuViewController.h"
//#import "RESideMenu.h"

#import "JiPush.h"
#import <SafariServices/SafariServices.h>

@interface EnrollViewController () <UITextFieldDelegate, SFSafariViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *myRootView;

@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;
@property (weak, nonatomic) IBOutlet UITextField *cardIdTextField;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (nonatomic, assign) CGFloat keyboardDur;
@property (nonatomic, assign) CGFloat keyboardHeight;

// 如果是ios 9 的SafariViewContrller，则不需要把状态栏变成白色
@property (nonatomic, assign) BOOL needChangeStatusColor;
@end

@implementation EnrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _cardIdTextField.delegate = self;
    [_cardIdTextField setValue:[UIColor colorWithHex:0xC1B0A0] forKeyPath:@"_placeholderLabel.textColor"];
//    [_cardIdTextField setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    // textField内容要与"参与游学"对齐
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 5)];
    _cardIdTextField.leftView = view;
    _cardIdTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _bgImageView.userInteractionEnabled = YES;
    
//    [self loadStartMessageFromCache];
//    [self loadStartMessageFromServer];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToBbsVC:)];
//    [_bgImageView addGestureRecognizer:tap];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _keyboardHeight = height;

    id bValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat animationDur = [bValue floatValue];
    _keyboardDur = animationDur;
    
    [UIView animateWithDuration:animationDur animations:^{
        CGRect frame = self.myRootView.frame;
        frame.origin.y = -height;
        self.myRootView.superview.frame = frame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    
    id bValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat animationDur = [bValue floatValue];
    _keyboardDur = animationDur;
    
    [UIView animateWithDuration:animationDur animations:^{
        CGRect frame = self.myRootView.frame;
        frame.origin.y = 0;
        self.myRootView.superview.frame = frame;
    }];
    
}
/*
- (void)submitCardId
{
    [self showHud];
    Downloader *downloader = [[Downloader alloc] init];
    NSDictionary *param = @{@"cardId":_cardIdTextField.text};
    [downloader POST:CheckIdentity param:param wating:^{
        
    } fail:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            [self showTips:NetWorkTips];
        });
    } success:^(NSDictionary *originData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            EnrollInfoModel *model = [EnrollInfoModel createEnrollInfoModelWithDict:originData needInit:YES];
            
            [JiPush setAlias:model.cardId];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"LOGIN"];
            
            // 预制 默认  菜单 选项 为 1
            [self saveSideMenuSelectedIndexPath];
            
            if (![model.reviewStatus isEqualToString:@"未报名"]) {
                RootNavigationController *homePageViewController = [[RootNavigationController alloc] initWithRootViewController:[[WJPHomePageViewController alloc] init]];
                WJPLeftMenuViewController *leftMenuViewController = [[WJPLeftMenuViewController alloc] init];
                RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:homePageViewController leftMenuViewController:leftMenuViewController rightMenuViewController:nil];
                
                // 关闭缩放 隐藏
                sideMenuViewController.scaleMenuView = NO;
                sideMenuViewController.scaleContentView = NO;
                sideMenuViewController.scaleBackgroundImageView = NO;
                sideMenuViewController.fadeMenuView = NO;
                sideMenuViewController.bouncesHorizontally = NO;
                // 设置菜单的宽度，关闭 视图随设备移动而偏移
                sideMenuViewController.contentViewInPortraitOffsetCenterX = ScreenWidth*0.14;
                sideMenuViewController.parallaxEnabled = NO;
                
                [UIApplication sharedApplication].keyWindow.rootViewController = sideMenuViewController;
            }
            else {
                FillRegistrationController *viewController = [[FillRegistrationController alloc] init];
                //            viewController.model = model;
                [self.navigationController pushViewController:viewController animated:YES];
            }
        });
        
    } refresh:YES];
}
*/
- (void)saveSideMenuSelectedIndexPath
{
    NSDictionary *indexPathDict = @{@"section":@(0),
                                    @"row":@(0)};
    [[NSUserDefaults standardUserDefaults] setObject:indexPathDict forKey:@"SideMenuSelectedIndexPath"];
}

/*
- (void)loadStartMessageFromServer
{
    Downloader *downloader = [[Downloader alloc] init];

    NSString *cachePath = [HomePath stringByAppendingPathComponent:MainEnroll];
    [downloader POST:StartMessage cachePath:cachePath param:nil wating:^{
        
    } fail:^{
        
    } success:^(NSDictionary *originData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MainModel *model = [MainModel createMainModelWithDict:originData];
            // 缓存BBS_ADD
            [[NSUserDefaults standardUserDefaults] setObject:model.bbs forKey:@"BBS_ADD"];
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            // iPhone5 以下，使用小图
            if (screenHeight < 568) {
                NSURL *bgImageUrl = [NSURL URLWithString:model.BgImageLowUrl];
                [_bgImageView sd_setImageWithURL:bgImageUrl];
            } else if (screenHeight < 667) {
                NSURL *bgImageUrl = [NSURL URLWithString:model.BgImageUrl];
                [_bgImageView sd_setImageWithURL:bgImageUrl];
            } else {
                NSURL *bgImageUrl = [NSURL URLWithString:model.BgImageHighUrl];
                [_bgImageView sd_setImageWithURL:bgImageUrl];
            }
        });
        
    } refresh:YES];
}

// 从缓存中加载数据
- (void)loadStartMessageFromCache
{
    //失败时读取缓存
    NSString *cachePath = [HomePath stringByAppendingPathComponent:MainEnroll];
    NSDictionary *dictdata = [self readSaveData:cachePath];
    if(dictdata != nil){
        MainModel *model = [MainModel createMainModelWithDict:dictdata];
        // 缓存BBS_ADD
        [[NSUserDefaults standardUserDefaults] setObject:model.bbs forKey:@"BBS_ADD"];
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        // iPhone5 以下，使用小图
        if (screenHeight < 568) {
            NSURL *bgImageUrl = [NSURL URLWithString:model.BgImageLowUrl];
            [_bgImageView sd_setImageWithURL:bgImageUrl];
        } else if (screenHeight < 667) {
            NSURL *bgImageUrl = [NSURL URLWithString:model.BgImageUrl];
            [_bgImageView sd_setImageWithURL:bgImageUrl];
        } else {
            NSURL *bgImageUrl = [NSURL URLWithString:model.BgImageHighUrl];
            [_bgImageView sd_setImageWithURL:bgImageUrl];
        }
    }
    else
    {
        //        [self showNotDataTips:NotMessageDataTips];
    }
}

- (void)jumpToBbsVC:(UIGestureRecognizer *)gesture
{
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion >= 9.0) {
        SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://go.xdf.cn/index.php?app=w3g&mod=Weiba&act=detail&weiba_id=83"]];
        _needChangeStatusColor = NO;
        [self presentViewController:sfvc animated:YES completion:nil];
    } else {
        BBSViewController *bbsvc = [[BBSViewController alloc] init];
        bbsvc.urlString = @"http://go.xdf.cn/index.php?app=w3g&mod=Weiba&act=detail&weiba_id=83";
        [self.navigationController pushViewController:bbsvc animated:YES];
    }
}
*/
- (IBAction)countryBtnClicked:(UIButton *)sender {
    EnrollCountryViewController *ecvc = [[EnrollCountryViewController alloc] init];
    [self.navigationController pushViewController:ecvc animated:YES];
}

- (IBAction)teacherBtnClicked:(UIButton *)sender {
    EnrollTeacherViewController *etvc = [[EnrollTeacherViewController alloc] init];
    [self.navigationController pushViewController:etvc animated:YES];
}

- (IBAction)makeSureTouchDown:(UIButton *)sender {
    sender.backgroundColor = [UIColor colorWithHex:0x19b351];
}

- (IBAction)makeSureClickOutside:(UIButton *)sender {
    sender.backgroundColor = [UIColor colorWithHex:0x1ac057];
}   

- (IBAction)makeSureClickConnection:(UIButton *)sender {
    
    _cardIdTextField.text = [JPDeleteLastSpace deleteLastSpaceInString:_cardIdTextField.text];
    //  替换 'x' --> 'X'
    if (_cardIdTextField.text.length > 0 && [[_cardIdTextField.text substringFromIndex:_cardIdTextField.text.length-1] isEqualToString:@"x"]) {
        NSString *xxxString = [_cardIdTextField.text substringToIndex:_cardIdTextField.text.length-1];
        _cardIdTextField.text = [xxxString stringByAppendingString:@"X"];
    }
    if (![CardIdVerification cardIdVerification:_cardIdTextField.text]) {
        [self showTips:@"身份证格式错误"];
        return;
    }
    if (_cardIdTextField.isFirstResponder) {
        [_cardIdTextField resignFirstResponder];
    }
//    [self submitCardId];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _cardIdTextField.text = [JPDeleteLastSpace deleteLastSpaceInString:_cardIdTextField.text];
    if (_cardIdTextField.text.length > 0 && [[_cardIdTextField.text substringFromIndex:_cardIdTextField.text.length-1] isEqualToString:@"x"]) {
        NSString *xxxString = [_cardIdTextField.text substringToIndex:_cardIdTextField.text.length-1];
        _cardIdTextField.text = [xxxString stringByAppendingString:@"X"];
    }
    if (![CardIdVerification cardIdVerification:textField.text]) {
        [self showTips:@"身份证格式错误"];
        return NO;
    }
    if (_cardIdTextField.isFirstResponder) {
        [_cardIdTextField resignFirstResponder];
    }    [self makeSureClickConnection:nil];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _bgImageView.userInteractionEnabled = YES;
//    [UIView animateWithDuration:_keyboardDur animations:^{
//        CGRect frame = self.view.frame;
//        frame.origin.y = 0;
//        self.view.frame = frame;
//    }];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _bgImageView.userInteractionEnabled = NO;
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (_cardIdTextField.isFirstResponder) {
        [_cardIdTextField resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _needChangeStatusColor = YES;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_cardIdTextField resignFirstResponder];
    if (_needChangeStatusColor) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
//    [_cardIdTextField resignFirstResponder];
    
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
