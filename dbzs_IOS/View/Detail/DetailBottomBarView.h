//
//  DetailBottomBarView.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/13.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailBottomBarViewDelegate;

@interface DetailBottomBarView : UIView

@property (nonatomic, weak) id<DetailBottomBarViewDelegate> delegate;

- (void)showLogin;

- (void)showAccountInfo;

@end

@protocol DetailBottomBarViewDelegate <NSObject>

- (void)loginButtonTab;

- (void)orderButtonTab;

@end
