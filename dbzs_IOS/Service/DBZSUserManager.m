//
//  DBZSUserManager.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/12.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DBZSUserManager.h"

@implementation DBZSUserManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.netEaseUser = [[DBZSUserModel alloc] initWithNetEase];
        self.yunGouUser = [[DBZSUserModel alloc] initWithYunGou];
    }
    return self;
}

+ (instancetype)shareInstance
{
    static DBZSUserManager* g_userModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_userModule = [[DBZSUserManager alloc] init];
    });
    return g_userModule;
}

- (DBZSUserModel *)getCurrentUser
{
    if (self.currentPlatform == PLATFORM_TYPE_NETEASE) {
        return self.netEaseUser;
    }else {
        return self.yunGouUser;
    }
}

- (void)setCurrentPlatform:(PLATFORM_TYPE)currentPlatform
{
    _currentPlatform = currentPlatform;
    if (currentPlatform == PLATFORM_TYPE_NETEASE) {
        _currentUser = self.netEaseUser;
    }else if(currentPlatform == PLATFORM_TYPE_YUNGOU){
        _currentUser = self.yunGouUser;
    }
}

+ (void)saveCookies:(NSString *)key
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: [NSString stringWithFormat:@"%@_cookie",key]];
    [defaults synchronize];
}

+ (void)loadCookies:(NSString *)key
{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: [NSString stringWithFormat:@"%@_cookie",key]]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
}

+ (void)cleanCookies
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in cookieArray) {
        [cookieJar deleteCookie:obj];
    }
}

@end
