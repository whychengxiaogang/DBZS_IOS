//
//  DetailGoodsInfoViewCell.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/11.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailGoodsInfoViewCell : UITableViewCell

- (void)configData:(DBZSProductModel *)product now:(DBZSNowModel *)now;

- (void)updateCell:(DBZSNowModel *)now;

+ (CGFloat)calCellHeight;

@end
