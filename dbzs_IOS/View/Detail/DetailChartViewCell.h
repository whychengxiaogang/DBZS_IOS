//
//  DetailChartViewCell.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/11.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailChartViewCellDelegate;

@interface DetailChartViewCell : UITableViewCell

@property (nonatomic, weak) id<DetailChartViewCellDelegate> delegate;

- (void)configData:(NSArray *)winnerList regionData:(NSDictionary *)regionData;

+ (CGFloat)calCellHeight;

@end

@protocol DetailChartViewCellDelegate <NSObject>

- (void)changeInterfaceOrientatio:(int)region;

- (void)showRegionView;

@end
