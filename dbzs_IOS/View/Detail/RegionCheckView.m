//
//  RegionCheckView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/13.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "RegionCheckView.h"

#define VIEW_WIDTH                  75.0f
#define VIEW_HEIGHT                 25.0f
#define ARROW_WIDTH                 8.5f
#define ARROW_HEIGHT                5.0f
#define ARROW_MARGIN_LEFT           4.0f
#define REGIONLABEL_MARGIN_LEFT     7.0f

@interface RegionCheckView ()

@property (nonatomic, strong) UILabel *regionLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIButton *checkButton;

@end

@implementation RegionCheckView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT);
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = FMColorWithRGB0X(0xefefef).CGColor;
    self.layer.cornerRadius = 5.0f;
    
    [self initRegionLabel];
    [self updateCheckLabel:5];
}

- (void)initRegionLabel
{
    self.regionLabel = [[UILabel alloc] init];
    self.regionLabel.font = [UIFont systemFontOfSize:12.0f];
    self.regionLabel.textColor = UIColorFromRGB(0x666666);
    [self addSubview:self.regionLabel];
    
    self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ARROW_WIDTH, ARROW_HEIGHT)];
    self.arrowImageView.image = [UIImage imageNamed:@"down_arrow"];
    [self addSubview:self.arrowImageView];
    
    self.checkButton = [[UIButton alloc] initWithFrame:self.bounds];
    [self.checkButton addTarget:self action:@selector(checkButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.checkButton];
}

#pragma mark private

- (void)checkButtonTap:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(regionCheckButtonTab)]) {
        [self.delegate regionCheckButtonTab];
    }
}

#pragma mark public

- (void)updateCheckLabel:(int)region
{
    self.regionLabel.text = [NSString stringWithFormat:@"%d个分区",region];
    [self.regionLabel sizeToFit];
    CGRect regionLabelFrame =self.regionLabel.frame;
    regionLabelFrame.origin.x = REGIONLABEL_MARGIN_LEFT;
    regionLabelFrame.origin.y = (VIEW_HEIGHT - regionLabelFrame.size.height)/2.0;
    self.regionLabel.frame = regionLabelFrame;
    
    CGRect arrowFrame = self.arrowImageView.frame;
    arrowFrame.origin.x = CGRectGetMaxX(self.regionLabel.frame) + ARROW_MARGIN_LEFT;
    arrowFrame.origin.y = (VIEW_HEIGHT - ARROW_HEIGHT)/2.0;
    self.arrowImageView.frame = arrowFrame;
}

@end
