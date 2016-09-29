//
//  GoodsCardViewCell.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/17.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCardViewCell : UICollectionViewCell

@property (nonatomic, weak) id<GoodsViewDelegate> delegate;

- (void)configData:(DBZSProductModel *)model;

+ (CGSize)calCellSize:(DBZSProductModel *)model;

@end
