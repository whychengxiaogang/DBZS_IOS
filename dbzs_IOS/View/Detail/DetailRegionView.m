//
//  DetailRegionView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/13.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DetailRegionView.h"
#import "RegionCheckView.h"

#define VIEW_HEIGHT                 305.0f
#define TABBAR_HEIGHT               25.0f
#define TABBAR_MARGIN_TOP           18.0f
#define TABBAR_MARGIN_LEFT          15.0f
#define CHARTHEADER_MARGIN_TOP      22.0f
#define CHARTHEADER_HEIGHT          20.0f
#define CHARTCELL_HEIGHT            29.0f
#define TITLELABEL_MARGIN_LEFT      15.0f
#define REGIONCHECKVIEW_MARIN_LEFT  3.0f
#define REGIONCHECK_WIDTH           73.0f
#define REGION_CHECK_HEIGHT         25.0f

@interface DetailRegionView () <RegionCheckViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *tabBar;
@property (nonatomic, strong) UIButton *tabSelectButton;
@property (nonatomic, strong) NSArray *winnerList;
@property (nonatomic, strong) NSArray *tabNameList;
@property (nonatomic, strong) NSArray *tabRegionList;
@property (nonatomic, strong) RegionCheckView *regionCheckView;
@property (nonatomic, strong) UIView *chartHeadView;
@property (nonatomic, strong) UIScrollView *rowChartView;
@property (nonatomic, strong) UIScrollView *regionScrollView;
@property (nonatomic, strong) NSArray *regionList;
@property (nonatomic, strong) NSDictionary *regionData;
@property (nonatomic, assign) int currentRowRegion;
@property (nonatomic, assign) int currentDateRegion;

@end

@implementation DetailRegionView

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
    self.regionList = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
    self.tabNameList = @[@"近30期",@"近50期",@"近100期"];
    self.tabRegionList = @[@30, @50, @100];
    self.currentDateRegion = 30;
    self.currentRowRegion = 5;
    [self initTitleLabel];
    [self initRegionCheckView];
    [self initTabBar];
    [self initChartHeadView];
    [self initrowChartView];
    [self initRegionScrollView];
}

- (void)initTitleLabel
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.titleLabel.textColor = UIColorFromRGB(0x666666);
    self.titleLabel.text = @"划分为";
    [self addSubview:self.titleLabel];
    [self.titleLabel sizeToFit];
    CGRect frame = self.titleLabel.frame;
    frame.origin.x = TITLELABEL_MARGIN_LEFT;
    frame.origin.y = TABBAR_MARGIN_TOP + TABBAR_HEIGHT/2.0 - frame.size.height/2.0;
    self.titleLabel.frame = frame;
}

- (void)initRegionCheckView
{
    self.regionCheckView = [[RegionCheckView alloc] init];
    self.regionCheckView.delegate = self;
    [self addSubview:self.regionCheckView];
    CGRect frame = self.regionCheckView.frame;
    frame.origin.x = CGRectGetMaxX(self.titleLabel.frame) + REGIONCHECKVIEW_MARIN_LEFT;
    frame.origin.y = TABBAR_MARGIN_TOP;
    self.regionCheckView.frame = frame;
}

