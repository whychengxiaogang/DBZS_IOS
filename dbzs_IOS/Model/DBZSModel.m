//
//  DBZSModel.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/10.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DBZSModel.h"

/*
 获奖记录
 */
@implementation DBZSWinnerModel

- (id)initWithJson:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.product_id = [dic intValueForKey:@"product_id"];
        self.time_id = [dic safeObjectForKey:@"time_id"];
        self.total_times = [dic safeObjectForKey:@"total_times"];
        self.win_user_id = [dic intValueForKey:@"win_user_id"];
        self.win_username = [dic safeObjectForKey:@"win_username"];
        self.rank = [dic intValueForKey:@"rank"];
        self.win_bet_count = [dic intValueForKey:@"win_bet_count"];
        self.win_number = [dic safeObjectForKey:@"win_number"];
        self.qujian = [dic safeObjectForKey:@"qujian"];
    }
    return self;
}

+ (DBZSWinnerModel *)winnerModelWithJson:(NSDictionary *)dic
{
    return [[DBZSWinnerModel alloc] initWithJson:dic];
}

@end

/*
  商品
 */
@implementation DBZSProductModel

- (id)initWithJson:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.product_id = [dic intValueForKey:@"product_id"];
        self.title = [dic safeObjectForKey:@"title"];
        self.pic = [dic safeObjectForKey:@"pic"];
        self.price = [dic intValueForKey:@"price"];
        if ([dic safeObjectForKey:@"pid"]) {
            self.product_id = [dic intValueForKey:@"pid"];
        }
        if ([dic safeObjectForKey:@"name"]) {
            self.title = [dic safeObjectForKey:@"name"];
        }
    }
    return self;
}

+ (DBZSProductModel *)productModelWithJson:(NSDictionary *)dic
{
    return [[DBZSProductModel alloc] initWithJson:dic];
}

@end

/*
 商品情况
 */
@implementation DBZSNowModel

- (id)initWithJson:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.product_id = [dic intValueForKey:@"product_id"];
        self.time_id = [dic safeObjectForKey:@"time_id"];
        self.total_times = [dic intValueForKey:@"total_times"];
        self.remain_times = [dic intValueForKey:@"remain_times"];
        self.join_times = self.total_times - self.remain_times;
    }
    return self;
}

+ (DBZSNowModel *)nowModelWithJson:(NSDictionary *)dic
{
    return [[DBZSNowModel alloc] initWithJson:dic];
}

@end

/*
 区间
 */
@implementation DBZSRegionModel

- (id)initWithJson:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.qujian = [dic safeObjectForKey:@"qujian"];
        self.win_count = [dic intValueForKey:@"win_count"];
        self.per = [dic intValueForKey:@"per"];
        self.lost = [dic intValueForKey:@"lost"];
    }
    return self;
}

+ (DBZSRegionModel *)regionModelWithJson:(NSDictionary *)dic
{
    return [[DBZSRegionModel alloc] initWithJson:dic];
}

@end

