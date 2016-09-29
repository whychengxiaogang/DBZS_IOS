//
//  DetailChartView.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/13.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailChartViewDelegate;

@interface DetailChartView : UIView

@property (nonatomic, weak) id<DetailChartViewDelegate> delegate;

- (void)configData:(NSArray *)winnerList;

@end

@protocol DetailChartViewDelegate <NSObject>

- (void)maxRegionTab:(int)region;

@end