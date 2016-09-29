//
//  GoodsListViewController.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/17.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "GoodsListViewController.h"
#import "SearchPlaceholderView.h"
#import "SearchGoodsViewCell.h"
#import "GoodsDetailViewController.h"
#import "GoodsListView.h"

#define TEXTFILED_MARGIN_LEFT               27.0f
#define TEXTFILED_MARGIN_TOP                20.0f
#define TEXTPANE_WIDTH_TABLE_BOTTOM         20.0f
#define TEXTFILED_WIDTH                     27.0f
#define TEXTFILED_HEIGHT                    35.0
#define TEXTFILED_SPACE                     5.0f
#define PLACEHODLER_MARGIN_LEFT             15.0f

static NSString *searchGoodsViewCellIdentifier=@"searchGoodsViewCellIdentifier";

@interface GoodsListViewController () <UITextFieldDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, GoodsListViewViewDelegate, SearchGoodsViewCellDelegate>

@property (nonatomic, strong) UIView *textPane;
@property (nonatomic, strong) UITextField *searchTextFiled;
@property (nonatomic, assign) CGFloat placeholderMaxLeft;
@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) SearchPlaceholderView *searchPlaceholderView;
@property (nonatomic, strong) GoodsListView *goodsListView;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) NSArray *resultData;
@end

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showBackNav];
    [self configNavigationBarTitle:[self navTitlePre:@"搜索"]];
    [self initViews];
    [self configNotification];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchTextFiled];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.goodsListView reloadSearchKeyWord];
}

- (void)initViews
{
    [self initSearchTextFiled];
    [self initGoodsListView];
    [self initsearchTableView];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:recognizer];
}

- (void)refreshData
{
    [DBZSService hotPostsWithBlock:^(NSArray *posts, NSError *error) {
        [self.goodsListView configHotData:posts];
    }];
    [DBZSService getNewPostsWithBlock:^(NSArray *posts, NSError *error) {
        [self.goodsListView configLastNewData:posts];
    }];
}

- (void)initSearchTextFiled {
    self.textPane = [[UIView alloc] init];
    self.textPane.backgroundColor = [UIColor whiteColor];
    self.searchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(TEXTFILED_MARGIN_LEFT, TEXTFILED_MARGIN_TOP, SH_SCREEN_WIDTH - TEXTFILED_MARGIN_LEFT*2, TEXTFILED_HEIGHT)];
    self.searchTextFiled.delegate =self;
    self.searchTextFiled.layer.cornerRadius = TEXTFILED_HEIGHT/2.0;
    self.searchTextFiled.backgroundColor = FMColorWithRGB0X(0xf3f3f3);
    self.searchTextFiled.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [SearchPlaceholderView iconAndSpaceWidth] + PLACEHODLER_MARGIN_LEFT, 0)];
    self.searchTextFiled.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextFiled.returnKeyType = UIReturnKeySearch;
    [self.searchTextFiled setFont:[UIFont systemFontOfSize:15.0]];
    [self.textPane addSubview:self.searchTextFiled];
    
    self.textPane.frame = CGRectMake(0, 64, SH_SCREEN_WIDTH, TEXTFILED_HEIGHT + TEXTFILED_MARGIN_TOP);
    [self.view addSubview:self.textPane];
    
    self.searchPlaceholderView = [[SearchPlaceholderView alloc] init];
    [self.searchTextFiled addSubview:self.searchPlaceholderView];
    self.placeholderMaxLeft = (self.searchTextFiled.frame.size.width - self.searchPlaceholderView.frame.size.width)/2.0 - 10.0f;
    [self checkPlaceHolder];
}

- (void)initGoodsListView
{
    self.goodsListView = [[GoodsListView alloc] initWithFrame:CGRectMake(0, 64 + TEXTFILED_HEIGHT + TEXTFILED_MARGIN_TOP, SH_SCREEN_WIDTH, SH_SCREEN_HEIGHT_NO_NAV -TEXTFILED_HEIGHT - TEXTFILED_MARGIN_TOP)];
    self.goodsListView.delegate = self;
    [self.view addSubview:self.goodsListView];
}

- (CGFloat)calcPlaceholderWidth:(NSString *)placeholder
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attributeStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:15.0]
                         range:NSMakeRange(0, attributeStr.length)];
    CGFloat placeholderWidth = [attributeStr boundingRectWithSize:CGSizeMake(SH_SCREEN_WIDTH, 40)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                          context:nil].size.width;
    return placeholderWidth;
}

- (void)showCenterPlaceHolder
{
    [self.searchPlaceholderView showText];
    CGRect placeholderFrame = self.searchPlaceholderView.frame;
    placeholderFrame.origin.x = self.placeholderMaxLeft;
    placeholderFrame.origin.y = (TEXTFILED_HEIGHT - placeholderFrame.size.height)/2.0;
    self.searchPlaceholderView.frame = placeholderFrame;
}

- (void)showLightOlnyIconPlaceHolder
{
    [self.searchPlaceholderView showIconOnly];
    CGRect placeholderFrame = self.searchPlaceholderView.frame;
    placeholderFrame.origin.x = PLACEHODLER_MARGIN_LEFT;
    placeholderFrame.origin.y = (TEXTFILED_HEIGHT - placeholderFrame.size.height)/2.0;
    self.searchPlaceholderView.frame = placeholderFrame;
}

- (void)showLightPlaceHolder
{
    [self.searchPlaceholderView showText];
    CGRect placeholderFrame = self.searchPlaceholderView.frame;
    placeholderFrame.origin.x = PLACEHODLER_MARGIN_LEFT;
    placeholderFrame.origin.y = (TEXTFILED_HEIGHT - placeholderFrame.size.height)/2.0;
    self.searchPlaceholderView.frame = placeholderFrame;
}

