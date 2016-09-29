//
//  DBZSNotificationHelp.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/16.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DBZSNotificationHelp.h"

NSString* const DBZSNotificationNetEaseLogoinSuccess = @"DBZSNotification_logoin_success";
NSString* const DBZSNotificationNetEaseLogoinFai = @"DBZSNotification_logoin_fail";
NSString* const DBZSNotificationNetEaseLogoOut = @"DBZSNotificationLogoOut";
NSString* const DBZSNotificationNetEaseGetMoney = @"DBZSNotificationNetEaseGetMoney";
NSString* const DBZSNotificationNetEasePaysuccess = @"DBZSNotificationNetEasePaysuccess";
NSString* const DBZSNotificationNetEasePayFail = @"DBZSNotificationNetEasePayFail";

@implementation DBZSNotificationHelp

+ (void)postNotification:(NSString*)notification userInfo:(NSDictionary*)userInfo object:(id)object
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notification object:object userInfo:userInfo];
    });
}

@end
