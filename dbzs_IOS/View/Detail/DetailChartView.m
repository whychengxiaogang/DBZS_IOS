//
//  DetailChartView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/13.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DetailChartView.h"
#import "ZCChartlineView.h"

#define VIEW_HEIGHT                 325.0f
#define DATELABEL_MARIN_TOP         15.0f
#define TABBAR_HEIGHT               25.0f
#define CHARTVIEW_HEIGHT            220.0f
#define NUMBERLABEL_MARGIN_TOP      5.0f
#define TABBAR_MARGIN_BOTTOM        7.0f

@interface DetailChartView () <ZCChartlineViewDelegate>

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *tabBar;
@property (nonatomic, strong) UIButton *tabSelectButton;
@property (nonatomic, strong) ZCChartlineView *chartView;
@property (nonatomic, strong) NSArray *winnerList;
@property (nonatomic, strong) NSArray *tabNameList;
@property (nonatomic, strong) NSArray *tabRegionList;
@property (nonatomic, assign) int currentRegion;
@property (nonatomic, strong) NSArray *winnerOrderList;
@property (nonatomic, strong) UILabel *bgLogoLabe;
@property (nonatomic, strong) UILabel *topLogoLabe;

@end

@implementation DetailChartView

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
    self.tabNameList = @[@"近20期",@"近30期",@"近50期",@"近100期"];
    self.tabRegionList = @[@20, @30, @50, @100];
    [self initInfoView];
    [self initTabBar];
    [self initBgLogoLabe];
}

- (void)initInfoView
{
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.font = [UIFont systemFontOfSize:11.0f];
    self.dateLabel.textColor = UIColorFromRGB(0x666666);
    [self addSubview:self.dateLabel];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = [UIFont systemFontOfSize:11.0f];
    self.numberLabel.textColor = UIColorFromRGB(0x666666);
    [self addSubview:self.numberLabel];
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
        buttonFrame.size.width += 24.f;
        buttonFrame.origin.x = rowWidth;
        button.frame = buttonFrame;
        button.tag = [self.tabNameList indexOfObject:name];
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
    tabBarFrame.origin.y = VIEW_HEIGHT - TABBAR_MARGIN_BOTTOM - TABBAR_HEIGHT;
    tabBarFrame.origin.x = (SH_SCREEN_WIDTH - rowWidth)/2.0;
    tabBarFrame.size.width = rowWidth;
    tabBarFrame.size.height = TABBAR_HEIGHT;
    self.tabBar.frame = tabBarFrame;
}


- (void)initBgLogoLabe
{
    self.topLogoLabe = [[UILabel alloc] init];
    self.topLogoLabe.font = [UIFont systemFontOfSize:12.0f];
    self.topLogoLabe.textColor = [UIColor blackColor];
    self.topLogoLabe.text = @"www.zhanshen666.com";
    [self.topLogoLabe sizeToFit];
    CGRect topFrame = self.topLogoLabe.frame;
    topFrame.origin.x = (SH_SCREEN_WIDTH - topFrame.size.width)/2.0;
    topFrame.origin.y = 54;
    self.topLogoLabe.frame = topFrame;
    self.topLogoLabe.enabled = NO;
    self.topLogoLabe.alpha = 0.7;
    self.topLogoLabe.hidden = YES;
    [self addSubview:self.topLogoLabe];
    
    self.bgLogoLabe = [[UILabel alloc] init];
    self.bgLogoLabe.font = [UIFont systemFontOfSize:13.0f];
    self.bgLogoLabe.textColor = [UIColor blackColor];
    self.bgLogoLabe.text = @"www.zhanshen666.com";
    [self.bgLogoLabe sizeToFit];
    CGRect frame = self.bgLogoLabe.frame;
    frame.origin.x = (SH_SCREEN_WIDTH - frame.size.width)/2.0;
    frame.origin.y = CGRectGetMinY(self.tabBar.frame) - 23;
    self.bgLogoLabe.frame = frame;
    self.bgLogoLabe.enabled = NO;
    self.bgLogoLabe.alpha = 0.3;
    self.bgLogoLabe.hidden = YES;
    [self addSubview:self.bgLogoLabe];
}