- (void)showgoodsListView
{
    CGRect textFrame = self.textPane.frame;
    textFrame.size.height = TEXTFILED_HEIGHT + TEXTFILED_MARGIN_TOP;
    self.textPane.frame = textFrame;
    self.goodsListView.hidden = NO;
    self.searchTableView.hidden = YES;
}

- (void)showsearchTableView
{
    CGRect textFrame = self.textPane.frame;
    textFrame.size.height = TEXTFILED_HEIGHT + TEXTFILED_MARGIN_TOP + TEXTPANE_WIDTH_TABLE_BOTTOM;
    self.textPane.frame = textFrame;
    self.goodsListView.hidden = YES;
    self.searchTableView.hidden = NO;
}

- (void)checkPlaceHolder
{
    if (![self.searchTextFiled isFirstResponder]) {
        if (self.searchTextFiled.text.length == 0) {
            [self showgoodsListView];
        }else{
            [self showsearchTableView];
        }
    }else
    {
        if (self.searchTextFiled.text.length == 0) {
            [self showgoodsListView];
        }else{
            [self showsearchTableView];
        };
    }
    
    if (self.searchTextFiled.text.length == 0) {
        if ([self.searchTextFiled isFirstResponder]) {
            [self showLightPlaceHolder];
            return;
        }
        [self showCenterPlaceHolder];
    }
    else
    {
        [self showLightOlnyIconPlaceHolder];
    }
}

-(void)hideKeyboard
{
    if (self.searchTableView.hidden) {
        [self.searchTextFiled resignFirstResponder];
        [self checkPlaceHolder];
    }
}

#pragma mark tableView

- (void)initsearchTableView
{
    CGFloat marginTop = TEXTFILED_HEIGHT + TEXTFILED_MARGIN_TOP + TEXTPANE_WIDTH_TABLE_BOTTOM;
    self.searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, marginTop + 64, SH_SCREEN_WIDTH, SH_SCREEN_HEIGHT_NO_NAV - marginTop)];
    self.searchTableView.dataSource = self;
    self.searchTableView.delegate = self;
    self.searchTableView.showsVerticalScrollIndicator = NO;
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchTableView.hidden = YES;
    [self.view addSubview:self.searchTableView];
    
    [self.searchTableView registerClass:[SearchGoodsViewCell class] forCellReuseIdentifier:searchGoodsViewCellIdentifier];
}

#pragma mark Notification

-(void)configNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:self.searchTextFiled];
}

#pragma mark start search

- (void)searchTextFieldDidChangeValue:(id)sender
{
    [self checkPlaceHolder];
    
    if (self.searchTextFiled.text.length == 0) {
        self.resultData = nil;
        [self.searchTableView reloadData];
    }
    else{
        [DBZSService keywordPostsWithBlock:self.searchTextFiled.text block:^(NSArray *posts, NSError *error) {
            self.resultData = posts;
            [self.searchTableView reloadData];
        }];
    }
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self checkPlaceHolder];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchTextFiled resignFirstResponder];
    [self checkPlaceHolder];
}

#pragma mark SearchGoodsViewCellDelegate

- (void)goodsTap:(int)productId
{
    [self saveKeywordLocal:SAFE_STRING(self.searchTextFiled.text)];
    [self showGoodsDetail:productId];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchGoodsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchGoodsViewCellIdentifier];
    cell.delegate = self;
    DBZSProductModel *model = [self.resultData objectAtIndex:indexPath.row];
    [cell configData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SearchGoodsViewCell calCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)showGoodsDetail:(int)productId
{
    GoodsDetailViewController *viewController = [[GoodsDetailViewController alloc] init];
    viewController.productId = productId;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)saveKeywordLocal:(NSString *)keyword
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *keywordList = [setting objectForKey:@"dbzs_keywordList"];
    if (!keywordList) {
        [setting setObject:keyword forKey:@"dbzs_keywordList"];
        [setting synchronize];
    }
    else
    {
        if (![self hasKeyword:keywordList keyword:keyword]) {
            NSString *productNameListNew = [NSString stringWithFormat:@"%@,%@",keyword, keywordList];
            [setting setObject:[self maxProductCount:productNameListNew] forKey:@"dbzs_keywordList"];
            [setting synchronize];
        }
    }
}

- (BOOL)hasKeyword:(NSString *)strData keyword:(NSString *)keyword
{
    NSArray *array = [strData componentsSeparatedByString:@","];
    for (NSString *str in array) {
        if ([keyword isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)maxProductCount:(NSString *)strData
{
    NSArray *array = [strData componentsSeparatedByString:@","];
    NSMutableString *arrayStr = [[NSMutableString alloc] init];
    for (int i=0; i < MIN(10, array.count); i++) {
        [arrayStr appendString: [array objectAtIndex:i]];
        [arrayStr appendString: @","];
    }
    return [arrayStr substringToIndex:(arrayStr.length -1)];
}

#pragma mark GoodsListViewViewDelegate

- (void)searchKeyWordTap:(NSString *)keyWord
{
    self.searchTextFiled.text = keyWord;
    [self searchTextFieldDidChangeValue:self.searchTextFiled];
}

- (void)goodsListViewGoodsTap:(int)productId
{
    [self showGoodsDetail:productId];
}

- (void)goodsListViewMove
{
    [self.searchTextFiled resignFirstResponder];
    [self checkPlaceHolder];
}

@end
