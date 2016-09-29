//
//  UIImage+Helper.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "UIImage+Helper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

@implementation UIImage (Helper)

+(UIImage *)imageFromContextWithColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect=(CGRect){{0.0f,0.0f},size};
    
    //开启一个图形上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    
    //获取图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    //获取图像
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *)imageFromContextWithColor:(UIColor *)color{
    
    CGSize size=CGSizeMake(1.0f, 1.0f);
    
    return [self imageFromContextWithColor:color size:size];
}


+ (UIImage *)createImageWithColor:(UIColor *)color
{
    return [UIImage imageFromContextWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

- (UIImage *)resizeImageWithCapInsets:(UIEdgeInsets)capInsets
{
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *image = nil;
    if (systemVersion >= 5.0) {
        image = [self resizableImageWithCapInsets:capInsets];
    }
    else {
        image = [self stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
    
    return image;
}

- (UIImage *)MLImageCrop_fixOrientation {
    
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    UIImageOrientation io = self.imageOrientation;
    if (io == UIImageOrientationDown || io == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
    }else if (io == UIImageOrientationLeft || io == UIImageOrientationLeftMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
    }else if (io == UIImageOrientationRight || io == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, 0, self.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        
    }
    
    if (io == UIImageOrientationUpMirrored || io == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }else if (io == UIImageOrientationLeftMirrored || io == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    if (io == UIImageOrientationLeft || io == UIImageOrientationLeftMirrored || io == UIImageOrientationRight || io == UIImageOrientationRightMirrored) {
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
    }else{
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage*)MLImageCrop_imageByCropForRect:(CGRect)targetRect
{
    targetRect.origin.x*=self.scale;
    targetRect.origin.y*=self.scale;
    targetRect.size.width*=self.scale;
    targetRect.size.height*=self.scale;
    
    if (targetRect.origin.x<0) {
        targetRect.origin.x = 0;
    }
    if (targetRect.origin.y<0) {
        targetRect.origin.y = 0;
    }
    
    //宽度高度过界就删去
    CGFloat cgWidth = CGImageGetWidth(self.CGImage);
    CGFloat cgHeight = CGImageGetHeight(self.CGImage);
    if (CGRectGetMaxX(targetRect)>cgWidth) {
        targetRect.size.width = cgWidth-targetRect.origin.x;
    }
    if (CGRectGetMaxY(targetRect)>cgHeight) {
        targetRect.size.height = cgHeight-targetRect.origin.y;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, targetRect);
    UIImage *resultImage=[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    //修正回原scale和方向
    resultImage = [UIImage imageWithCGImage:resultImage.CGImage scale:self.scale orientation:self.imageOrientation];
    
    return resultImage;
}

+(NSData *)setBeaconImgData:(NSData *)data WithBeaconInfo:(NSString *)info
{
    if(!data || [data length] == 0 ||!info || [info length] <= 0)
    {
        return nil;
    }
    
    CGImageSourceRef source =CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    NSDictionary * dict = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    NSMutableDictionary *metaDataDic = [dict mutableCopy];
    //设定exif信息
    NSMutableDictionary *exifDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyExifDictionary]mutableCopy];
    if(!exifDic)
    {
        exifDic = [NSMutableDictionary dictionary];
    }
    [exifDic setObject:info forKey:(NSString*)kCGImagePropertyExifUserComment];
    [metaDataDic setObject:exifDic forKey:(NSString*)kCGImagePropertyExifDictionary];
    //写进图片
    CFStringRef UTI = CGImageSourceGetType(source);
    NSMutableData * newImageData = [NSMutableData data];
    CGImageDestinationRef destination =CGImageDestinationCreateWithData((__bridge CFMutableDataRef)newImageData, UTI, 1,NULL);
    if(!destination)
    {
        return nil;
    }
    CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)metaDataDic);
    if(!CGImageDestinationFinalize(destination))
    {
        return nil;
    }
    CFRelease(destination);
    CFRelease(source);
    
    return newImageData;
}

+ (NSString *)getBeaconByImage:(NSData*)data
{
    NSString * beaconInfo = nil;
    CGImageSourceRef source =CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if(!source)
    {
        return nil;
    }
    NSDictionary * dd = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],(NSString*)kCGImageSourceShouldCache, nil];
    CFDictionaryRef dict =CGImageSourceCopyPropertiesAtIndex(source, 0, (__bridge CFDictionaryRef)dd);
    if(!dict)
    {
        return nil;
    }
    CFDictionaryRef exif =CFDictionaryGetValue(dict, kCGImagePropertyExifDictionary);
    if(exif)
    {
        beaconInfo = (__bridge NSString*)(CFDictionaryGetValue(exif, kCGImagePropertyExifUserComment));
    }
    
    CFRelease(dict);
    CFRelease(exif);
    CFRelease(exif);
    
    return beaconInfo;
}


#pragma mark -加文字水印
- (UIImage *) imageWithStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        UIGraphicsBeginImageContext([self size]);
    }
