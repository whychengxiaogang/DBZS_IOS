//
//  GoodsDetailViewController.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/10.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "DetailGoodsInfoViewCell.h"
#import "DetailWinnersViewCell.h"
#import "DetailChartViewCell.h"
#import "DetailMakeOrderView.h"
#import "DetailWinnersHeaderViewCell.h"
#import "LandscapeRightView.h"
#import "DetailTabbarView.h"
#import "LoadMoreFootView.h"
#import "EndFootView.h"
#import "DetailBottomBarView.h"
#import "LoginViewController.h"
#import "SearchViewController.h"
#import "NSDate+Helper.h"
#import "NSString+Additions.h"
#import "OrderConfirmView.h"

#define NAV_SEARCH_WIDTH          18.0f
#define NAV_SEARCH_HEIGHT         18.0f
#define BOTTOM_BAR_HEIGHT         46.0f

static NSString *detailGoodsInfoViewCellIdentifier=@"detailGoodsInfoViewCellIdentifier";
static NSString *detailWinnersViewCellIdentifier=@"detailWinnersViewCellIdentifier";
static NSString *detailChartViewCellIdentifier=@"detailChartViewCellIdentifier";
static NSString *detailWinnersHeaderViewCellIdentifier=@"detailWinnersHeaderViewCellIdentifier";

@interface GoodsDetailViewController () <UITableViewDataSource, UITableViewDelegate, DetailChartViewCellDelegate, DetailTabbarViewDelegate, DetailBottomBarViewDelegate, UIScrollViewDelegate, OrderConfirmViewDelegate>

@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) NSArray *winnerList;
@property (nonatomic, strong) DBZSNowModel *now;
@property (nonatomic, strong) DBZSProductModel *product;
@property (nonatomic, assign) BOOL isRightShow;
@property (nonatomic, strong) LandscapeRightView *landscapeRightView;
@property (nonatomic, strong) DetailTabbarView *detailTabbarView;
@property (nonatomic, assign) int currentRegion;
@property (nonatomic, strong) NSMutableArray *showWinnerList;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) LoadMoreFootView *moreFootView;
@property (nonatomic, strong) EndFootView *endFootView;
@property (nonatomic, strong) DetailBottomBarView *detailBottomBarView;
@property (nonatomic, strong) NSDictionary *regionData;
@property (nonatomic, strong) NSURLSession *udpateSession;
@property (nonatomic, assign) BOOL isLoop;
@property (nonatomic, strong) OrderConfirmView *orderConfirmView;
@property (nonatomic, assign) int failTimes;
@property (nonatomic, strong) NSString *timeIdRefresh;

@end

@implementation GoodsDetailViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DBZSNotificationNetEaseLogoinSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DBZSNotificationNetEaseGetMoney object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DBZSNotificationNetEasePaysuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DBZSNotificationNetEasePayFail object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DBZSNotificationNetEaseLogoOut object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackNav];
    [self initNavRightButton];
    [self configNavigationBarTitle:[self navTitlePre:@"商品详情"]];
    [self initNotification];
    [self initViews];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isLoop = YES;
    if (self.product && self.now) {
        [self LoopUpdate];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isLoop = NO;
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netEaseLogoinSuccess:) name:DBZSNotificationNetEaseLogoinSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netEaseGetMoney:) name:DBZSNotificationNetEaseGetMoney object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Paysuccess:) name:DBZSNotificationNetEasePaysuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PayFail:) name:DBZSNotificationNetEasePayFail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LogoOut:) name:DBZSNotificationNetEaseLogoOut object:nil];
}

-(void)pageBack:(id)sender
{
    if (self.isRightShow) {
        self.isRightShow = NO;
        [self showHome];
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        return;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initNavRightButton
{
    UIBarButtonItem *scanSpacer = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    scanSpacer.width = 5.0f;
    UIButton *searchButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAV_SEARCH_WIDTH, NAV_SEARCH_HEIGHT)];
    [searchButton addTarget:self action:@selector(searchButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateHighlighted];
    UIBarButtonItem *helpItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    NSArray *rigtItems = [NSArray arrayWithObjects: scanSpacer, helpItem, nil];
    self.navigationItem.rightBarButtonItems = rigtItems;
}

- (void)initNavOrientation
{
    self.detailTabbarView = [[DetailTabbarView alloc] init];
    [self.detailTabbarView showRegion:self.currentRegion];
    self.detailTabbarView.delegate = self;
    self.navigationItem.titleView = self.detailTabbarView;
    self.navigationItem.rightBarButtonItems = nil;
}

- (void)initViews
{
    [self initTabelView];
    [self initFootView];
    [self initLandscapeRightView];
    [self initDetailBottomBarView];
    [self initOrderConfirmView];
}

- (void)initTabelView
{
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64.0f, SH_SCREEN_WIDTH, SH_SCREEN_HEIGHT_NO_NAV - BOTTOM_BAR_HEIGHT)];
    self.detailTableView.dataSource = self;
    self.detailTableView.delegate = self;
    self.detailTableView.showsVerticalScrollIndicator = NO;
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.backgroundColor = FMColorWithRGB0X(0xf5f5f5);
    self.detailTableView.bounces = NO;
    [self.view addSubview:self.detailTableView];
    
    [self.detailTableView registerClass:[DetailGoodsInfoViewCell class] forCellReuseIdentifier:detailGoodsInfoViewCellIdentifier];
    [self.detailTableView registerClass:[DetailChartViewCell class] forCellReuseIdentifier:detailChartViewCellIdentifier];
    [self.detailTableView registerClass:[DetailWinnersViewCell class] forCellReuseIdentifier:detailWinnersViewCellIdentifier];
    [self.detailTableView registerClass:[DetailWinnersHeaderViewCell class] forCellReuseIdentifier:detailWinnersHeaderViewCellIdentifier];
}

