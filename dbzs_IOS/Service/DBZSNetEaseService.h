//
//  DBZSNetEaseService.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/16.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBZSNetEaseService : NSObject

+ (void)logout;

+ (void)login;

+ (void)loginWithPass:(NSString *)pass account:(NSString *)account;

+ (void)buy;

+ (void)getmoney;

@end
