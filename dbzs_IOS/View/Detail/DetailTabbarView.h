//
//  DetailTabbarView.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/12.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailTabbarViewDelegate;

@interface DetailTabbarView : UIView

@property (nonatomic, weak) id<DetailTabbarViewDelegate> delegate;

- (void)showRegion:(int)region;

@end

@protocol DetailTabbarViewDelegate <NSObject>

- (void)tabbarTab:(int)region;

@end