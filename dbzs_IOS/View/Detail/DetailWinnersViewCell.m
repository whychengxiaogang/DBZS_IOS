//
//  DetailWinnersViewCell.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/11.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DetailWinnersViewCell.h"

#define CELL_HEIGHT                 27.0f
#define DATE_WIDTH                  40.0f
#define WINDNUMBER_WIDTH            60.0f
#define RANK_WIDTH                  40.0f
#define BUY_WIDTH                   40.0f
#define REGION_WIDTH                50.0f
#define QUJIAN_WIDTH                50.0
#define MAIRU_WIDTH                 38.0f
#define WEIZI_WIDTH                 38.0f
#define HAOMA_WIDTH                 58.0f
#define QISHU_WIDTH                 43.0f

@interface DetailWinnersViewCell ()

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *paneView;

@end

@implementation DetailWinnersViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.paneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SH_SCREEN_WIDTH, CELL_HEIGHT)];
    [self.contentView addSubview:self.paneView];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT - 0.5f, SH_SCREEN_WIDTH, 0.5)];
    self.line.backgroundColor = FMColorWithRGB0X(0xeeeeee);
    [self.contentView addSubview:self.line];
}

- (void)configData:(DBZSWinnerModel *)winner
{
    [self.paneView removeAllSubViews];
    CGFloat nameWidth = SH_SCREEN_WIDTH - QUJIAN_WIDTH - MAIRU_WIDTH - WEIZI_WIDTH - HAOMA_WIDTH - QISHU_WIDTH;
    NSString *time_id = winner.time_id;
    if (winner.time_id.length > 4) {
        time_id =[winner.time_id substringFromIndex:winner.time_id.length - 4];
    }
    UIColor *black = FMColorWithRGB0X(0x999999);
    UIColor *red = FMColorWithRGB0X(0xf04848);
    [self factoryLabel:time_id width:QISHU_WIDTH xOff:0 alignment:NSTextAlignmentRight color:black];
    [self factoryLabel:winner.win_username width:nameWidth-10 xOff:(QISHU_WIDTH + 10) alignment:NSTextAlignmentLeft color:black];
    [self factoryLabel:winner.win_number width:HAOMA_WIDTH xOff:(QISHU_WIDTH + nameWidth) alignment:NSTextAlignmentLeft color:red];
    [self factoryLabel:[NSString stringWithFormat:@"%d",winner.rank] width:WEIZI_WIDTH xOff:(QISHU_WIDTH + nameWidth + HAOMA_WIDTH) alignment:NSTextAlignmentCenter color:black];
    [self factoryLabel:[NSString stringWithFormat:@"%d",winner.win_bet_count] width:MAIRU_WIDTH xOff:(SH_SCREEN_WIDTH - MAIRU_WIDTH - QUJIAN_WIDTH) alignment:NSTextAlignmentCenter color:black];
    [self factoryLabel:winner.qujian width:QUJIAN_WIDTH xOff:(SH_SCREEN_WIDTH - QUJIAN_WIDTH) alignment:NSTextAlignmentCenter color:red];
}
static int i;
- (void)factoryLabel:(NSString *)title width:(CGFloat)width xOff:(CGFloat)xOff alignment:(NSTextAlignment)alignment color:(UIColor *)color
{
    i++;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xOff, 0, width, CELL_HEIGHT)];
    label.font = [UIFont systemFontOfSize:10.0f];
    label.textColor = color;
    label.textAlignment = alignment;
    label.text = title;
    [self.paneView addSubview:label];
}

+ (CGFloat)calCellHeight
{
    return CELL_HEIGHT;
}

@end
