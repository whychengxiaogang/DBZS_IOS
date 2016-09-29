//
//  DetailGoodsInfoViewCell.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/11.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DetailGoodsInfoViewCell.h"

#define CELL_HEIGHT                 140.0f
#define NAME_MARGIN_LFTT            18.0f
#define NAME_MARGIN_RIGHT           20.0f
#define NAME_MARGIN_TOP             20.0f
#define PROGRESS_MARGIN_TOP         17.0f
#define PROGRESS_HEIGHT             8.0f
#define NUMVIEW_MARGIN_TOP          12.0f
#define TITLE_MARGIN_TOP            6.0f

@interface DetailGoodsInfoViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *qishuLabel;
@property (nonatomic, strong) UIImageView *progressImageView;
@property (nonatomic, strong) UIView *progressGrayView;
@property (nonatomic, strong) UIView *numView;
@property (nonatomic, strong) DBZSProductModel *product;
@property (nonatomic, strong) UILabel *joinTimesLabel;
@property (nonatomic, strong) UILabel *totalTimesLabel;
@property (nonatomic, strong) UILabel *remainTimesLabel;
@property (nonatomic, strong) UILabel *joinLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *remainLabel;

@end

@implementation DetailGoodsInfoViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.nameLabel];
    
    self.qishuLabel = [[UILabel alloc] init];
    self.qishuLabel.font = [UIFont boldSystemFontOfSize:10.0f];
    self.qishuLabel.textColor = UIColorFromRGB(0x666666);
    [self.contentView addSubview:self.qishuLabel];
    
    self.progressGrayView = [[UIView alloc] init];
    self.progressGrayView.layer.cornerRadius = PROGRESS_HEIGHT/2.0;
    self.progressGrayView.backgroundColor = FMColorWithRGB0X(0xe2e2e2);
    self.progressGrayView.clipsToBounds = YES;
    [self.contentView addSubview:self.progressGrayView];
    
    self.progressImageView = [[UIImageView alloc] init];
    self.progressImageView.image = [UIImage imageNamed:@"detail_progress"];
    [self.contentView addSubview:self.progressImageView];

    self.numView = [[UIView alloc] init];
    [self.contentView addSubview:self.numView];
    
    [self initNumView];
}

- (void)initNumView
{
    [self.numView removeAllSubViews];
    self.joinLabel = [self factoryTitleLabel:@"已参与次数"];
    CGRect joinFrame = self.joinLabel.frame;
    joinFrame.origin.x = 30.0f;
    joinFrame.origin.y = CELL_HEIGHT - joinFrame.size.height - 13.0f;
    self.joinLabel.frame = joinFrame;

    self.remainLabel = [self factoryTitleLabel:@"剩余人数"];
    CGRect remainFrame = self.remainLabel.frame;
    remainFrame.origin.x = SH_SCREEN_WIDTH - remainFrame.size.width - 30.0f;
    remainFrame.origin.y = joinFrame.origin.y;
    self.remainLabel.frame = remainFrame;
    
    self.totalLabel = [self factoryTitleLabel:@"总需人数"];
    CGRect totalFrame = self.totalLabel.frame;
    totalFrame.origin.x = (SH_SCREEN_WIDTH - totalFrame.size.width)/2.0;
    totalFrame.origin.y = joinFrame.origin.y;
    self.totalLabel.frame = totalFrame;
    
    self.joinTimesLabel = [self factoryTimesLabel];
    self.totalTimesLabel = [self factoryTimesLabel];
    self.remainTimesLabel = [self factoryTimesLabel];
}

- (UILabel *)factoryTimesLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.textColor = UIColorFromRGB(0xffa500);
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    return label;
}

- (UILabel *)factoryTitleLabel:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:11.0f];
    label.textColor = UIColorFromRGB(0x999999);
    label.text = title;
    [label  sizeToFit];
    [self.contentView addSubview:label];
    return label;
}

- (void)configTimesLabel:(DBZSNowModel *)now
{
    self.joinTimesLabel.text = [NSString stringWithFormat:@"%d",now.join_times];
    [self.joinTimesLabel sizeToFit];
    self.joinTimesLabel.center = CGPointMake(self.joinLabel.center.x, self.joinLabel.center.y - 20);
    self.totalTimesLabel.text = [NSString stringWithFormat:@"%d",now.total_times];
    [self.totalTimesLabel sizeToFit];
    self.totalTimesLabel.center = CGPointMake(self.totalLabel.center.x, self.totalLabel.center.y - 20);
    self.remainTimesLabel.text = [NSString stringWithFormat:@"%d",now.remain_times];
    [self.remainTimesLabel sizeToFit];
    self.remainTimesLabel.center = CGPointMake(self.remainLabel.center.x, self.remainLabel.center.y - 20);
}

#pragma mark public

- (void)configData:(DBZSProductModel *)product now:(DBZSNowModel *)now;
{
    if (self.product != product) {
        self.product = product;
        self.nameLabel.text = product.title;
        [self.nameLabel sizeToFit];
        CGRect nameFrame = self.nameLabel.frame;
        nameFrame.origin.x = NAME_MARGIN_LFTT;
        nameFrame.origin.y = NAME_MARGIN_TOP;
        self.nameLabel.frame = nameFrame;
        
        self.qishuLabel.text = [NSString stringWithFormat:@"%@期",now.time_id];
        [self.qishuLabel sizeToFit];
        CGRect qishuLabelFrame = self.qishuLabel.frame;
        qishuLabelFrame.origin.x = NAME_MARGIN_LFTT;
        qishuLabelFrame.origin.y = CGRectGetMaxY(self.nameLabel.frame) + 5;
        self.qishuLabel.frame = qishuLabelFrame;
        
        CGRect grayProgressFrame = self.progressGrayView.frame;
        grayProgressFrame.size.width = SH_SCREEN_WIDTH - NAME_MARGIN_LFTT - NAME_MARGIN_RIGHT;
        grayProgressFrame.size.height = PROGRESS_HEIGHT;
        grayProgressFrame.origin.x = NAME_MARGIN_LFTT;
        grayProgressFrame.origin.y = CGRectGetMaxY(self.qishuLabel.frame) + PROGRESS_MARGIN_TOP;
        self.progressGrayView.frame = grayProgressFrame;
        
        CGRect progressImageFrame = grayProgressFrame;
        progressImageFrame.size.width = 0;
        self.progressImageView.frame = progressImageFrame;
        [UIView animateWithDuration:0.8 animations:^{
            CGRect progressImageFrame = grayProgressFrame;
            progressImageFrame.size.width = now.total_times>0?(grayProgressFrame.size.width*now.join_times)/now.total_times:0.0f;
            self.progressImageView.frame = progressImageFrame;
        }];
        [self configTimesLabel:now];
    }
}

- (void)updateCell:(DBZSNowModel *)now
{
    CGRect progressImageFrame = self.progressImageView.frame;
    progressImageFrame.size.width = now.total_times>0?(self.progressGrayView.frame.size.width*now.join_times)/now.total_times:0.0f;
    self.progressImageView.frame = progressImageFrame;
    [self configTimesLabel:now];
}

+ (CGFloat)calCellHeight
{
    return CELL_HEIGHT;
}

@end
