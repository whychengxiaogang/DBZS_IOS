//
//  DBZSService.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/11.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBZSService : NSObject

//功能：获取热门商品
+ (NSURLSessionDataTask *)hotPostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;

//功能：获取最新上架商品
+ (NSURLSessionDataTask *)getNewPostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;

//功能：获取商品详情页
+ (NSURLSessionDataTask *)detailPostsWithBlock:(int)product_id block:(void (^)(DBZSProductModel *product, DBZSNowModel *now, NSArray *posts, NSError *error))block;

//功能：获取所有获奖记录
+ (NSURLSessionDataTask *)winnerPostsWithBlock:(int)product_id block:(void (^)(NSArray *posts, NSError *error))block;

//功能：关键字搜索
+ (NSURLSessionDataTask *)keywordPostsWithBlock:(NSString *)keyword block:(void (^)(NSArray *posts, NSError *error))block;

//功能：获取进度
+ (NSURLSessionDataTask *)nowPostsWithBlock:(int)product_id block:(void (^)(DBZSNowModel *now, NSError *error))block;

//功能：区间
+ (NSURLSessionDataTask *)regionPostsWithBlock:(int)product_id block:(void (^)(NSDictionary *posts, NSError *error))block;

@end
