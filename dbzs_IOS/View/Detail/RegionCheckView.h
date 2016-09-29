//
//  RegionCheckView.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/13.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegionCheckViewDelegate;

@interface RegionCheckView : UIView

@property (nonatomic, weak) id<RegionCheckViewDelegate> delegate;

- (void)updateCheckLabel:(int)region;

@end

@protocol RegionCheckViewDelegate <NSObject>

- (void)regionCheckButtonTab;

@end
