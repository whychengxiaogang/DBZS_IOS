//
//  MainViewController.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "mainViewController.h"
#import "MainPlatformView.h"
#import "GoodsListViewController.h"

#define NAV_TITLE_WIDTH         93.0f
#define NAV_TITLE_HEIGHT        24.0f
#define NAV_HELP_WIDTH          20.5f
#define NAV_HELP_HEIGHT         20.5f

@interface MainViewController () <MainPlatformViewDelegate>

@property (nonatomic, strong) UIScrollView *platContentView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavTitle];
    [self initNavRightButton];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavTitle
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, NAV_TITLE_WIDTH, NAV_TITLE_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"main_nav_title"];
    self.navigationItem.titleView = imageView;
}

- (void)initNavRightButton
{
    UIButton *helpButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAV_HELP_WIDTH, NAV_HELP_HEIGHT)];
    [helpButton addTarget:self action:@selector(helpButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setImage:[UIImage imageNamed:@"main_nav_help"] forState:UIControlStateNormal];
    [helpButton setImage:[UIImage imageNamed:@"main_nav_help"] forState:UIControlStateHighlighted];
    UIBarButtonItem *helpItem = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    NSArray *rigtItems = [NSArray arrayWithObjects: helpItem, nil];
    self.navigationItem.rightBarButtonItems = rigtItems;
}

- (void)initViews
{
    self.platContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64.0f, SH_SCREEN_WIDTH, SH_SCREEN_HEIGHT_NO_NAV)];
    self.platContentView.contentSize = CGSizeMake(SH_SCREEN_WIDTH, [MainPlatformView calcHeight]*2);
    self.platContentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.platContentView];
    [self initPlatforms];
}

- (void)initPlatforms
{
    MainPlatformView *netEase = [[MainPlatformView alloc] init];
    netEase.delegate = self;
    [netEase configData: PLATFORM_TYPE_NETEASE];
    [self.platContentView addSubview:netEase];
    
    MainPlatformView *yungou = [[MainPlatformView alloc] init];
    yungou.delegate = self;
    [yungou configData: PLATFORM_TYPE_YUNGOU];
    CGRect yungouFrame = yungou.frame;
    yungouFrame.origin.y = CGRectGetMaxY(netEase.frame);
    yungou.frame = yungouFrame;
    [self.platContentView addSubview:yungou];
}

#pragma mark private

- (void)helpButtonTaped:(id)sender
{
    
}

#pragma mark MainPlatformViewDelegate

- (void)tabButtonTaped:(PLATFORM_TYPE)platformType
{
    if (platformType == PLATFORM_TYPE_YUNGOU) {
        [SVProgressHUD showInfoWithStatus:@"即将开放"];
        return;
    }
    [DBZSUserManager shareInstance].currentPlatform = platformType;
    GoodsListViewController *viewController = [[GoodsListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