#endif
    
    //原图
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    //文字颜色
    [color set];
    
    //水印文字
    
    [markString sizeWithFont:font];
    
    CGSize markStringSize = [markString sizeWithFont:font constrainedToSize:CGSizeMake(rect.size.width,rect.size.height)];
    
    CGRect actualRect;
    
    actualRect.origin.x = (rect.size.width - markStringSize.width)/2;
    actualRect.origin.y = (rect.size.height - markStringSize.height)/2;
    actualRect.size.width = markStringSize.width;
    actualRect.size.height = markStringSize.height;
    
    [markString drawInRect:actualRect withFont:font];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

+(UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0,0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context,rect);
    
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)resizableImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius{
    CGFloat minEdgeSize = cornerRadius * 2 + 1;
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

- (UIImage*) imageWhiteColor2DestColor:(UIColor*)destColor
{
    // 分配内存
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
#if 0
        if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00)    // 将白色变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
        else
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 0; //0~255
            ptr[2] = 0;
            ptr[1] = 0;
            
        }
#endif
        
        if ((*pCurPtr & 0xFFFFFF00) == 0xFFFFFF00)
        {
            //*pCurPtr = 0xFF0000FF;
        }
        
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData (NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}


-(UIImage*)drawImage:(UIImage*)img
{
    UIGraphicsBeginImageContextWithOptions(self.size,NO,0.0f);
    
    [self drawInRect:CGRectMake(0, 0,self.size.width ,self.size.height)];
    [img drawInRect:CGRectMake(0,0,img.size.width, img.size.height)];
    
    UIImage* newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImg;
}

-(UIImage *)imageAtRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
}


- (UIImage *)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)gaussianImage:(UIImage *)origianlImage{
    if (origianlImage == nil) {
        return nil;
    }
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:origianlImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputRadius"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return image;
}

+ (UIImage *)resizeImage:(UIImage *)originImage
                  ToSize:(CGSize)finialSize
{
    CGSize originSize = originImage.size;
    if (originSize.height == 0 || originSize.height == 0) {
        NSLog(@"crop Image size error");
        return nil;
    }
    float originFactor = originSize.width*1.0f/originSize.height;
    float finalFactor = finialSize.width*1.0f/finialSize.height;
    
    if (originFactor < finalFactor) {
        CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage, CGRectMake(0, (originSize.height-finialSize.height*originSize.width*1.0f/finialSize.width)/2, originSize.width, finialSize.height*originSize.width*1.0f/finialSize.width));
        UIImage * calcedImage = [UIImage imageWithCGImage:imageRef];
        CFRelease(imageRef);
        return calcedImage;
    }else if (originFactor > finalFactor){
        CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage, CGRectMake((originSize.width-finialSize.width*originSize.height*1.0f/finialSize.height)/2, 0, originSize.height, finialSize.width*originSize.height*1.0f/finialSize.height));
        UIImage * calcedImage = [UIImage imageWithCGImage:imageRef];
        CFRelease(imageRef);
        return calcedImage;
    }else{
        return originImage;
    }
    return nil;
}

+ (BOOL)imageHasAlpha: (UIImage *)image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

+(UIImage *)imageWithBase64Data:(NSString *)imageSrc{
    if (imageSrc.length == 0) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString: imageSrc];
    NSData *data = [NSData dataWithContentsOfURL: url];
    UIImage *image = [UIImage imageWithData: data];
    
    return image;
}

+ (NSString *)base64DataWithImage: (UIImage *)image
{
    if (!image) {
        return nil;
    }
    
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([UIImage imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}
@end
