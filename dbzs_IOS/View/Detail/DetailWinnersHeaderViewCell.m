//
//  DetailWinnersHeaderViewCell.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/11.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DetailWinnersHeaderViewCell.h"

#define CELL_HEIGHT                 20.0f
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

@interface DetailWinnersHeaderViewCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *winnerLabel;
@property (nonatomic, strong) UILabel *winNumberLabel;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *buyLabel;
@property (nonatomic, strong) UILabel *regionLabel;

@end

@implementation DetailWinnersHeaderViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.backgroundColor = FMColorWithRGB0X(0xf04848);
    CGFloat nameWidth = SH_SCREEN_WIDTH - QUJIAN_WIDTH - MAIRU_WIDTH - WEIZI_WIDTH - HAOMA_WIDTH - QISHU_WIDTH;
    [self factoryLabel:@"期数" width:QISHU_WIDTH xOff:0 alignment:NSTextAlignmentRight];
    [self factoryLabel:@"中奖人" width:nameWidth-15 xOff:(DATE_WIDTH + 15) alignment:NSTextAlignmentLeft];
    [self factoryLabel:@"中奖号码" width:HAOMA_WIDTH xOff:(QISHU_WIDTH + nameWidth) alignment:NSTextAlignmentLeft];
    [self factoryLabel:@"位置" width:WEIZI_WIDTH xOff:(QISHU_WIDTH + nameWidth + HAOMA_WIDTH) alignment:NSTextAlignmentCenter];
    [self factoryLabel:@"买入" width:MAIRU_WIDTH xOff:(SH_SCREEN_WIDTH - MAIRU_WIDTH - QUJIAN_WIDTH) alignment:NSTextAlignmentCenter];
    [self factoryLabel:@"区间" width:QUJIAN_WIDTH xOff:(SH_SCREEN_WIDTH - QUJIAN_WIDTH) alignment:NSTextAlignmentCenter];
}

- (void)factoryLabel:(NSString *)title width:(CGFloat)width xOff:(CGFloat)xOff alignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xOff, 0, width, CELL_HEIGHT)];
    label.font = [UIFont systemFontOfSize:10.0f];
    label.textColor = UIColorFromRGB(0xffffff);
    label.textAlignment = alignment;
    label.text = title;
    [self.contentView addSubview:label];
}

+ (CGFloat)calCellHeight
{
    return CELL_HEIGHT;
}

@end
