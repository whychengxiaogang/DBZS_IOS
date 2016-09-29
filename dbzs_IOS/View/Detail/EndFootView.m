//
//  EndFootView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/13.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "EndFootView.h"

#define VIEW_HEIGHT         28.0f

@interface EndFootView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation EndFootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SH_SCREEN_WIDTH, VIEW_HEIGHT);
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.textLabel.font = [UIFont systemFontOfSize:12.0f];
    self.textLabel.textColor = UIColorFromRGB(0x999999);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.text = @"--end--";
    [self addSubview:self.textLabel];
}

@end
