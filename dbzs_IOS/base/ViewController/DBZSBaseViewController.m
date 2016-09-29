//
//  DBZSBaseViewController.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DBZSBaseViewController.h"
#import "UIImage+Helper.h"

@interface DBZSBaseViewController ()

@end

@implementation DBZSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark Nav

- (void)showBackNav
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0.0, 0.0, 10.5, 18);
    [backBtn addTarget:self action:@selector(pageBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftButton, nil];
}

-(void)pageBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)configNavigationBarTitle:(NSString *)aTitle
{
    self.title = aTitle;
}

- (NSString *)navTitlePre:(NSString *)navTitle
{
    NSString *title = @"一元夺宝";
    switch ([DBZSUserManager shareInstance].currentPlatform) {
        case PLATFORM_TYPE_NETEASE:
            title = @"一元夺宝-";
            break;
        case PLATFORM_TYPE_YUNGOU:
            title = @"一元云购-";
            break;
        default:
            break;
    }
    return [title stringByAppendingString:navTitle];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
