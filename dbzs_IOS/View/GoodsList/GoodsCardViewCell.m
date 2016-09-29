//
//  GoodsCardViewCell.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/17.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "GoodsCardViewCell.h"

#define PADDING_LEFT             6.0f
#define PADDING_TOP              7.0

@interface GoodsCardViewCell ()

@property (nonatomic, strong) UILabel *goodsLabel;
@property (nonatomic, strong) UIButton *tapButton;
@property (nonatomic, strong) DBZSProductModel *model;

@end

@implementation GoodsCardViewCell

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
    self.goodsLabel = [[UILabel alloc] init];
    self.goodsLabel.font = [UIFont systemFontOfSize:12.0f];
    self.goodsLabel.textAlignment = NSTextAlignmentCenter;
    self.goodsLabel.textColor = FMColorWithRGB0X(0x666666);
    self.goodsLabel.backgroundColor = FMColorWithRGB0X(0xf3f3f3);
    [self.contentView addSubview:self.goodsLabel];
    
    self.tapButton = [[UIButton alloc] init];
    [self.tapButton addTarget:self action:@selector(tapButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.tapButton];
}

- (void)tapButtonTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsTaped:)]) {
        [self.delegate goodsTaped:self.model.product_id];
    }
}

#pragma mark public

- (void)configData:(DBZSProductModel *)model
{
    self.model = model;
    self.goodsLabel.text = model.title;
    [self.goodsLabel sizeToFit];
    CGRect frame = self.goodsLabel.frame;
    frame.size.width += PADDING_LEFT*2;
    frame.size.height += PADDING_TOP*2;
    self.goodsLabel.frame = frame;
    self.goodsLabel.layer.cornerRadius = frame.size.height/2.0 - 1.0f;
    self.goodsLabel.clipsToBounds = YES;
    self.tapButton.frame = frame;
}

+ (CGSize)calCellSize:(DBZSProductModel *)model
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:model.title];
    [attributeStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:12.0f]
                         range:NSMakeRange(0, model.title.length)];
    ;
    CGSize size = [attributeStr boundingRectWithSize:CGSizeMake(SH_SCREEN_WIDTH,SH_SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return CGSizeMake(size.width + PADDING_LEFT *2, size.height + PADDING_TOP*2);
}

@end
