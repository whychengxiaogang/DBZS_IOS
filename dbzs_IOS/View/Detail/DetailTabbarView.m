//
//  DetailTabbarView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/12.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DetailTabbarView.h"

#define VIEW_HEIGHT             25.0f

@interface DetailTabbarView ()

@property (nonatomic, strong) NSArray *tabNameList;
@property (nonatomic, strong) NSArray *tabRegionList;
@property (nonatomic, assign) int currentRegion;
@property (nonatomic, strong) UIButton *tabSelectButton;
@property (nonatomic, strong) NSMutableArray *tabButtonList;

@end

@implementation DetailTabbarView

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
    self.tabButtonList = [[NSMutableArray alloc] initWithCapacity:3];
    self.tabNameList = @[@"近30期",@"近50期",@"近100期"];
    self.tabRegionList = @[@30, @50, @100];
    self.layer.cornerRadius = 5.0f;
    self.layer.borderColor = FMColorWithRGB0X(0xefefef).CGColor;
    self.layer.borderWidth = 1.0f;
    self.clipsToBounds = YES;
    CGFloat rowWidth = 0;
    for (NSString *name in self.tabNameList) {
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setTitle:name forState:UIControlStateNormal];
        [self showNormalStatus:button];
        [button addTarget:self action:@selector(tabButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        CGRect buttonFrame = button.frame;
        buttonFrame.size.height = VIEW_HEIGHT;
        buttonFrame.size.width += 26.f;
        buttonFrame.origin.x = rowWidth;
        button.frame = buttonFrame;
        button.tag = [self.tabNameList indexOfObject:name];
        [self addSubview:button];
        [self.tabButtonList addObject:button];
        if ([self.tabNameList indexOfObject:name] < (self.tabNameList.count - 1)) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = FMColorWithRGB0X(0xffffff);
            CGRect lineFrame = line.frame;
            lineFrame.origin.x = CGRectGetMaxX(button.frame);
            lineFrame.size.height = VIEW_HEIGHT;
            lineFrame.size.width = 1.0f;
            line.frame = lineFrame;
            [self addSubview:line];
            rowWidth += 1.0f;
        }
        rowWidth += buttonFrame.size.width;
    }
    self.frame = CGRectMake(0, 0, rowWidth, VIEW_HEIGHT);
}

- (void)tabButtonTap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (self.tabSelectButton == button) {
        return;
    }
    [self updateTabButton:button];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbarTab:)]) {
        [self.delegate tabbarTab:self.currentRegion];
    }
}

- (void)updateTabButton:(UIButton *)button
{
    [self showNormalStatus:self.tabSelectButton];
    self.tabSelectButton = button;
    [self showLightStatus:self.tabSelectButton];
    self.currentRegion = [[self.tabRegionList objectAtIndex:self.tabSelectButton.tag] intValue];
}

- (void)showLightStatus:(UIButton *)button
{
    button.selected = YES;
    button.backgroundColor = FMColorWithRGB0X(0xffffff);
    [button setTitleColor:FMColorWithRGB0X(0xf04848) forState:UIControlStateSelected];
    [button setTitleColor:FMColorWithRGB0X(0xf04848) forState:UIControlStateNormal];
    [button setTitleColor:FMColorWithRGB0X(0xf04848) forState:UIControlStateHighlighted];
}
- (void)showNormalStatus:(UIButton *)button
{
    button.selected = NO;
    button.backgroundColor = FMColorWithRGB0X(0xf04848);
    [button setTitleColor:FMColorWithRGB0X(0xf04848) forState:UIControlStateSelected];
    [button setTitleColor:FMColorWithRGB0X(0xffffff) forState:UIControlStateNormal];
    [button setTitleColor:FMColorWithRGB0X(0xffffff) forState:UIControlStateHighlighted];
}

#pragma mark public

- (void)showRegion:(int)region
{
    NSInteger index = [self.tabRegionList indexOfObject:@(region)] ;
    self.tabSelectButton = [self.tabButtonList objectAtIndex:index];
    [self showLightStatus: self.tabSelectButton];
}

@end
