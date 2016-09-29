//
//  LandscapeRightView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/12.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "LandscapeRightView.h"
#import "ZCChartlineView.h"

@interface LandscapeRightView ()<ZCChartlineViewDelegate>

@property (nonatomic, strong) UILabel *winnerLabel;
@property (nonatomic, strong) ZCChartlineView *chartView;
@property (nonatomic, strong) NSArray *winnerList;
@property (nonatomic, assign) int currentRegion;
@property (nonatomic, strong) NSArray *winnerOrderList;

@end

@implementation LandscapeRightView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, MAX(SH_SCREEN_HEIGHT, SH_SCREEN_WIDTH), MIN(SH_SCREEN_HEIGHT, SH_SCREEN_WIDTH));
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.winnerLabel = [[UILabel alloc] init];
    self.winnerLabel.font = [UIFont systemFontOfSize:11.0f];
    self.winnerLabel.textColor = UIColorFromRGB(0x666666);
    [self addSubview:self.winnerLabel];
}

- (void)updateChartView
{
    [self.chartView removeFromSuperview];
    self.chartView = [[ZCChartlineView alloc] initWithFrame:CGRectMake(0, 40 + 64.0f, self.frame.size.width, self.frame.size.height)];
    self.chartView.zcchartDelegate = self;
    self.chartView.showAssistLineWidth = 1.5f;
    self.chartView.lineWith = 1.5f;
    self.chartView.rowSpace = (self.frame.size.height -  40 - 64.0f - 60.0f)/self.chartView.rowCount;
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

- (void)configWinner:(DBZSWinnerModel *)winner
{
    self.winnerLabel.text = [NSString stringWithFormat:@"第%@期   投注位置：%d   中奖号码：%@  中奖者：%@",SAFE_STRING(winner.time_id), winner.rank, SAFE_STRING(winner.win_number), SAFE_STRING(winner.win_username)];
    [self.winnerLabel sizeToFit];
    CGRect frame = self.winnerLabel.frame;
    frame.origin.x = (self.frame.size.width - frame.size.width)/2.0;
    frame.origin.y = 64.0f + 20.0f;
    self.winnerLabel.frame = frame;
}

#pragma mark public

- (void)configData:(NSArray *)winnerList
{
    self.winnerList = winnerList;
    DBZSWinnerModel *winner = [winnerList lastObject];
    [self configWinner:winner];
}

- (void)showRegion:(int)region
{
    self.currentRegion = region;
    [self updateChartView];
}

#pragma mark ZCChartlineViewDelegate

- (void)zCChartlineViewSelect:(NSInteger)index
{
    if (index < self.winnerOrderList.count -1) {
        DBZSWinnerModel *winner = [self.winnerOrderList objectAtIndex:index];
        [self configWinner:winner];
    }
}

@end
