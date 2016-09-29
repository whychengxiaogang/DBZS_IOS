//
//  DBZSUserModel.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/16.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DBZSUserModel.h"

@implementation DBZSUserModel

- (id)initWithNetEase
{
    if (self = [super init]) {
        self.password = [DBZSUserModel getNetEaseStorage:@"password"];
        self.accountName = [DBZSUserModel getNetEaseStorage:@"accountName"];
        self.userName = [DBZSUserModel getNetEaseStorage:@"userName"];
        self.userWeb = [DBZSUserModel getNetEaseStorage:@"userWeb"];
        self.userId = [DBZSUserModel getNetEaseStorage:@"userId"];
    }
    return self;
}

- (id)initWithYunGou
{
    if (self = [super init]) {
        self.password = [DBZSUserModel getYunGouStorage:@"password"];
        self.accountName = [DBZSUserModel getYunGouStorage:@"accountName"];
        self.userId = [DBZSUserModel getYunGouStorage:@"userId"];
    }
    return self;
}

+ (void)setNetEaseStorage:(NSString *)value key:(NSString *)key
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:[self netEaseKey:key]];
    [setting setObject:value forKey:[self netEaseKey:key]];
    [setting synchronize];
}

+ (NSString *)getNetEaseStorage:(NSString *)key
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *value = [setting objectForKey:[self netEaseKey:key]];
    if (value && [value isEqualToString:@""] == NO)
    {
        return value;
    }
    return nil;
}

+ (NSString *)netEaseKey:(NSString *)key
{
    return [NSString stringWithFormat:@"%@%@",StorageNetEasePre,key];
}

+ (void)setYunGouStorage:(NSString *)value key:(NSString *)key
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:[self yunGouKey:key]];
    [setting setObject:value forKey:[self yunGouKey:key]];
    [setting synchronize];
}

+ (NSString *)getYunGouStorage:(NSString *)key
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString *value = [setting objectForKey:[self yunGouKey:key]];
    if (value && [value isEqualToString:@""] == NO)
    {
        return value;
    }
    return nil;
}

+ (NSString *)yunGouKey:(NSString *)key
{
    return [NSString stringWithFormat:@"%@%@",StorageYunGouPre,key];
}

@end

