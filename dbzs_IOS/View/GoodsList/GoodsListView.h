//
//  GoodsListView.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/17.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsListViewViewDelegate;

@interface GoodsListView : UIView

@property (nonatomic, weak) id<GoodsListViewViewDelegate> delegate;

- (void)configHotData:(NSArray *)hotData;

- (void)configLastNewData:(NSArray *)lastNewData;

- (void)reloadSearchKeyWord;

@end

@protocol GoodsListViewViewDelegate <NSObject>

- (void)searchKeyWordTap:(NSString *)keyWord;

- (void)goodsListViewGoodsTap:(int)productId;

- (void)goodsListViewMove;

@end