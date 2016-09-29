//
//  OrderConfirmView.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/17.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderConfirmViewDelegate;

@interface OrderConfirmView : UIView

@property (nonatomic, strong) id<OrderConfirmViewDelegate> delegate;

- (void)configData:(float)price;

@end

@protocol OrderConfirmViewDelegate <NSObject>

- (void)orderSubmit:(int)buyNum;

@end