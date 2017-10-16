//
//  JPTabBarController.m
//  StudyTour
//
//  Created by use on 15/12/7.
//  Copyright © 2015年 魏鹏. All rights reserved.
//

#import "JPTabBarController.h"
#import "InstructionViewController.h"
#import "TaskViewController.h"
#import "DynamicViewController.h"
#import "MessageViewController.h"
#import "TabInfoModel.h"

@interface JPTabBarController ()

@property (nonatomic, copy) NSArray *tabArr;

@end

@implementation JPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (TabInfoModel *model in self.tabArr) {
        if (!model.needLoad) {
            continue;
        }
        
        Class myClass = NSClassFromString(model.controller);
        RootViewController *vc = [[myClass alloc] init];
        [self setItemWithController:vc title:model.title imageName:model.image selectedImageName:model.image_sel];
    }
    
    self.tabBar.barTintColor = [UIColor tabBarBackgroundColor];
    self.selectedIndex = 1;
}

- (void)setItemWithController:(UIViewController *)controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    controller.navigationItem.title = title;
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.view.backgroundColor = [UIColor whiteColor];
    //    controller.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    NSDictionary * attributes = @{NSForegroundColorAttributeName:[UIColor themeColor]};
    [controller.tabBarItem setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    RootNavigationController * nav = [[RootNavigationController alloc] initWithRootViewController:controller];
    
    [self addChildViewController:nav];
}

- (NSArray *)tabArr
{
    NSString *configFile = [[NSBundle mainBundle] pathForResource:@"TabBarConfig" ofType:@"plist"];
    NSArray *pageConfigs = [NSArray arrayWithContentsOfFile:configFile];
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    
    if (pageConfigs.count <= 0) {
        NSLog(@"没有配置TabBarConfig.plist");
    }
    
    for (NSDictionary *dict in pageConfigs) {
        TabInfoModel *model = [[TabInfoModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [pages addObject:model];
    }
    return [pages copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
