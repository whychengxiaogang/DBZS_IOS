//
//  LoginViewController.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/13.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "LoginViewController.h"

#define CLOSEBUTTON_HEIGHT              17.0f
#define CLOSEBUTTON_WIDTH               17.0f
#define CLOSEBUTTON_MARGIN_TOP          60.0f
#define CLOSEBUTTON_MARIN_RIGHT         35.0f
#define LOGOVIEW_MARGIN_TOP             25.0f
#define LOGOVIEW_HEIGHT                 145.0f
#define LOGOIMAGEVIEW_WIDTH             122.0f
#define LOGOIMAGEVIEW_HEIGHT            122.0f
#define TITLELABEL_MARGIN_TOP           20.0f
#define SUBMITVIEW_MARGIN_TOP           50.0f
#define SUBMITVIEW_MARGIN_LEFT          50.0f
#define ACCOUNTFEILD_HEIGHT             22.0f
#define FEILDICON_ICON_WIDTH            16.0f
#define FEILDICON_ICON_HEIGHT           18.0f
#define PASSWORDFEILD_MARGIN_TOP        30.0f
#define SUBMITBUTTON_HEIGHT             45.0f
#define SUBMITBUTTON_MARGIN_TOP         25.0f
#define SUBTITLELABEL_MARGIN_TOP        25.0f
#define LINE_MARGIN_TOP                 8.0f
#define PLACEHOLDER_MARIN_LEFT          12.0f

@interface LoginViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *paneScrollView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *closeImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *logoView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIView *accountLine;
@property (nonatomic, strong) UIView *passwordLine;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *submitView;

@end

@implementation LoginViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DBZSNotificationNetEaseLogoinSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DBZSNotificationNetEaseLogoinFai object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    [self initNotification];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)initViews
{
    self.view.backgroundColor = FMColorWithRGB0X(0xf5f5f5);
    [self initPaneScrollView];
    [self initLogoView];
    [self initSubmitView];
    [self initNavClose];
    [self layoutPaneScrollView];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:recognizer];
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netEaseLogoinSuccess:) name:DBZSNotificationNetEaseLogoinSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netEaseLogoinFail:) name:DBZSNotificationNetEaseLogoinFai object:nil];
}

- (void)initPaneScrollView
{
    self.paneScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SH_SCREEN_WIDTH, SH_SCREEN_HEIGHT)];
    self.paneScrollView.delegate = self;
    [self.view addSubview:self.paneScrollView];
}

- (void)initNavClose
{
    self.closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SH_SCREEN_WIDTH - CLOSEBUTTON_MARIN_RIGHT - CLOSEBUTTON_WIDTH, CLOSEBUTTON_MARGIN_TOP, CLOSEBUTTON_WIDTH, CLOSEBUTTON_HEIGHT)];
    self.closeImageView.image = [UIImage imageNamed:@"nav_close"];
    [self.paneScrollView addSubview:self.closeImageView];
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CLOSEBUTTON_WIDTH*4, CLOSEBUTTON_HEIGHT*3)];
    self.closeButton.center = self.closeImageView.center;
    [self.closeButton addTarget:self action:@selector(closeButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self.paneScrollView addSubview:self.closeButton];
}

- (void)initLogoView
{
    self.logoView = [[UIView alloc] init];
    [self.paneScrollView addSubview:self.logoView];
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SH_SCREEN_WIDTH - LOGOIMAGEVIEW_WIDTH)/2.0, 0, LOGOIMAGEVIEW_WIDTH, LOGOIMAGEVIEW_HEIGHT)];
    self.logoImageView.image = [self imagePlatform];
    [self.logoView addSubview:self.logoImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.titleLabel.textColor = UIColorFromRGB(0xea264e);
    self.titleLabel.text = [self titlePlatform];
    [self.logoView addSubview:self.titleLabel];
    [self.titleLabel sizeToFit];
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.y = LOGOIMAGEVIEW_HEIGHT + TITLELABEL_MARGIN_TOP;
    titleFrame.origin.x = (SH_SCREEN_WIDTH - titleFrame.size.width)/2.0;
    self.titleLabel.frame = titleFrame;
    
    CGRect logoViewFrame = self.logoView.frame;
    logoViewFrame.size.width = SH_SCREEN_WIDTH;
    logoViewFrame.size.height = CGRectGetMaxY(self.titleLabel.frame);
    logoViewFrame.origin.y = LOGOVIEW_MARGIN_TOP + 40.0f;
    self.logoView.frame = logoViewFrame;
}

