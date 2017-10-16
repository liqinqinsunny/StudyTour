//
//  LoginViewController.m
//  StudyTour
//
//  Created by use on 15/12/8.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "LoginViewController.h"
#import "Downloader.h"
#import "JPTabBarController.h"
#import "UserInfo.h"
#import "FxGlobal.h"
#import "MobClick.h"


@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cidTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _cidTextField.delegate = self;
    _cidTextField.textColor = [UIColor whiteColor];
    UIColor *color = [UIColor colorWithHex:0xB1DFC7];
    _cidTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_cidTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
}

- (IBAction)bindCid:(UIButton *)sender {
    [_cidTextField resignFirstResponder];
    if ([_cidTextField.text isEqualToString:@""] || _cidTextField.text == nil) {
        [self showTips:@"请输入身份证号或护照号"];
        return;
    }
    [self showHud];
    //统计 学员绑定账号(登录)
    [MobClick event:Click_Login_Count];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    NSDictionary *parameters = @{@"cardId":_cidTextField.text};

//    [manager POST:LoginURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        
//        if (responseObject == nil) {
//            [self hideHud];
//            [self showTips:@"网络请求失败"];
//            return;
//        }
//        NSDictionary *userDict = responseObject;
//        if ([userDict[@"cardId"] isEqualToString:@"0"]) {
//            [self hideHud];
//            [self showTips:@"用户不存在，请输入正确的证件号"];
//            return;
//        }
//        
//        //保存用户信息
//        UserInfo *userInfo = [[UserInfo sharedUserInfo] initWithDictionary:userDict error:nil];
//        
//        [[UserInfo sharedUserInfo] saveUserDataToDictionary:userDict];
//        
//        //注册别名和页签
//        [[FxGlobal global].push setTopic:userInfo.group Andalias:userInfo.cardId];
//
//        
//        //友盟统计
////        [MobClick profileSignInWithPUID:userInfo.cardId];
//        //统计登录成功
//        [MobClick event:Click_LoginSucces_Count];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self hideHud];
//            [UIApplication sharedApplication].keyWindow.rootViewController = [[JPTabBarController alloc] init];
//            
//        });
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self hideHud];
//        //统计登录失败
//        [MobClick event:Click_LoginFail_Count];
//        [self showTips:@"绑定失败，请检查网络状况"];
//    }];
}


- (void)showTextOnly:(NSString *)str {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_cidTextField resignFirstResponder];
}

-(void)setUpUserCarId : (NSString *)cardId
{
    _cidTextField.text = cardId;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
