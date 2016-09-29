//
//  GoodsKeyWordViewCell.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/17.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsKeyWordViewCellDelegate;

@interface GoodsKeyWordViewCell : UICollectionViewCell

@property (nonatomic, weak) id<GoodsKeyWordViewCellDelegate> delegate;

- (void)configData:(NSString *)title;

- (void)showClose;

+ (CGSize)calCellSize:(NSString *)title;

@end

@protocol GoodsKeyWordViewCellDelegate <NSObject>

- (void)keywordTaped:(NSString *)keyword;

@end
