//
//  AppDelegate.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DBZSBaseNavigationViewController.h"
#import "SVProgressHUD.h"
#import "UIImage+Helper.h"
#import <UMMobClick/MobClick.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [NSThread sleepForTimeInterval:1.0];//延长启动页面时间
    MainViewController *main = [[MainViewController alloc] init];
    UINavigationController *nav = [[DBZSBaseNavigationViewController alloc] initWithRootViewController:main];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xf02828)];
    [navigationBarAppearance setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    
    //友盟统计SDK
    UMConfigInstance.appKey = @"57d58a0267e58e3423003758";
    UMConfigInstance.channelId = @"appStore";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
