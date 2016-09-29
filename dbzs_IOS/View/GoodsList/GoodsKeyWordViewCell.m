//
//  GoodsKeyWordViewCell.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/17.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "GoodsKeyWordViewCell.h"

@interface GoodsKeyWordViewCell ()

@property (nonatomic, strong) UILabel *keyWordLabel;
@property (nonatomic, strong) UIButton *tapButton;
@property (nonatomic, strong) NSString *title;

@end

@implementation GoodsKeyWordViewCell

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
    self.backgroundColor = [UIColor whiteColor];
    self.keyWordLabel = [[UILabel alloc] init];
    self.keyWordLabel.textColor = FMColorWithRGB0X(0x666666);
    self.keyWordLabel.font = [UIFont systemFontOfSize:14.0f];
    self.keyWordLabel.clipsToBounds = YES;
    [self.contentView addSubview:self.keyWordLabel];

    self.tapButton = [[UIButton alloc] init];
    [self.tapButton addTarget:self action:@selector(tapButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.tapButton];
}

- (void)tapButtonTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(keywordTaped:)]) {
        [self.delegate keywordTaped:self.title];
    }
}

#pragma mark public

- (void)configData:(NSString *)title
{
    self.title = title;
    self.keyWordLabel.text = title;
    [self.keyWordLabel sizeToFit];
    self.keyWordLabel.backgroundColor = [UIColor whiteColor];
    self.keyWordLabel.layer.cornerRadius = 0;
    self.tapButton.frame = self.keyWordLabel.frame;
}

- (void)showClose
{
    self.keyWordLabel.backgroundColor = FMColorWithRGB0X(0xf5f5f5);
    self.keyWordLabel.layer.cornerRadius = 3.0f;
}

+ (CGSize)calCellSize:(NSString *)title
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attributeStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:14.0f]
                         range:NSMakeRange(0, title.length)];
    ;
    return [attributeStr boundingRectWithSize:CGSizeMake(SH_SCREEN_WIDTH,SH_SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

@end
