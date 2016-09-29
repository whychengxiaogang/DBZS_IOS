//
//  DBZSNotificationHelp.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/16.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const DBZSNotificationNetEaseLogoinSuccess;
extern NSString* const DBZSNotificationNetEaseLogoinFai;
extern NSString* const DBZSNotificationNetEaseLogoOut;
extern NSString* const DBZSNotificationNetEaseGetMoney;
extern NSString* const DBZSNotificationNetEasePaysuccess;
extern NSString* const DBZSNotificationNetEasePayFail;

@interface DBZSNotificationHelp : NSObject

+ (void)postNotification:(NSString*)notification userInfo:(NSDictionary*)userInfo object:(id)object;

@end
