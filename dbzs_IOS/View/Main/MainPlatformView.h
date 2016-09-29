//
//  MainPlatformView.h
//  ;
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainPlatformViewDelegate;

@interface MainPlatformView : UIView

@property (nonatomic, weak) id<MainPlatformViewDelegate> delegate;

- (void)configData:(PLATFORM_TYPE)platformType;

+ (CGFloat)calcHeight;

@end

@protocol MainPlatformViewDelegate <NSObject>

- (void)tabButtonTaped:(PLATFORM_TYPE)platformType;

@end