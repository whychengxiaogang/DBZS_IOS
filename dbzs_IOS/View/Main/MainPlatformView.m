//
//  MainPlatformView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "MainPlatformView.h"

#define VIEW_HEIGHT             245.0f
#define LOGO_WIDTH              122.0f
#define LOGO_HEIGHT             122.0f
#define LOGO_MARGIN_TOP         44.0f
#define NAME_MARGIN_TOP         15.0f
#define SUBTITLE_MARGIN_TOP     8.0f
#define ARROW_MARGIN_LEFT       9.0f
#define ARROW_WIDTH             9.0f
#define ARROW_HEIGHT            15.0f
#define BOTTOMLINE_HEIGHT       1.5f

@interface MainPlatformView ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *bottomLine;
@property (nonatomic, strong) UIButton *tapButton;
@property (nonatomic, assign) PLATFORM_TYPE platform;

@end

@implementation MainPlatformView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SH_SCREEN_WIDTH, VIEW_HEIGHT);
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    [self initLogoImageView];
    [self initInfo];
    [self initBottomLine];
    [self initTapButton];
}

- (void)initLogoImageView
{
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SH_SCREEN_WIDTH - LOGO_WIDTH)/2.0, LOGO_MARGIN_TOP, LOGO_WIDTH, LOGO_HEIGHT)];
    [self addSubview:self.logoImageView];
}

- (void)initInfo
{
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:17.0f];
    self.nameLabel.textColor = UIColorFromRGB(0xea264e);
    [self addSubview:self.nameLabel];
    
    self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ARROW_WIDTH, ARROW_HEIGHT)];
    [self addSubview:self.arrowImageView];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.subTitleLabel.textColor = UIColorFromRGB(0x999999);
    [self addSubview:self.subTitleLabel];
}

- (void)initBottomLine
{
    self.bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT - BOTTOMLINE_HEIGHT, SH_SCREEN_WIDTH, BOTTOMLINE_HEIGHT)];
    self.bottomLine.image = [UIImage imageNamed:@"platform_bottom_line"];
    [self addSubview:self.bottomLine];
}

- (void)initTapButton
{
    self.tapButton = [[UIButton alloc] initWithFrame:self.bounds];
    [self.tapButton addTarget:self action:@selector(tapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.tapButton];
}

#pragma mark private

- (void)tapButtonAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabButtonTaped:)]) {
        [self.delegate tabButtonTaped:self.platform];
    }
}

- (void)platformData:(PLATFORM_TYPE)platformType
{
    switch (platformType) {
        case PLATFORM_TYPE_NETEASE:
        {
            self.logoImageView.image = [UIImage imageNamed:@"163_logo"];
            self.arrowImageView.image = [UIImage imageNamed:@"163_arrow"];
            self.nameLabel.text = @"网易一元夺宝";
            self.nameLabel.textColor = UIColorFromRGB(0xea264e);
            self.subTitleLabel.text = @"做为国内首个采用时彩开奖的平台，更加公平";
        }
            break;
        case PLATFORM_TYPE_YUNGOU:
        {
            self.logoImageView.image = [UIImage imageNamed:@"1yuan_logo"];
            self.arrowImageView.image = [UIImage imageNamed:@"1yuan_arrow"];
            self.nameLabel.text = @"一元云购";
            self.nameLabel.textColor = UIColorFromRGB(0xff6600);
            self.subTitleLabel.text = @"国内一元众筹发起者，运营多年，值得信赖";
        }
            break;
        default:
            break;
    }
}

- (void)layoutAllFrame
{
    [self.nameLabel sizeToFit];
    CGFloat margin = (SH_SCREEN_WIDTH - self.nameLabel.frame.size.width - ARROW_MARGIN_LEFT - ARROW_WIDTH)/2.0;
    CGRect nameLabelFrame = self.nameLabel.frame;
    nameLabelFrame.origin.x = margin;
    nameLabelFrame.origin.y = CGRectGetMaxY(self.logoImageView.frame) + NAME_MARGIN_TOP;
    self.nameLabel.frame = nameLabelFrame;
    
    CGRect arrowFrame = self.arrowImageView.frame;
    arrowFrame.origin.x = CGRectGetMaxX(self.nameLabel.frame) + ARROW_MARGIN_LEFT;
    arrowFrame.origin.y = self.nameLabel.center.y - ARROW_HEIGHT/2.0;
    self.arrowImageView.frame = arrowFrame;
    
    [self.subTitleLabel sizeToFit];
    CGRect subTitleLabelFrame = self.subTitleLabel.frame;
    subTitleLabelFrame.origin.x = (SH_SCREEN_WIDTH - subTitleLabelFrame.size.width)/2.0;
    subTitleLabelFrame.origin.y = CGRectGetMaxY(self.nameLabel.frame) + SUBTITLE_MARGIN_TOP;
    self.subTitleLabel.frame = subTitleLabelFrame;
}

#pragma mark public

- (void)configData:(PLATFORM_TYPE)platformType
{
    self.platform = platformType;
    [self platformData:platformType];
    [self layoutAllFrame];
}

+ (CGFloat)calcHeight
{
    return VIEW_HEIGHT;
}

@end
