//
//  DetailWinnersViewCell.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/11.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailWinnersViewCell : UITableViewCell

- (void)configData:(DBZSWinnerModel *)winner;

+ (CGFloat)calCellHeight;

@end