- (void)initFootView
{
    self.moreFootView = [[LoadMoreFootView alloc] init];
    self.endFootView = [[EndFootView alloc] init];
}

- (void)initLandscapeRightView
{
    self.landscapeRightView = [[LandscapeRightView alloc] initWithFrame:CGRectMake(0, 0, SH_SCREEN_HEIGHT, SH_SCREEN_WIDTH)];
    self.landscapeRightView.hidden = YES;
    [self.view addSubview:self.landscapeRightView];
}

- (void)initDetailBottomBarView
{
    self.detailBottomBarView = [[DetailBottomBarView alloc] initWithFrame:CGRectMake(0, SH_SCREEN_HEIGHT - BOTTOM_BAR_HEIGHT, SH_SCREEN_WIDTH, BOTTOM_BAR_HEIGHT)];
    self.detailBottomBarView.delegate = self;
    [self.view addSubview:self.detailBottomBarView];
    [self.detailBottomBarView showLogin];
    if ([DBZSUserManager shareInstance].currentUser.loginSuccess) {
        [self.detailBottomBarView showAccountInfo];
    }
}

- (void)initOrderConfirmView
{
    self.orderConfirmView = [[OrderConfirmView alloc] initWithFrame:CGRectMake(0, 0, SH_SCREEN_WIDTH, SH_SCREEN_HEIGHT)];
    self.orderConfirmView.delegate = self;
}

- (void)refreshData
{
    [DBZSService detailPostsWithBlock:self.productId block:^(DBZSProductModel *product, DBZSNowModel *now, NSArray *posts, NSError *error) {
        for (DBZSWinnerModel *model in posts) {
            if (self.timeIdRefresh && self.timeIdRefresh.length > 0 && self.now.time_id!=self.timeIdRefresh && [model.time_id isEqualToString:self.now.time_id]) {
                if (model.rank == 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self refreshData];
                    });
                    return ;
                }
            }
        }
        self.product = product;
        self.winnerList  = posts;
        self.now = now;
        self.isLoop = YES;
        [DBZSUserManager shareInstance].currentNow = now;
        self.showWinnerList = [[NSMutableArray alloc] init];
        for (int i=0; i<(MIN(self.winnerList.count, 10)); i++) {
            [self.showWinnerList addObject:[self.winnerList objectAtIndex:i]];
        }
        [self.detailTableView reloadData];
        [self performSelector:@selector(LoopUpdate) withObject:nil afterDelay:2.0f];
    }];
    
    [DBZSService regionPostsWithBlock:self.productId block:^(NSDictionary *posts, NSError *error) {
        self.regionData = posts;
        [self.detailTableView reloadData];
    }];
}

- (void)loadMoreWinner
{
    if (self.showWinnerList.count == self.winnerList.count) {
        self.detailTableView.tableFooterView = self.endFootView;
        return;
    }
    self.detailTableView.tableFooterView = self.moreFootView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int k = 0;
        for (NSInteger i=self.showWinnerList.count; i<self.winnerList.count; i++) {
            [self.showWinnerList addObject:[self.winnerList objectAtIndex:i]];
            k++;
            if (k == 10) {
                self.isRefresh = NO;
                self.detailTableView.tableFooterView = nil;
                [self.detailTableView reloadData];
                return;
            }
        }
    });
}

- (void)LoopUpdate
{
    if ([DBZSUserManager shareInstance].currentPlatform == PLATFORM_TYPE_NETEASE) {
        [self netEaseUpdate];
        return;
    }
    if ([DBZSUserManager shareInstance].currentPlatform == PLATFORM_TYPE_NETEASE) {
        [self yunGouUpdate];
        return;
    }
}