- (void)tabButtonTap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int region = [[self.tabRegionList objectAtIndex:button.tag] intValue];
    if (region > 20) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(maxRegionTab:)]) {
            [self.delegate maxRegionTab:region];
        }
        return;
    }
    if (self.tabSelectButton == button) {
        return;
    }
    [self updateChartView];
}

- (void)updateTabButton:(UIButton *)button
{
    self.tabSelectButton.backgroundColor = [UIColor whiteColor];
    self.tabSelectButton.selected = NO;
    self.tabSelectButton = button;
    self.tabSelectButton.backgroundColor = FMColorWithRGB0X(0xefefef);
    self.tabSelectButton.selected = YES;
    self.currentRegion = [[self.tabRegionList objectAtIndex:self.tabSelectButton.tag] intValue];
}

- (void)updateChartView
{
    [self.chartView removeFromSuperview];
    self.chartView = [[ZCChartlineView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numberLabel.frame) + 10, SH_SCREEN_WIDTH, CHARTVIEW_HEIGHT)];
    self.chartView.zcchartDelegate = self;
    self.chartView.showAssistLineWidth = 1.5f;
    self.chartView.lineWith = 1.5f;
    [self addSubview:self.chartView];
    if (self.winnerList.count > 0) {
        NSMutableArray *xList = [[NSMutableArray alloc] init];
        NSMutableArray *rankList = [[NSMutableArray alloc] init];
        NSMutableArray *showXist = [[NSMutableArray alloc] init];
        self.winnerOrderList = [[NSMutableArray alloc] init];
        for (int i=0; i< MIN(self.winnerList.count, self.currentRegion); i++) {
            DBZSWinnerModel *winner = [self.winnerList objectAtIndex:i];
            [showXist addObject:winner];
        }
        self.winnerOrderList = [[showXist reverseObjectEnumerator] allObjects];
        for (int i=0; i < self.winnerOrderList.count; i++) {
            DBZSWinnerModel *winner = [self.winnerOrderList objectAtIndex:i];
            if (winner.time_id.length > 4) {
                [xList addObject:[winner.time_id substringFromIndex:winner.time_id.length - 4]];
            }else{
                [xList addObject: winner.time_id];
            }
            [rankList addObject:@(winner.rank)];
        }
        self.chartView.x_title = xList;
        self.chartView.y_title = rankList;
        self.chartView.xRegionCount = self.currentRegion;
        [self.chartView strokeLine];
    }
}

- (void)configUser:(DBZSWinnerModel *)winner
{
    self.dateLabel.text = [NSString stringWithFormat:@"第%@期   投注位置：%d",SAFE_STRING(winner.time_id), winner.rank];
    [self.dateLabel sizeToFit];
    CGRect dateLabelFrame = self.dateLabel.frame;
    dateLabelFrame.origin.x = (SH_SCREEN_WIDTH - dateLabelFrame.size.width)/2.0;
    dateLabelFrame.origin.y = DATELABEL_MARIN_TOP;
    self.dateLabel.frame = dateLabelFrame;
    
    self.numberLabel.text = [NSString stringWithFormat:@"中奖号码：%@  中奖者：%@",SAFE_STRING(winner.win_number), SAFE_STRING(winner.win_username)];
    [self.numberLabel sizeToFit];
    CGRect numberLabelFrame = self.numberLabel.frame;
    numberLabelFrame.origin.x = (SH_SCREEN_WIDTH - numberLabelFrame.size.width)/2.0;
    numberLabelFrame.origin.y = CGRectGetMaxY(dateLabelFrame) + NUMBERLABEL_MARGIN_TOP;
    self.numberLabel.frame = numberLabelFrame;
}

- (void)configData:(NSArray *)winnerList
{
    if (self.winnerList != winnerList) {
        self.winnerList = winnerList;
        [self configUser:[self.winnerList lastObject]];
        [self updateChartView];
        self.bgLogoLabe.hidden = NO;
        self.topLogoLabe.hidden = NO;
    }
}

#pragma mark ZCChartlineViewDelegate

- (void)zCChartlineViewSelect:(NSInteger)index
{
    if (index < self.winnerOrderList.count -1) {
        DBZSWinnerModel *obj = [self.winnerOrderList objectAtIndex:index];
        [self configUser:obj];
    }
}

@end
