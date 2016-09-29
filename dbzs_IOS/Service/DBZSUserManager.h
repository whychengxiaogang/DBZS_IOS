//
//  DBZSUserManager.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/12.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBZSUserManager : NSObject

@property (nonatomic, assign) PLATFORM_TYPE currentPlatform;
@property (nonatomic, strong) DBZSNowModel *currentNow;
@property (nonatomic, strong) DBZSUserModel *currentUser;

@property (nonatomic, strong) DBZSUserModel *netEaseUser;
@property (nonatomic, strong) DBZSUserModel *yunGouUser;

+ (instancetype)shareInstance;

+ (void)saveCookies:(NSString *)key;

+ (void)loadCookies:(NSString *)key;

+ (void)cleanCookies;

@end
