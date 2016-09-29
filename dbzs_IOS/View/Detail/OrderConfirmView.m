//
//  OrderConfirmView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/17.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "OrderConfirmView.h"
#import "UIImage+Helper.h"

#define PANEVIE_HEIGHT              175.0f
#define ORDERBUTTON_WIDTH           150.0f

@interface OrderConfirmView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *paneView;
@property (nonatomic, strong) UILabel *useLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, assign) int currentNum;

@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *grayButton;
@property (nonatomic, assign) float price;

@end

@implementation OrderConfirmView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SH_SCREEN_WIDTH, SH_SCREEN_HEIGHT);
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.grayButton = [[UIButton alloc] initWithFrame:self.bounds];
    self.grayButton.backgroundColor = [UIColor blackColor];
    self.grayButton.alpha = 0.5f;
    [self.grayButton addTarget:self action:@selector(closebutton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.grayButton];
    
    self.paneView = [[UIView alloc] initWithFrame:CGRectMake(0, SH_SCREEN_HEIGHT - PANEVIE_HEIGHT, SH_SCREEN_HEIGHT, PANEVIE_HEIGHT)];
    self.paneView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.paneView];

    self.useLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 40.0f)];
    self.useLabel.font = [UIFont systemFontOfSize:14.0f];
    self.useLabel.textColor = UIColorFromRGB(0x333333);
    self.useLabel.text = @"用户";
    [self.paneView addSubview:self.useLabel];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SH_SCREEN_WIDTH - 15 - 200, 10, 200, 40)];
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel.text = [DBZSUserManager shareInstance].currentUser.userName;
    [self.paneView addSubview:self.nameLabel];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 50, SH_SCREEN_WIDTH - 30, 1)];
    self.lineView.backgroundColor = FMColorWithRGB0X(0xf5f5f5);
    [self.paneView addSubview:self.lineView];
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 150.0f, 40)];
    self.countLabel.font = [UIFont systemFontOfSize:14.0f];
    self.countLabel.textColor = UIColorFromRGB(0x333333);
    self.countLabel.text = @"下单数量";
    [self.paneView addSubview:self.countLabel];

    [self addCount];
    [self initBottomView];
    
    UIView *lineTow = [[UIView alloc] initWithFrame:CGRectMake(0, PANEVIE_HEIGHT - 46, SH_SCREEN_WIDTH, 1)];
    lineTow.backgroundColor = FMColorWithRGB0X(0xf5f5f5);
    [self.paneView addSubview:lineTow];
}

- (void)addCount
{
    CGFloat btnHeight = 28.0;
    UIView *stepBg = [[UIView alloc] initWithFrame:CGRectMake(SH_SCREEN_WIDTH - 15 - 90, 65, 90, btnHeight)];
    [self.paneView addSubview:stepBg];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setTitle:@"-" forState:UIControlStateNormal];
    self.deleteBtn.frame = CGRectMake(0, 0, btnHeight, btnHeight);
    [self.deleteBtn setTitleColor:FMColorWithRGB0X(0xcfcfcf) forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:23];
    self.deleteBtn.backgroundColor = FMColorWithRGB0X(0xf1f1f1);
    [stepBg addSubview:self.deleteBtn];
    [self.deleteBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setTitle:@"+" forState:UIControlStateNormal];
    self.addBtn.frame = CGRectMake(90 - btnHeight, 0, btnHeight, btnHeight);
    [self.addBtn setTitleColor:FMColorWithRGB0X(0xcfcfcf) forState:UIControlStateNormal];
    self.addBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    self.addBtn.backgroundColor = FMColorWithRGB0X(0xf1f1f1);
    [stepBg addSubview:self.addBtn];
    [self.addBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.deleteBtn.frame)+2, 0, 30, btnHeight)];
    self.numLabel.text = @"1";
    self.numLabel.textColor = FMColorWithRGB0X(0x333333);
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.font = [UIFont systemFontOfSize:14];
    self.numLabel.backgroundColor = FMColorWithRGB0X(0xf1f1f1);
    [stepBg addSubview:self.numLabel];
    
    self.currentNum = 1;
    self.price = 1;
}

- (void)initBottomView
{
    self.accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PANEVIE_HEIGHT - 46, SH_SCREEN_WIDTH/2.0, 46.0f)];
    self.accountLabel.font = [UIFont systemFontOfSize:12.0f];
    self.accountLabel.textAlignment = NSTextAlignmentCenter;
    self.accountLabel.textColor = UIColorFromRGB(0x666666);
    [self.paneView addSubview:self.accountLabel];
    
    self.orderButton = [[UIButton alloc] initWithFrame:CGRectMake(SH_SCREEN_WIDTH - ORDERBUTTON_WIDTH, PANEVIE_HEIGHT - 46.0f, ORDERBUTTON_WIDTH, 46.0f)];
    self.orderButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.orderButton setTitle:@"提交下单" forState:UIControlStateNormal];
    [self.orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.orderButton setBackgroundImage:[UIImage createImageWithColor:FMColorWithRGB0X(0xffa414)] forState:UIControlStateNormal];
    [self.orderButton setBackgroundImage:[UIImage createImageWithColor:FMColorWithRGB0X(0xeb9712)] forState:UIControlStateHighlighted];
    [self.orderButton addTarget:self action:@selector(orderButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.paneView addSubview:self.orderButton];
}

- (int)getCurrentNum
{
    return self.currentNum;
}

- (void)btnClicked:(UIButton *)btn
{
    if ([btn isEqual:self.deleteBtn]) {
        if (self.currentNum > 1) {
            self.currentNum--;
        }
    }else {
        self.currentNum++;
    }
    [self showTotalMoney];
    self.numLabel.text = [NSString stringWithFormat:@"%d",self.currentNum];
}

- (void)orderButtonTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderSubmit:)]) {
        [self.delegate orderSubmit:self.currentNum];
    }
}

- (void)showTotalMoney
{
    NSString *amount = [NSString stringWithFormat:@"合计:¥%.2f", self.price*self.currentNum];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:amount];
    [attributeStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:13.0f]
                         range:NSMakeRange(0, amount.length)];
    [attributeStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:15.0f]
                         range:NSMakeRange(3, amount.length - 3)];
    
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:FMColorWithRGB0X(0x666666)
                         range:NSMakeRange(0, amount.length)];
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:FMColorWithRGB0X(0xffa414)
                         range:NSMakeRange(3, amount.length - 3)];
    self.accountLabel.attributedText = attributeStr;
    self.accountLabel.attributedText = attributeStr;
    [self.accountLabel sizeToFit];
    CGRect frame = self.accountLabel.frame;
    frame.origin.x = 25.0f;
    frame.origin.y = self.orderButton.center.y - frame.size.height/2.0;
    self.accountLabel.frame = frame;
}

- (void)closebutton:(id)sender
{
    [SVProgressHUD dismiss];
    [self removeFromSuperview];
}

#pragma mark public

- (void)configData:(float)price
{
    self.price = price;
    [self showTotalMoney];
}

@end