- (void)initSubmitView
{
    CGFloat submitWidth = SH_SCREEN_WIDTH - SUBMITVIEW_MARGIN_LEFT*2;
    self.submitView = [[UIView alloc] init];
    [self.paneScrollView addSubview:self.submitView];
    
    self.accountField = [self textField:[self iconName:@"login_mail"] placeholder:@"请输入电子邮箱"];
    CGRect emailFrame =self.accountField.frame;
    emailFrame.size.width =  submitWidth;
    emailFrame.size.height = ACCOUNTFEILD_HEIGHT;
    self.accountField.frame = emailFrame;
    [self.submitView addSubview:self.accountField];

    self.accountLine = [self lineView:CGRectGetMaxY(self.accountField.frame) + LINE_MARGIN_TOP];
    [self.submitView addSubview:self.accountLine];
    
    self.passwordField = [self textField:[self iconName:@"login_password"] placeholder:@"请输入密码"];
    self.passwordField.secureTextEntry = YES;
    [self.submitView addSubview:self.passwordField];
    CGRect passwordFieldFrame = self.accountField.frame;
    passwordFieldFrame.origin.y = CGRectGetMaxY(self.accountField.frame) + PASSWORDFEILD_MARGIN_TOP;
    self.passwordField.frame = passwordFieldFrame;
    
    self.passwordLine = [self lineView:CGRectGetMaxY(self.passwordField.frame) + LINE_MARGIN_TOP];
    [self.submitView addSubview:self.passwordLine];
    
    self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.passwordLine.frame) + SUBMITBUTTON_MARGIN_TOP, submitWidth, SUBMITBUTTON_HEIGHT)];
    self.submitButton.layer.cornerRadius = 5.0f;
    self.submitButton.clipsToBounds = YES;
    self.submitButton.backgroundColor = FMColorWithRGB0X(0xf04848);
    [self.submitButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submitButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self.submitView addSubview:self.submitButton];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.subTitleLabel.textColor = UIColorFromRGB(0x999999);
    self.subTitleLabel.text = @"夺宝战神不会记录您的帐号和密码，请放心使用";
    [self.subTitleLabel sizeToFit];
    CGRect subTitleFrame = self.subTitleLabel.frame;
    subTitleFrame.origin.y = CGRectGetMaxY(self.submitButton.frame) + SUBTITLELABEL_MARGIN_TOP;
    subTitleFrame.origin.x = (submitWidth - subTitleFrame.size.width)/2.0;
    self.subTitleLabel.frame = subTitleFrame;
    [self.submitView addSubview:self.subTitleLabel];

    CGRect submitViewFrame = self.submitView.frame;
    submitViewFrame.size.width = submitWidth;
    submitViewFrame.size.height = CGRectGetMaxY(self.subTitleLabel.frame);
    submitViewFrame.origin.y = CGRectGetMaxY(self.logoView.frame) + SUBMITVIEW_MARGIN_TOP;
    submitViewFrame.origin.x = SUBMITVIEW_MARGIN_LEFT;
    self.submitView.frame = submitViewFrame;
    
    if ([DBZSUserManager shareInstance].currentUser.accountName.length > 0) {
        self.accountField.text =[DBZSUserManager shareInstance].currentUser.accountName;
    }
    if ([DBZSUserManager shareInstance].currentUser.password.length > 0) {
        self.passwordField.text =[DBZSUserManager shareInstance].currentUser.password;
    }
}

- (UIImageView *)iconName:(NSString *)name
{
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FEILDICON_ICON_WIDTH, FEILDICON_ICON_HEIGHT)];
    icon.image = [UIImage imageNamed:name];
    return icon;
}

- (UITextField *)textField:(UIImageView *)icon placeholder:(NSString *)placeholder
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FEILDICON_ICON_WIDTH + PLACEHOLDER_MARIN_LEFT, ACCOUNTFEILD_HEIGHT)];
    [leftView addSubview:icon];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.leftView = leftView;
    textField.placeholder = placeholder;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeyDone;
    [textField setFont:[UIFont systemFontOfSize:16.0]];
    [textField setTextColor:FMColorWithRGB0X(0x333333)];
    return textField;
}

- (UIView *)lineView:(CGFloat)yOffset
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, SH_SCREEN_WIDTH - SUBMITVIEW_MARGIN_LEFT*2, 1.0f)];
    line.backgroundColor = FMColorWithRGB0X(0xdddddd);
    return line;
}

- (NSString *)titlePlatform
{
    if ([DBZSUserManager shareInstance].currentPlatform == PLATFORM_TYPE_NETEASE) {
        return @"请用一元夺宝帐号登录下单";
    }
    return @"请用一元云购帐号登录下单";
}

- (UIImage *)imagePlatform
{
    if ([DBZSUserManager shareInstance].currentPlatform == PLATFORM_TYPE_NETEASE) {
        return [UIImage imageNamed:@"163_logo"];
    }
    return[UIImage imageNamed:@"1yuan_logo"];
}

- (void)layoutPaneScrollView
{
    self.paneScrollView.contentSize = CGSizeMake(SH_SCREEN_WIDTH, CGRectGetMaxY(self.submitView.frame));
}

#pragma mark private

- (void)closeButtonTap
{
    [self hideKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitButtonTap
{
    NSString *password = [self.passwordField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *account = [self.accountField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (account.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输人登录帐号"];
        return;
    }
    
    if (password.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输人密码"];
        return;
    }

    if ([DBZSUserManager shareInstance].currentPlatform == PLATFORM_TYPE_NETEASE) {
        [SVProgressHUD showWithStatus:nil];
        [DBZSNetEaseService loginWithPass:password account:account];
        return;
    }
    if ([DBZSUserManager shareInstance].currentPlatform == PLATFORM_TYPE_NETEASE) {
        
        return;
    }
}

-(void)hideKeyboard
{
    [self.accountField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark UITextFieldDelegate

-( void )textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, -100.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

-( void )textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@ "ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.accountField.text.length > 0 || self.passwordField.text.length > 0) {
        [self submitButtonTap];
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

#pragma mark notification

- (void)netEaseLogoinSuccess:(NSNotification*)notification
{
    [SVProgressHUD dismiss];
    [self closeButtonTap];
}

- (void)netEaseLogoinFail:(NSNotification*)notification
{
    [SVProgressHUD showErrorWithStatus:@"登录失败！"];
}

@end
