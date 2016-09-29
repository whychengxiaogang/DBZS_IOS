//
//  SearchGoodsViewCell.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/10.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchGoodsViewCellDelegate;

@interface SearchGoodsViewCell : UITableViewCell

@property (nonatomic, weak) id<SearchGoodsViewCellDelegate> delegate;

- (void)configData:(DBZSProductModel *)product;

+ (CGFloat)calCellHeight;

@end

@protocol SearchGoodsViewCellDelegate <NSObject>

- (void)goodsTap:(int)productId;

@end