- (void)netEaseUpdate
{
    if (!self.udpateSession) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.udpateSession = [NSURLSession sessionWithConfiguration:config];
    }
    NSString *urlStr = [NSString stringWithFormat:@"http://m.1.163.com/detail/%d.html&t=%@", self.productId, [NSDate timeString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"GET";
    [request setTimeoutInterval:3];
    [request setValue:@"m.1.163.com" forHTTPHeaderField:@"Host"];
    [request setValue:@"http://1.163.com/" forHTTPHeaderField:@"Referer"];
    NSURLSessionTask *task = [self.udpateSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *period = [NSString regularExpressionSearch:htmlStr rangeOfString:@"period : [0-9]+" rangeOfStringSub:@"period :"];
        if (period && period.length > 0 && ![self.now.time_id isEqualToString:period]) {
            self.timeIdRefresh = period;
            self.isLoop = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshData];
            });
        }
        int remain_times = [[NSString regularExpressionSearch:htmlStr rangeOfString:@"remainTimes : [0-9]+" rangeOfStringSub:@"remainTimes :"] intValue];
        int join_times = [[NSString regularExpressionSearch:htmlStr rangeOfString:@"existingTimes : [0-9]+" rangeOfStringSub:@"existingTimes :"] intValue];
        int total_times = remain_times + join_times;
        if (remain_times > 0 && join_times > 0) {
            self.now.remain_times = remain_times;
            self.now.join_times = join_times;
            self.now.total_times = total_times;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            DetailGoodsInfoViewCell *cell = [self.detailTableView cellForRowAtIndexPath:indexPath];
            [cell updateCell:self.now];
            if (self.isLoop) {
                [self LoopUpdate];
            }
        });
        return;
    }];
    [task resume];
}

- (void)yunGouUpdate
{
    
}

#pragma mark private

- (void)searchButtonTaped:(id)sender
{
    SearchViewController *viewController= [[SearchViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showHome
{
    self.navigationItem.titleView = nil;
    [self configNavigationBarTitle:[self navTitlePre:@"商品详情"]];
    [self initNavRightButton];
    self.landscapeRightView.hidden = YES;
    self.detailTableView.hidden = NO;
    self.detailBottomBarView.hidden = NO;
}

- (void)showOrientation
{
    [self initNavOrientation];
    self.landscapeRightView.hidden = NO;
    [self.landscapeRightView configData:self.winnerList];
    [self.landscapeRightView showRegion:self.currentRegion];
    self.detailTableView.hidden = YES;
    self.detailBottomBarView.hidden = YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.showWinnerList.count + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DetailGoodsInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailGoodsInfoViewCellIdentifier];
        [cell configData:self.product now:self.now];
        return cell;
    }
    if (indexPath.section == 1) {
        DetailChartViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailChartViewCellIdentifier];
        cell.delegate = self;
        [cell configData:self.winnerList regionData:self.regionData];
        return cell;
    }
    if (indexPath.row == 0) {
        DetailWinnersHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailWinnersHeaderViewCellIdentifier];
        return cell;
    }
    DetailWinnersViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailWinnersViewCellIdentifier];
    [cell configData:[self.showWinnerList objectAtIndex:(indexPath.row - 1)]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [DetailGoodsInfoViewCell calCellHeight];
    }
    if (indexPath.section == 1) {
        return [DetailChartViewCell calCellHeight];
    }
    if (indexPath.row == 0) {
        return [DetailWinnersHeaderViewCell calCellHeight];
    }
    return [DetailWinnersViewCell calCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    return  10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark DetailChartViewCellDelegate

- (void)changeInterfaceOrientatio:(int)region
{
    self.currentRegion = region;
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)showRegionView
{
    
}

#pragma mark Autorotation support

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        if (orientation == UIInterfaceOrientationLandscapeRight) {
            self.isRightShow = YES;
            [self showOrientation];
        }
    }
}

#pragma mark DetailTabbarViewDelegate

- (void)tabbarTab:(int)region
{
    [self.landscapeRightView showRegion:region];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!self.isRefresh) {
        self.isRefresh = YES;
        [self loadMoreWinner];
    }
}

#pragma mark DetailBottomBarViewDelegate

- (void)loginButtonTab
{
   LoginViewController *viewController = [[LoginViewController alloc] init];
   [self presentViewController:viewController animated:YES completion:nil];
}

- (void)orderButtonTab
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.orderConfirmView];
    [self.orderConfirmView configData:1];
    return;
}

#pragma mark OrderConfirmViewDelegate

- (void)orderSubmit:(int)buyNum
{
    [SVProgressHUD showProgress:1];
    if ([DBZSUserManager shareInstance].currentPlatform == PLATFORM_TYPE_NETEASE) {
        [DBZSUserManager shareInstance].currentUser.buynum = buyNum;
        [DBZSNetEaseService buy];
    }
}

#pragma mark notification

- (void)netEaseLogoinSuccess:(NSNotification*)notification
{
    [self.detailBottomBarView showAccountInfo];
}

- (void)netEaseGetMoney:(NSNotification*)notification
{
   [self.detailBottomBarView showAccountInfo];
}

- (void)Paysuccess:(NSNotification*)notification
{
    [self.orderConfirmView removeFromSuperview];
    [SVProgressHUD dismiss];
    [DBZSNetEaseService getmoney];
}

- (void)PayFail:(NSNotification*)notification
{
    self.failTimes ++;
    if (self.failTimes > 3) {
        [DBZSNetEaseService login];
    }
}

- (void)LogoOut:(NSNotification*)notification
{
    [SVProgressHUD dismiss];
    [self.detailBottomBarView showLogin];
    [self.orderConfirmView removeFromSuperview];
}

@end
