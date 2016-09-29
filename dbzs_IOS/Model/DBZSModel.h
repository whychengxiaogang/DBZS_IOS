//
//  DBZSModel.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/10.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PLATFORM_TYPE){
    PLATFORM_TYPE_NETEASE = 1, // 网易一元夺宝
    PLATFORM_TYPE_YUNGOU = 2  // 一元云购
};

@protocol GoodsViewDelegate <NSObject>

- (void)goodsTaped:(int)goodsId;

@end

/* 
 获奖记录
 */
@interface DBZSWinnerModel : NSObject

@property (nonatomic, assign) int product_id; //一元夺宝的商品id，唯一值，和一元夺宝保持一致
@property (nonatomic, strong) NSString *time_id; //期号
@property (nonatomic, strong) NSString *total_times; //商品总需人次
@property (nonatomic, assign) int is_ok; //1为正在投注，2为投注完成
@property (nonatomic, assign) int win_user_id; //获奖人的id，跟网易对应（为0时处于正在投注（is_ok=1）或者正在开奖(is_ok=2)阶段）
@property (nonatomic, strong) NSString *win_username; //获奖人的姓名
@property (nonatomic, strong) NSString *win_number; //中奖号码
@property (nonatomic, assign) int rank; //获奖投注的位置
@property (nonatomic, assign) int win_bet_count; //获奖人该次投注的人次
@property (nonatomic, strong) NSString *qujian; // 区间

- (id)initWithJson:(NSDictionary *)dic;

+ (DBZSWinnerModel *)winnerModelWithJson:(NSDictionary *)dic;

@end

/*
  商品
 */
@interface DBZSProductModel : NSObject

@property (nonatomic, assign) int product_id; //一元夺宝的商品id，唯一值，和一元夺宝保持一致
@property (nonatomic, strong) NSString *title; //商品标题
@property (nonatomic, strong) NSString *pic; //图片url
@property (nonatomic, assign) int price; //商品价格

- (id)initWithJson:(NSDictionary *)dic;

+ (DBZSProductModel *)productModelWithJson:(NSDictionary *)dic;

@end

/*
 商品情况
 */
@interface DBZSNowModel : NSObject

@property (nonatomic, assign) int product_id; //一元夺宝的商品id，唯一值，和一元夺宝保持一致
@property (nonatomic, strong) NSString *time_id; //当前商品最新一期期号
@property (nonatomic, assign) int total_times; //商品总需人次
@property (nonatomic, assign) int remain_times; //商品剩余人次
@property (nonatomic, assign) int join_times; //商品参加人次

- (id)initWithJson:(NSDictionary *)dic;

+ (DBZSNowModel *)nowModelWithJson:(NSDictionary *)dic;

@end

/*
 区间
 */
@interface DBZSRegionModel : NSObject

@property (nonatomic, strong) NSString *qujian;
@property (nonatomic, assign) int win_count;
@property (nonatomic, assign) int per;
@property (nonatomic, assign) int lost;

- (id)initWithJson:(NSDictionary *)dic;

+ (DBZSRegionModel *)regionModelWithJson:(NSDictionary *)dic;

@end

