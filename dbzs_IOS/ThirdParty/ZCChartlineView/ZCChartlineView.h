//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZCChartlineTypeBroken = 0,//broken line 折线
    ZCChartlineTypeCurve  //曲线
}  ZCChartlineType;


@protocol ZCChartlineViewDelegate;

@interface ZCChartlineView : UIScrollView


@property (nonatomic, weak) id<ZCChartlineViewDelegate> zcchartDelegate;

/**
 *  线条绘制设置
 */
@property (nonatomic,strong) NSArray <NSString *> *x_title;//设置 x 的轴的标签
@property (nonatomic,strong) NSArray <NSString *> *y_title;//设置 Y 的轴值
@property (nonatomic,assign) CGFloat lineWith;//设置绘制的线宽度

/**
 *  字体设置
 */

@property (nonatomic,assign) CGFloat showAssistLineWidth;//设置是否显示图表中的辅助横线的宽度
@property (nonatomic,assign) ZCChartlineType lintype;//设置直线的类型(曲线/折线)
@property (nonatomic,assign) int xRegionCount; // 设置x轴区间个数
@property (nonatomic,assign) CGFloat rowCount; // 设置Y轴区间个数
@property (nonatomic,assign) CGFloat rowSpace; // 设置Y轴区间间距

/**
 *  绘制折线
 */
-(void)strokeLine;

@end

@protocol ZCChartlineViewDelegate <NSObject>

- (void)zCChartlineViewSelect:(NSInteger)index;

@end
