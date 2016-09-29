//
//  LifeCircleControl.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (mogujieString)

+(NSString *)documentPath;
+(NSString *)cachePath;
+(NSString *)formatCurDate;
+(NSString *)formatCurDay;
+(NSString *)getAppVer;
- (NSString*)removeAllSpace;
- (NSURL *) toURL;
- (BOOL) isEmail;
- (BOOL) isEmpty;
- (NSString *) escapeHTML;
- (NSString *) unescapeHTML;
- (NSString *) stringByRemovingHTML;
- (NSString *) MD5;
- (NSString * )URLEncode;
-(NSString *)trim;

-(BOOL) isOlderVersionThan:(NSString*)otherVersion;
-(BOOL) isNewerVersionThan:(NSString*)otherVersion;

+ (NSString *)regularExpressionSearch:(NSString *)str rangeOfString:(NSString *)rangeOfString rangeOfStringSub:(NSString *)sub;

@end
