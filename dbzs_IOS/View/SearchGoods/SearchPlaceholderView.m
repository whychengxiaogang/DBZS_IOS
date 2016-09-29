//
//  SearchPlaceholderView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/10.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "SearchPlaceholderView.h"

#define VIEW_HEIGHT                         35.0
#define SEARCH_ICON_WIDTH                   16.0f
#define SEARCH_ICON_HEIGHT                  16.0f
#define SEARCH_ICON_MIN_MARGIN_LEFT         15.0f
#define TEXTMARGIN_LEFT                     5.0f

@interface SearchPlaceholderView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SearchPlaceholderView

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
    self.clipsToBounds = YES;
    self.userInteractionEnabled = NO;
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SEARCH_ICON_WIDTH, SEARCH_ICON_HEIGHT)];
    self.iconImageView.image = [UIImage imageNamed:@"search_small"];
    [self addSubview:self.iconImageView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = [UIFont systemFontOfSize:15.0f];
    self.textLabel.textColor = UIColorFromRGB(0x999999);
    self.textLabel.text = @"请输入商品名称或ID查找";
    [self addSubview:self.textLabel];
    [self.textLabel sizeToFit];
    CGRect textFrame = self.textLabel.frame;
    textFrame.origin.x = SEARCH_ICON_WIDTH + TEXTMARGIN_LEFT;
    textFrame.origin.y = self.iconImageView.center.y - textFrame.size.height/2.0;
    self.textLabel.frame = textFrame;
    self.frame = CGRectMake(0, 0, CGRectGetMaxX(textFrame), SEARCH_ICON_HEIGHT);
}

- (void)showText
{
    self.bounds = CGRectMake(0, 0, CGRectGetMaxX(self.textLabel.frame), SEARCH_ICON_HEIGHT);
}

- (void)showIconOnly
{
    self.bounds = CGRectMake(0, 0, SEARCH_ICON_WIDTH + TEXTMARGIN_LEFT, SEARCH_ICON_HEIGHT);
}

+ (CGFloat)iconAndSpaceWidth
{
    return SEARCH_ICON_WIDTH + TEXTMARGIN_LEFT;
}

@end
