//
//  LoadMoreFootView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/13.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "LoadMoreFootView.h"

#define VIEW_HEIGHT             45.0f
#define ICON_WIDTH              18.0f
#define ICON_HEIGHT             18.5f

@interface LoadMoreFootView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, assign) CGFloat angle;

@end

@implementation LoadMoreFootView

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
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = [UIFont systemFontOfSize:12.0f];
    self.textLabel.textColor = UIColorFromRGB(0x999999);
    self.textLabel.text = @"加载中...";
    [self.textLabel sizeToFit];
    [self addSubview:self.textLabel];
    
    self.loadingImageView = [[UIImageView alloc] init];
    self.loadingImageView.image = [UIImage imageNamed:@"icon_loading"];
    [self addSubview:self.loadingImageView];
    [self startAnimation];
    
    CGFloat margin = (SH_SCREEN_WIDTH - ICON_WIDTH - 15.0f - self.textLabel.frame.size.width)/2.0;
    CGRect imageFrame = self.loadingImageView.frame;
    imageFrame.size = CGSizeMake(ICON_WIDTH, ICON_HEIGHT);
    imageFrame.origin.x = margin;
    imageFrame.origin.y = (VIEW_HEIGHT - ICON_HEIGHT)/2.0;
    self.loadingImageView.frame = imageFrame;
    
    CGRect labelFrame = self.textLabel.frame;
    labelFrame.origin.x = margin + ICON_WIDTH + 5;
    labelFrame.origin.y = (VIEW_HEIGHT - labelFrame.size.height)/2.0;
    self.textLabel.frame = labelFrame;
}

-(void)startAnimation
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(self.angle * (M_PI /180.0f));
    [UIView animateWithDuration:0.02 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.loadingImageView.transform = endAngle;
    } completion:^(BOOL finished) {
        self.angle += 15;
        [self startAnimation];
    }];
}


@end
