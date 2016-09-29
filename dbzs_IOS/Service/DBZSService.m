//
//  DBZSService.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/11.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DBZSService.h"
#import "AFAppDotNetAPIClient.h"
#import "NSDate+Helper.h"

@implementation DBZSService

static NSString *hotUrl = @"api/duobao/get_hot";
static NSString *getNewUrl = @"api/duobao/get_hot";
static NSString *detailUrl = @"api/duobao/shuju/product_id/";
static NSString *winnerUrl = @"api/duobao/winner/product_id/";
static NSString *keywordUrl = @"api/duobao/product/keyword/";
static NSString *nowUrl = @"api/duobao/jindu/product_id/";
static NSString *regionUrl = @"api/duobao/qujian/product_id/";

//功能：获取热门商品
+ (NSURLSessionDataTask *)hotPostsWithBlock:(void (^)(NSArray *posts, NSError *error))block
{
    return [[AFAppDotNetAPIClient sharedClient] GET:hotUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = JSON;
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            DBZSProductModel *post = [[DBZSProductModel alloc] initWithJson:attributes];
            [mutablePosts addObject:post];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

//功能：获取最新上架商品
+ (NSURLSessionDataTask *)getNewPostsWithBlock:(void (^)(NSArray *posts, NSError *error))block
{
    return [[AFAppDotNetAPIClient sharedClient] GET:getNewUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = JSON;
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            DBZSProductModel *post = [[DBZSProductModel alloc] initWithJson:attributes];
            [mutablePosts addObject:post];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

//功能：获取商品详情页
+ (NSURLSessionDataTask *)detailPostsWithBlock:(int)product_id block:(void (^)(DBZSProductModel *product, DBZSNowModel *now, NSArray *posts, NSError *error))block
{
    return [[AFAppDotNetAPIClient sharedClient] GET:[detailUrl stringByAppendingString:[NSString stringWithFormat:@"%d&t=%@",product_id, [NSDate timeString]]] parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSDictionary *postsFromResponse = JSON;
        NSArray *winner = [postsFromResponse safeObjectForKey:@"win"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[winner count]];
        for (NSDictionary *attributes in winner) {
            DBZSWinnerModel *post = [[DBZSWinnerModel alloc] initWithJson:attributes];
            [mutablePosts addObject:post];
        }
        DBZSProductModel *product = [[DBZSProductModel alloc] initWithJson:[postsFromResponse safeObjectForKey:@"product"]];
        DBZSNowModel *now = [[DBZSNowModel alloc] initWithJson:[postsFromResponse safeObjectForKey:@"now"]];
        if (block) {
            block(product, now, [NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, nil, [NSArray array], error);
        }
    }];
}

//功能：获取所有获奖记录
+ (NSURLSessionDataTask *)winnerPostsWithBlock:(int)product_id block:(void (^)(NSArray *posts, NSError *error))block
{
    return [[AFAppDotNetAPIClient sharedClient] GET:[winnerUrl stringByAppendingString:[NSString stringWithFormat:@"%d",product_id]] parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = JSON;
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            DBZSWinnerModel *post = [[DBZSWinnerModel alloc] initWithJson:attributes];
            [mutablePosts addObject:post];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

//功能：关键字搜索
+ (NSURLSessionDataTask *)keywordPostsWithBlock:(NSString *)keyword block:(void (^)(NSArray *posts, NSError *error))block
{
    NSString *encodingUrl = [[keywordUrl stringByAppendingString:keyword] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    return [[AFAppDotNetAPIClient sharedClient] GET:encodingUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *postsFromResponse = JSON;
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            DBZSProductModel *post = [[DBZSProductModel alloc] initWithJson:attributes];
            [mutablePosts addObject:post];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

//功能：获取进度
+ (NSURLSessionDataTask *)nowPostsWithBlock:(int)product_id block:(void (^)(DBZSNowModel *now, NSError *error))block
{
    return [[AFAppDotNetAPIClient sharedClient] GET:[nowUrl stringByAppendingString:[NSString stringWithFormat:@"%d",product_id]] parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSDictionary *postsFromResponse = JSON;
        DBZSNowModel *model = [[DBZSNowModel alloc] initWithJson:postsFromResponse];
        if (block) {
            block(model, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

//功能：区间
+ (NSURLSessionDataTask *)regionPostsWithBlock:(int)product_id block:(void (^)(NSDictionary *posts, NSError *error))block
{
    return [[AFAppDotNetAPIClient sharedClient] GET:[regionUrl stringByAppendingString:[NSString stringWithFormat:@"%d",product_id]] parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSDictionary *postsFromResponse = JSON;
        NSDictionary *qujian = [postsFromResponse safeObjectForKey:@"qujian"];
        if (block) {
            block(qujian, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
