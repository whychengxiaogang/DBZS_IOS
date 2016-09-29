//
//  NSDate+Helper.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/16.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate(helper)

+ (NSString *)timeString
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];
    return timeString;
}

+ (NSString *)timeStringMsec:(double)msec
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a= [dat timeIntervalSince1970]*1000 + msec;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];
    return timeString;
}

@end
