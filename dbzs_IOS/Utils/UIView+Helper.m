//
//  UIView+Helper.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/11.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

- (void)removeAllSubViews
{
    for(UIView * subView in self.subviews){
        [subView removeFromSuperview];
    }
}

@end