- (void)initTabBar
{
    self.tabBar = [[UIView alloc] init];
    self.tabBar.layer.cornerRadius = 5.0f;
    self.tabBar.layer.borderColor = FMColorWithRGB0X(0xefefef).CGColor;
    self.tabBar.layer.borderWidth = 1.0f;
    self.tabBar.clipsToBounds = YES;
    [self addSubview:self.tabBar];
    CGFloat rowWidth = 0;
    for (NSString *name in self.tabNameList) {
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:FMColorWithRGB0X(0x333333) forState:UIControlStateSelected];
        [button setTitleColor:FMColorWithRGB0X(0x666666) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        CGRect buttonFrame = button.frame;
        buttonFrame.size.height = TABBAR_HEIGHT;
        buttonFrame.size.width += 12;
        buttonFrame.origin.x = rowWidth;
        button.frame = buttonFrame;
        NSInteger index = [self.tabNameList indexOfObject:name];
        button.tag = [[self.tabRegionList objectAtIndex: index] intValue];
        [self.tabBar addSubview:button];
        if ([self.tabNameList indexOfObject:name] == 0) {
            [self updateTabButton:button];;
        }
        if ([self.tabNameList indexOfObject:name] < (self.tabNameList.count - 1)) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = FMColorWithRGB0X(0xefefef);
            CGRect lineFrame = line.frame;
            lineFrame.origin.x = CGRectGetMaxX(button.frame);
            lineFrame.size.height = TABBAR_HEIGHT;
            lineFrame.size.width = 1.0f;
            line.frame = lineFrame;
            [self.tabBar addSubview:line];
            rowWidth += 1.0f;
        }
        rowWidth += buttonFrame.size.width;
    }
    CGRect tabBarFrame = self.tabBar.frame;
    tabBarFrame.size = CGSizeMake(rowWidth, TABBAR_HEIGHT);
    tabBarFrame.origin.y = TABBAR_MARGIN_TOP;
    tabBarFrame.origin.x = CGRectGetMaxX(self.regionCheckView.frame) + TABBAR_MARGIN_LEFT;
    self.tabBar.frame = tabBarFrame;
}

- (void)initChartHeadView
{
    self.chartHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.regionCheckView.frame) + CHARTHEADER_MARGIN_TOP, SH_SCREEN_WIDTH, CHARTHEADER_HEIGHT)];
    self.chartHeadView.backgroundColor = FMColorWithRGB0X(0xf5f5f5);
    [self addSubview:self.chartHeadView];
    CGFloat width = (SH_SCREEN_WIDTH - TITLELABEL_MARGIN_LEFT)/3.0;
   [self.chartHeadView addSubview:[self factoryLabel:@"区间" width:width*1.5 xOff:TITLELABEL_MARGIN_LEFT alignment:NSTextAlignmentLeft height:CHARTHEADER_HEIGHT]];
    [self.chartHeadView addSubview:[self factoryLabel:@"中奖次数" width:width-2 xOff:TITLELABEL_MARGIN_LEFT + width*1.1+2 alignment:NSTextAlignmentLeft height:CHARTHEADER_HEIGHT]];
    [self.chartHeadView addSubview:[self factoryLabel:@"遗漏次数" width:width*0.5 xOff:TITLELABEL_MARGIN_LEFT+width*2.2 alignment:NSTextAlignmentLeft height:CHARTHEADER_HEIGHT]];
}

- (UILabel *)factoryLabel:(NSString *)title width:(CGFloat)width xOff:(CGFloat)xOff alignment:(NSTextAlignment)alignment height:(CGFloat)height
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xOff, 0, width, height)];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = UIColorFromRGB(0x666666);
    label.textAlignment = alignment;
    label.text = title;
    return label;
}

- (void)initRegionScrollView
{
    self.regionScrollView = [[UIScrollView alloc] init];
    self.regionScrollView.layer.borderWidth = 1.0f;
    self.regionScrollView.layer.borderColor = FMColorWithRGB0X(0xefefef).CGColor;
    self.regionScrollView.layer.cornerRadius = 2.0f;
    self.regionScrollView.hidden = YES;
    self.regionScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.regionScrollView];
    
    CGFloat rowHeight = 3;
    for (NSNumber *region in self.regionList) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, REGIONCHECK_WIDTH*0.8, REGION_CHECK_HEIGHT)];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setTitle:[region stringValue] forState:UIControlStateNormal];
        [button setTitleColor:FMColorWithRGB0X(0x666666) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(regionButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = [region intValue];
        [self.regionScrollView addSubview:button];
        CGRect frame = button.frame;
        frame.origin.y = rowHeight;
        button.frame = frame;
        rowHeight = CGRectGetMaxY(button.frame);
    }
    self.regionScrollView.contentSize = CGSizeMake(REGIONCHECK_WIDTH, rowHeight + 6.0f);
    CGRect regionFrame = self.regionScrollView.frame;
    regionFrame.size = CGSizeMake(REGIONCHECK_WIDTH, REGION_CHECK_HEIGHT*5);
    regionFrame.origin.y = CGRectGetMaxY(self.regionCheckView.frame) + 1.0f;
    regionFrame.origin.x = self.regionCheckView.frame.origin.x;
    self.regionScrollView.frame = regionFrame;
}

