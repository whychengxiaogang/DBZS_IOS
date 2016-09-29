//
//  GoodsListView.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/17.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "GoodsListView.h"
#import "GoodsKeyWordViewCell.h"
#import "GoodsCardViewCell.h"
#import "GoodsHeadViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "SearchPlaceholderView.h"
#import "SearchGoodsViewCell.h"

static NSString *GoodsKeyWordViewCellIdentifier = @"GoodsKeyWordViewCellIdentifier";
static NSString *GoodsCardViewCellIdentifier = @"GoodsCardViewCellIdentifier";
static NSString *GoodsHeadViewCellIdentifier = @"GoodsHeadViewCellIdentifier";

static NSString *cleanKey = @" 清空 ";

@interface GoodsListView () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, GoodsKeyWordViewCellDelegate, GoodsViewDelegate>

@property (nonatomic, strong) UICollectionView *goodsCollectionView;
@property (nonatomic, strong) NSArray *hotData;
@property (nonatomic, strong) NSArray *lastNewData;
@property (nonatomic, strong) NSMutableArray *keyWordList;

@end

@implementation GoodsListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    self.goodsCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    self.goodsCollectionView.delegate = self;
    self.goodsCollectionView.dataSource = self;
    self.goodsCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.goodsCollectionView];
    
    [self.goodsCollectionView registerClass:[GoodsKeyWordViewCell class] forCellWithReuseIdentifier:GoodsKeyWordViewCellIdentifier];
    [self.goodsCollectionView registerClass:[GoodsCardViewCell class] forCellWithReuseIdentifier:GoodsCardViewCellIdentifier];
    [self.goodsCollectionView registerClass:[GoodsHeadViewCell class] forCellWithReuseIdentifier:GoodsHeadViewCellIdentifier];
    
    [self getHistoryData];
}

- (void)getHistoryData
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *dbzs_keywordList = [setting objectForKey:@"dbzs_keywordList"];
    if (dbzs_keywordList) {
        NSArray *array = [dbzs_keywordList componentsSeparatedByString:@","];
        if (array.count > 0) {
            self.keyWordList = [NSMutableArray arrayWithArray:array];
            [self.keyWordList addObject:cleanKey];
        }
        [self.goodsCollectionView reloadData];
    }
}

- (void)refreshData
{
    [self getHistoryData];
    [DBZSService hotPostsWithBlock:^(NSArray *posts, NSError *error) {
        self.hotData = posts;
        [self.goodsCollectionView reloadData];
    }];
    [DBZSService getNewPostsWithBlock:^(NSArray *posts, NSError *error) {
        self.lastNewData = posts;
        [self.goodsCollectionView reloadData];
    }];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.keyWordList.count;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return self.hotData.count;
    }
    if (section == 3) {
        return 1;
    }
    if (section == 4) {
        return self.lastNewData.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GoodsKeyWordViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsKeyWordViewCellIdentifier forIndexPath:indexPath];
        [cell configData:[self.keyWordList objectAtIndex:indexPath.row]];
        cell.delegate = self;
        if (indexPath.row == self.keyWordList.count - 1) {
            [cell showClose];
        }
        return cell;
    }
    if (indexPath.section == 1) {
        GoodsHeadViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsHeadViewCellIdentifier forIndexPath:indexPath];
        [cell configData:@"热门查询" imageName:@"search_hot"];
        return cell;
    }
    if (indexPath.section == 2) {
        GoodsCardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCardViewCellIdentifier forIndexPath:indexPath];
        [cell configData:[self.hotData objectAtIndex:indexPath.row]];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        GoodsHeadViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsHeadViewCellIdentifier forIndexPath:indexPath];
        [cell configData:@"最新上架" imageName:@"new_goods"];
        return cell;
    }
    if (indexPath.section == 4) {
        GoodsCardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GoodsCardViewCellIdentifier forIndexPath:indexPath];
        [cell configData:[self.lastNewData objectAtIndex:indexPath.row]];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

#pragma mark UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  [GoodsKeyWordViewCell calCellSize:[self.keyWordList objectAtIndex:indexPath.row]];
    }
    if (indexPath.section == 1) {
        return [GoodsHeadViewCell calCellSize];
    }
    if (indexPath.section == 2 && self.hotData.count > 0) {
        return [GoodsCardViewCell calCellSize:[self.hotData objectAtIndex:indexPath.row]];
    }
    if (indexPath.section == 3) {
        return [GoodsHeadViewCell calCellSize];
    }
    if (indexPath.section == 4 && self.lastNewData.count > 0) {
        return [GoodsCardViewCell calCellSize:[self.lastNewData objectAtIndex:indexPath.row]];
    }
    
    return CGSizeMake(SH_SCREEN_WIDTH, 10.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 25.0f;
    }
    if (section == 2 || section == 4) {
        return 10.0f;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        if (self.keyWordList.count == 0) {
            return UIEdgeInsetsMake(5.0f, 27.0f, 15.f, 5.0f);
        }
        return UIEdgeInsetsMake(16.0f, 27.0f, 15.f, 5.0f);
    }
    if (section == 2 || section == 4) {
        return UIEdgeInsetsMake(17.0f, 18.0f, 15.f, 0.0f);
    }
    return UIEdgeInsetsZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)cleanKeyword
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"dbzs_keywordList"];
    [setting synchronize];
    self.keyWordList = nil;
    [self.goodsCollectionView reloadData];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsListViewMove)]) {
        [self.delegate goodsListViewMove];
    }
}

#pragma mark GoodsKeyWordViewCellDelegate

- (void)keywordTaped:(NSString *)keyword
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchKeyWordTap:)]) {
        if ([keyword isEqualToString:cleanKey]) {
            [self cleanKeyword];
            return;
        }
        [self.delegate searchKeyWordTap:keyword];
    }
    return;
}

#pragma mark GoodsViewDelegate

- (void)goodsTaped:(int)goodsId
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsListViewGoodsTap:)]) {
        [self.delegate goodsListViewGoodsTap:goodsId];
    }
}

#pragma mark public

- (void)configHotData:(NSArray *)hotData
{
    self.hotData = hotData;
    [self.goodsCollectionView reloadData];
}

- (void)configLastNewData:(NSArray *)lastNewData
{
    self.lastNewData = lastNewData;
    [self.goodsCollectionView reloadData];
}

- (void)reloadSearchKeyWord
{
    [self getHistoryData];
}

@end
