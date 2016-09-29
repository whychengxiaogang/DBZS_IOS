//
//  SearchGoodsViewCell.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/10.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "SearchGoodsViewCell.h"

#define CELL_HEIGHT         44.0f
#define TEXTMARGIN_LEFT     25.0f

@interface SearchGoodsViewCell ()

@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) DBZSProductModel *product;

@end

@implementation SearchGoodsViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.goodsNameLabel = [[UILabel alloc] init];
    self.goodsNameLabel.font = [UIFont systemFontOfSize:15.0f];
    self.goodsNameLabel.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.goodsNameLabel];
    
    self.topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SH_SCREEN_WIDTH, 0.5)];
    self.topLine.backgroundColor = FMColorWithRGB0X(0xdddddd);
    [self.contentView addSubview:self.topLine];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT - 0.5, SH_SCREEN_WIDTH, 0.5)];
    self.bottomLine.backgroundColor = FMColorWithRGB0X(0xdddddd);
    [self.contentView addSubview:self.bottomLine];
    
    self.checkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SH_SCREEN_WIDTH, CELL_HEIGHT)];
    [self.checkButton addTarget:self action:@selector(checkButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.checkButton];
}

- (void)checkButtonTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsTap:)]) {
        [self.delegate goodsTap:self.product.product_id];
    }
}

#pragma mark public

- (void)configData:(DBZSProductModel *)product
{
    self.product = product;
    self.goodsNameLabel.text = product.title;
    [self.goodsNameLabel sizeToFit];
    CGRect frame = self.goodsNameLabel.frame;
    frame.origin.x = TEXTMARGIN_LEFT;
    frame.origin.y = (CELL_HEIGHT - frame.size.height)/2.0;
    self.goodsNameLabel.frame = frame;
}

+ (CGFloat)calCellHeight
{
    return CELL_HEIGHT;
}

@end
