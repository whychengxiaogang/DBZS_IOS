//
//  UIImage+Helper.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIImage (Helper)

+(UIImage *)imageFromContextWithColor:(UIColor *)color;

+ (UIImage *)createImageWithColor:(UIColor *)color;

+(UIImage *)imageFromContextWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)resizeImageWithCapInsets:(UIEdgeInsets)capInsets;

- (UIImage*)MLImageCrop_imageByCropForRect:(CGRect)targetRect;

- (UIImage *)MLImageCrop_fixOrientation;

+ (NSData *)setBeaconImgData:(NSData *)data WithBeaconInfo:(NSString *)info;

+ (NSString *)getBeaconByImage:(NSData*)data;

- (UIImage *) imageWithStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font;

+(UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size;

+ (UIImage *)resizableImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
- (UIImage *) imageWhiteColor2DestColor:(UIColor*)destColor;

-(UIImage*)drawImage:(UIImage*)img;

/*!
 裁减
 @param rect 裁减区域
 @return UIImage
 */
- (UIImage *)imageAtRect:(CGRect)rect;

/*!
 等比例缩放
 @param size 新尺寸
 @return UIImage
 */
- (UIImage *)scaleToSize:(CGSize)size;

/*
 * 高斯模糊
 */
+ (UIImage *)gaussianImage:(UIImage *)origianlImage;

+ (UIImage *)resizeImage:(UIImage *)originImage
                  ToSize:(CGSize)finialSize;

+(UIImage *)imageWithBase64Data:(NSString *)imageSrc;

+ (NSString *)base64DataWithImage: (UIImage *)image;

@end
