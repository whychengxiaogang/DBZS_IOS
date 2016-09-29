//
//  SearchResultView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/12.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "SearchResultView.h"

@implementation SearchResultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.backgroundColor = FMColorWithRGB0X(0xf3f3f3);
}

@end