- (void)initrowChartView
{
    self.rowChartView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.chartHeadView.frame), SH_SCREEN_WIDTH, VIEW_HEIGHT - CGRectGetMaxY(self.chartHeadView.frame))];
    self.rowChartView.bounces = NO;
    [self addSubview:self.rowChartView];
}

- (UIView *)factoryCellView:(DBZSRegionModel *)model
{
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SH_SCREEN_WIDTH, CHARTCELL_HEIGHT)];
    CGFloat width = (SH_SCREEN_WIDTH - TITLELABEL_MARGIN_LEFT)/3.0;
    [cell addSubview:[self factoryLabel:model.qujian width:width*1.2 xOff:TITLELABEL_MARGIN_LEFT alignment:NSTextAlignmentLeft height:CHARTCELL_HEIGHT]];
    [cell addSubview:[self factoryLabel:[NSString stringWithFormat:@"%d(%d％)",model.win_count, model.per] width:width-5 xOff:TITLELABEL_MARGIN_LEFT + width*1.1+5 alignment:NSTextAlignmentLeft height:CHARTCELL_HEIGHT]];
    [cell addSubview:[self factoryLabel:[NSString stringWithFormat:@"%d",model.lost] width:width*0.8 xOff:TITLELABEL_MARGIN_LEFT+width*2.2 + 5 alignment:NSTextAlignmentLeft height:CHARTCELL_HEIGHT]];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CHARTCELL_HEIGHT - 0.5, SH_SCREEN_WIDTH, 0.5)];
    line.backgroundColor = FMColorWithRGB0X(0xeeeeee);
    [cell addSubview:line];
    return cell;
}

#pragma mark private

- (void)tabButtonTap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self updateTabButton:button];
    [self updaterowChartView];
}

- (void)updateTabButton:(UIButton *)button
{
    self.tabSelectButton.backgroundColor = [UIColor whiteColor];
    self.tabSelectButton.selected = NO;
    self.tabSelectButton = button;
    self.tabSelectButton.backgroundColor = FMColorWithRGB0X(0xefefef);
    self.tabSelectButton.selected = YES;
    self.currentDateRegion = (int)self.tabSelectButton.tag;
}

- (void)regionButtonTap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int region = (int)button.tag;
    self.currentRowRegion = region;
    self.regionScrollView.hidden = YES;
    [self.regionCheckView updateCheckLabel:region];
    [self updaterowChartView];
}

- (void)updaterowChartView
{
    NSString *currentRow = [NSString stringWithFormat:@"%d",self.currentRowRegion];
    NSString *currentDate = [NSString stringWithFormat:@"%d",self.currentDateRegion];
    NSDictionary *dateDic = [self.regionData safeObjectForKey:currentRow];
    NSDictionary *rowData = [dateDic safeObjectForKey:currentDate];
    [self.rowChartView removeAllSubViews];
    CGFloat rowHeight = 0;
    for (int i=1; i<=self.currentRowRegion; i++) {
        NSString *row = [NSString stringWithFormat:@"%d", i];
        DBZSRegionModel *model = [[DBZSRegionModel alloc] initWithJson:[rowData safeObjectForKey:row]];
        UIView *cell = [self factoryCellView:model];
        [self.rowChartView addSubview:cell];
        CGRect frame = cell.frame;
        frame.origin.y = rowHeight;
        cell.frame = frame;
        rowHeight = CGRectGetMaxY(cell.frame);
    }
    self.rowChartView.contentSize = CGSizeMake(SH_SCREEN_WIDTH, rowHeight + CHARTCELL_HEIGHT);
}

#pragma mark RegionCheckViewDelegate

- (void)regionCheckButtonTab
{
    self.regionScrollView.hidden = !self.regionScrollView.hidden;
}

#pragma mark public

- (void)configData:(NSDictionary *)regionData
{
    if (self.regionData !=regionData) {
        self.regionData = regionData;
        [self updaterowChartView];
    }
}

@end
