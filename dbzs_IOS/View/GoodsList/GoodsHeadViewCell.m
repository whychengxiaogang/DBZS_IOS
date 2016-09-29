//
//  GoodsHeadViewCell.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/17.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "GoodsHeadViewCell.h"

#define CELL_HEIGHT             45.0f
#define ICON_WIDTH              15.5f
#define ICON_HEIGHT             15.5f
#define ICON_MARIN_LEFT         18.0f
#define TITLE_MARGIN_LEFT       5.0f

@interface GoodsHeadViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GoodsHeadViewCell

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
    self.backgroundColor = FMColorWithRGB0X(0xf5f5f5);
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ICON_MARIN_LEFT, (CELL_HEIGHT - ICON_HEIGHT)/2.0 + 3.0f, ICON_WIDTH, ICON_HEIGHT)];
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.titleLabel];
}

#pragma mark public

- (void)configData:(NSString *)title imageName:(NSString *)imageName
{
    self.iconImageView.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = CGRectGetMaxX(self.iconImageView.frame) + TITLE_MARGIN_LEFT;
    titleFrame.origin.y = self.iconImageView.center.y - titleFrame.size.height/2.0;
    self.titleLabel.frame = titleFrame;
}

+ (CGSize)calCellSize
{
    return CGSizeMake(SH_SCREEN_WIDTH, CELL_HEIGHT);
}

@end
