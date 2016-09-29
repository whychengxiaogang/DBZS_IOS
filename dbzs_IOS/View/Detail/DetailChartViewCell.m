//
//  DetailChartViewCell.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/11.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DetailChartViewCell.h"
#import "DetailRegionView.h"
#import "DetailChartView.h"

#define CELL_HEIGHT                 365.0f
#define HEADER_BAR_HEIGHT           35.0f
#define DATACHART_MARGIN_TOP        4.0f
#define DATCHART_BUTTON_MARGIN      43.0f
#define CHARTVIEW_HEIGHT            325.0f

@interface DetailChartViewCell () <DetailChartViewDelegate>

@property (nonatomic, strong) UIButton *chartButton;
@property (nonatomic, strong) UIButton *regionButton;
@property (nonatomic, strong) UIView *redLine;
@property (nonatomic, strong) UIView *headerSpreLine;
@property (nonatomic, strong) DetailRegionView *detailRegionView;
@property (nonatomic, strong) DetailChartView *detailChartView;

@end

@implementation DetailChartViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    [self initHeadView];
    [self initDetailChartView];
    [self initDetailRegionView];
}

- (void)initHeadView
{
    self.chartButton = [self headButton:@"数据图表"];
    [self.chartButton addTarget:self action:@selector(chartButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    CGRect dataFrame = self.chartButton.frame;
    dataFrame.origin.x = SH_SCREEN_WIDTH/2.0 - 43.0f - self.chartButton.frame.size.width;
    dataFrame.origin.y = DATACHART_MARGIN_TOP;
    self.chartButton.selected = YES;
    self.chartButton.frame = dataFrame;
    [self.contentView addSubview:self.chartButton];

    self.regionButton = [self headButton:@"区间遗漏"];
    [self.regionButton addTarget:self action:@selector(regionButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    CGRect regionFrame = self.regionButton.frame;
    regionFrame.origin.x = SH_SCREEN_WIDTH/2.0 + DATCHART_BUTTON_MARGIN;
    regionFrame.origin.y = DATACHART_MARGIN_TOP;
    self.regionButton.frame = regionFrame;
    [self.contentView addSubview:self.regionButton];
    
    self.redLine = [[UIView alloc] init];
    self.redLine.backgroundColor = FMColorWithRGB0X(0xf04848);
    CGRect redLineFrame = self.redLine.frame;
    redLineFrame.origin.x = dataFrame.origin.x - 2.0f;
    redLineFrame.size.height = 1.0f;
    redLineFrame.size.width = dataFrame.size.width + 3.0f;
    redLineFrame.origin.y = HEADER_BAR_HEIGHT - 1.0f;
    self.redLine.frame = redLineFrame;
    [self.contentView addSubview:self.redLine];
    
    self.headerSpreLine = [[UIView alloc] initWithFrame:CGRectMake(0, HEADER_BAR_HEIGHT, SH_SCREEN_WIDTH, 0.5)];
    self.headerSpreLine.backgroundColor = FMColorWithRGB0X(0xdddddd);
    [self.contentView addSubview:self.headerSpreLine];
}

- (UIButton *)headButton:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:FMColorWithRGB0X(0xf04848) forState:UIControlStateSelected];
    [button setTitleColor:FMColorWithRGB0X(0x333333) forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

- (void)initDetailRegionView
{
    self.detailRegionView = [[DetailRegionView alloc] initWithFrame:CGRectMake(0, HEADER_BAR_HEIGHT, SH_SCREEN_WIDTH, CHARTVIEW_HEIGHT)];
    self.detailRegionView.hidden = YES;
    [self.contentView addSubview:self.detailRegionView];
}

- (void)initDetailChartView
{
    self.detailChartView = [[DetailChartView alloc] initWithFrame:CGRectMake(0, HEADER_BAR_HEIGHT, SH_SCREEN_WIDTH, CHARTVIEW_HEIGHT)];
    self.detailChartView.delegate = self;
    [self.contentView addSubview:self.detailChartView];
}

#pragma mark private

- (void)chartButtonTap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = YES;
    self.regionButton.selected = NO;
    [self moveRedLien:button.frame];
    [self showChartView];
}

- (void)regionButtonTap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = YES;
    self.chartButton.selected = NO;
    [self moveRedLien:button.frame];
    [self showRegionView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showRegionView)]) {
        [self.delegate showRegionView];
    }
}

- (void)moveRedLien:(CGRect)frame;
{
    CGRect redLineFrame = self.redLine.frame;
    redLineFrame.origin.x = frame.origin.x - 2.0f;
    self.redLine.frame = redLineFrame;
}

- (void)showChartView
{
    self.detailChartView.hidden = NO;
    self.detailRegionView.hidden = YES;
}

- (void)showRegionView
{
    self.detailChartView.hidden = YES;
    self.detailRegionView.hidden = NO;
}

#pragma mark DetailChartViewDelegate

- (void)maxRegionTab:(int)region
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeInterfaceOrientatio:)]) {
        [self.delegate changeInterfaceOrientatio:region];
    }
}

#pragma mark public

- (void)configData:(NSArray *)winnerList regionData:(NSDictionary *)regionData
{
    [self.detailChartView configData:winnerList];
    [self.detailRegionView configData:regionData];
}

+ (CGFloat)calCellHeight
{
    return CELL_HEIGHT;
}

@end
