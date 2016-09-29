
//
//  DetailBottomBarView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/13.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DetailBottomBarView.h"
#import "UIImage+Helper.h"

#define VIEW_HEIGHT                 46.0f
#define ORDERBUTTON_WIDTH           150.0f
#define ACCOUNTLABEL_MARGIN_LEFT    25.0f

@interface DetailBottomBarView ()

@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIView *line;

@end

@implementation DetailBottomBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.accountLabel = [[UILabel alloc] init];
    self.accountLabel.font = [UIFont systemFontOfSize:12.0f];
    self.accountLabel.textColor = UIColorFromRGB(0x666666);
    [self addSubview:self.accountLabel];
    
    self.orderButton = [[UIButton alloc] initWithFrame:CGRectMake(SH_SCREEN_WIDTH - ORDERBUTTON_WIDTH, 0, ORDERBUTTON_WIDTH, VIEW_HEIGHT)];
    self.orderButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.orderButton setTitle:@"立即下单" forState:UIControlStateNormal];
    [self.orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.orderButton setBackgroundImage:[UIImage createImageWithColor:FMColorWithRGB0X(0xffa414)] forState:UIControlStateNormal];
        [self.orderButton setBackgroundImage:[UIImage createImageWithColor:FMColorWithRGB0X(0xeb9712)] forState:UIControlStateHighlighted];
    [self.orderButton addTarget:self action:@selector(orderButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.orderButton];
    
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SH_SCREEN_WIDTH, VIEW_HEIGHT)];
    [self.loginButton addTarget:self action:@selector(loginButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.hidden = YES;
    [self addSubview:self.loginButton];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SH_SCREEN_WIDTH, 1)];
    self.line.backgroundColor = FMColorWithRGB0X(0xeeeeee);
    [self addSubview:self.line];
}

- (void)orderButtonTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderButtonTab)]) {
        [self.delegate orderButtonTab];
    }
}

- (void)loginButtonTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginButtonTab)]) {
        [self.delegate loginButtonTab];
    }
}

#pragma mark public

- (void)showLogin
{
    self.loginButton.hidden = NO;
    self.accountLabel.text = @"夺宝账号未登录";
    [self.accountLabel sizeToFit];
    CGRect frame = self.accountLabel.frame;
    frame.origin.x = ACCOUNTLABEL_MARGIN_LEFT;
    frame.origin.y = (VIEW_HEIGHT - frame.size.height)/2.0;
    self.accountLabel.frame = frame;
}

- (void)showAccountInfo
{
    self.loginButton.hidden = YES;
    NSString *amount = [NSString stringWithFormat:@"账户余额:¥%.2f", [DBZSUserManager shareInstance].netEaseUser.coinbalance];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:amount];
    [attributeStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:12.0f]
                         range:NSMakeRange(0, amount.length)];
    [attributeStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:13.0f]
                         range:NSMakeRange(5, amount.length - 5)];

    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:FMColorWithRGB0X(0x666666)
                         range:NSMakeRange(0, amount.length)];
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:FMColorWithRGB0X(0xffa414)
                         range:NSMakeRange(5, amount.length - 5)];
    self.accountLabel.attributedText = attributeStr;
    [self.accountLabel sizeToFit];
    CGRect frame = self.accountLabel.frame;
    frame.origin.x = ACCOUNTLABEL_MARGIN_LEFT;
    frame.origin.y = (VIEW_HEIGHT - frame.size.height)/2.0;
    self.accountLabel.frame = frame;
}

@end
