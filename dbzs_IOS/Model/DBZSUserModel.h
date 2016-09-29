//
//  DBZSUserModel.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/16.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 用户
 */
@interface DBZSUserModel : NSObject

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userWeb;
@property (nonatomic, strong) NSString *ou_token;
@property (nonatomic, strong) NSString *cashier_token;
@property (nonatomic, assign) int buynum;
@property (nonatomic, assign) float coinbalance;
@property (nonatomic, assign) float coinlock;
@property (nonatomic, assign) float pid;
@property (nonatomic, assign) BOOL loginSuccess;

- (id)initWithNetEase;

- (id)initWithYunGou;

+ (void)setNetEaseStorage:(NSString *)value key:(NSString *)key;

+ (NSString *)getNetEaseStorage:(NSString *)key;

+ (void)setYunGouStorage:(NSString *)value key:(NSString *)key;

+ (NSString *)getYunGouStorage:(NSString *)key;

@end



